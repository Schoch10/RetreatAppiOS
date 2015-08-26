//
//  DownloadImageOperation.m
//  RetreatApp
//
//  Created by Quinn MacKenzie on 8/25/15.
//  Copyright (c) 2013 Slalom Consulting. All rights reserved.
//

#import "DownloadImageOperation.h"
#import "ServiceCoordinator.h"
#import "SCFileUtil.h"
#import "NSString+Extensions.h"
#import "UIImage+Loading.h"

@implementation DownloadImageOperation

- (id)init
{
    if (self = [super init])
    {
        self.successSelector = @selector(downloadImageOperationDidSucceedWithUserInfo:);
        self.failureSelector = @selector(downloadImageOperationDidFailWithError:);
    }
    
    return self;
}

+ (DownloadImageOperation *)operationForUri:(NSString *)uri
{
    @synchronized(self)
    {
        NSOperationQueue *queue = [ServiceCoordinator imageOperationQueue];
        NSArray *runningOperations = queue.operations;
        
        for (DownloadImageOperation *operation in runningOperations)
        {
            if ([operation.imageUri caseInsensitiveCompare:uri] == NSOrderedSame)
            {
                return operation;
            }
        }
        
        return nil;
    }
}

+ (id)queueOperation:(DownloadImageOperation *)operation
{
    if (!operation || [NSString isNullOrEmpty:operation.imageUri])
    {
        return nil;
    }
    
    @synchronized(self)
    {
        DownloadImageOperation *existingOp = [DownloadImageOperation operationForUri:operation.imageUri];
        
        // we have an existing op that is going to handle the download, so make this op dependent on that one's completion
        if (existingOp)
        {
            if ([existingOp.delegate isEqual:operation.delegate])
            {
                SCLogMessage(kLogLevelDebug, @"Found existing operation with this same delegate.");
                return existingOp;
            }
            
            if (existingOp.delegate == nil)
            {
                SCLogMessage(kLogLevelDebug, @"Found existing operation with a NIL delegate");
                existingOp.delegate = operation.delegate;
                return existingOp;
            }
            
            SCLogMessage(kLogLevelDebug, @"Found existing operation. Adding a dependency: %@", operation.imageUri);
            [operation addDependency:existingOp];
        }
        
        [[ServiceCoordinator imageOperationQueue] addOperation:operation];
        
        return operation;
    }
}

+ (id)queueWithDelegate:(id<DownloadImageOperationDelegate>)delegate imageUri:(NSString *)imageUri
{
    return [DownloadImageOperation queueWithDelegate:delegate imageUri:imageUri filename:[imageUri cleanFilename]];
}

+ (id)queueWithDelegate:(id<DownloadImageOperationDelegate>)delegate imageUri:(NSString *)imageUri filename:(NSString *)filename
{
    if (!imageUri)
    {
        return nil;
    }
    
    DownloadImageOperation *operation = [[DownloadImageOperation alloc] init];
    operation.queuePriority = NSOperationQueuePriorityNormal;
    operation.delegate = delegate;
    operation.imageUri = imageUri;
    operation.filename = [filename cleanFilename];
    
    NSString *imageId = [filename stringByDeletingPathExtension];
    operation.downloadPath = [SCFileUtil cachePath:imageId];
    
    return [DownloadImageOperation queueOperation:operation];
}

+ (void)asyncImageUri:(NSString *)uri delegate:(id<DownloadImageOperationDelegate>)delegate completion:(void (^)(UIImage *image))completion
{
    [DownloadImageOperation asyncImageUri:uri filename:[uri cleanFilename] delegate:delegate completion:completion];
}

+ (void)asyncImageUri:(NSString *)uri filename:(NSString *)filename delegate:(id<DownloadImageOperationDelegate>)delegate completion:(void (^)(UIImage *image))completion
{
    filename = [filename cleanFilename];
    NSString *path = [SCFileUtil cachePath:filename];
    
    if ([UIImage imageIsCached:path])
    {
        if (completion)
        {
            completion([UIImage cachedImage:path]);
        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *image = nil;
            
            if (path)
            {
                image = [UIImage imageInCachesDirectory:path];
            }
            
            if (!image)
            {
                DownloadImageOperation *op = [DownloadImageOperation queueWithDelegate:delegate imageUri:uri filename:filename];
                
                [delegate setDownloadImageOperation:op];
            }
            
            // Display on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion)
                {
                    completion(image);
                }
            });
        });
    }
}

- (void)doWork
{
    NSURL *url = nil;
    
    // if a file already exists at the download location, then don't bother getting it again.
    if (![NSString isNullOrEmpty:self.downloadPath]
        && [[NSFileManager defaultManager] fileExistsAtPath:self.downloadPath])
    {
        [self notifyOfSuccess:@{kImagePathKey: self.downloadPath}];
        
        return;
    }
    else if (![NSString isNullOrEmpty:self.imageUri])
    {
        url = [NSURL URLWithString:self.imageUri];
    }
    
    // Only proceed if the above produced a valid URL
    if (url)
    {
        [self startRequest:[NSMutableURLRequest requestWithURL:url]];
    }
    else
    {
        [self notifyOfFailure:nil];
    }
}

- (void)handleSucceeded:(NSDictionary *)jsonObject
{
    [self notifyOfSuccess:@{kImagePathKey: self.downloadPath}];
}

@end