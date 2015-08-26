//
//  UIImage+Loading.m
//  SlalomCommon
//
//  Created by Greg Martin on 7/1/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "UIImage+Loading.h"
#import "SCFileUtil.h"

static NSMutableDictionary *_cache = nil;

@implementation UIImage (Loading)

+ (UIImage *)imageInDocumentsDirectory:(NSString *)absolutePath
{
    return [UIImage cachedImage:absolutePath];
}

+ (UIImage *)imageInCachesDirectory:(NSString *)absolutePath
{
    return [UIImage cachedImage:absolutePath];
}

+ (void)clearCache
{
    @synchronized(self)
    {
        if (_cache)
        {
            [_cache removeAllObjects];
        }
    }
}

+ (BOOL)imageIsCached:(NSString *)absolutePath
{
    @synchronized(self)
    {
        if (absolutePath == nil) return NO;
        
        return [_cache objectForKey:absolutePath] ? YES : NO;
    }
}

+ (UIImage *)cachedImage:(NSString *)absolutePath
{
    @synchronized(self)
    {
        if (absolutePath == nil) return nil;
        
        if (_cache == nil)
        {
            _cache = [[NSMutableDictionary alloc] init];
        }
        
        // look for cached version
        UIImage *cachedImage = [_cache objectForKey:absolutePath];
        
        if (cachedImage)
        {
            return cachedImage;
        }
        
        // load from disk and cache
        UIImage *image = [UIImage imageWithContentsOfFile:absolutePath];
        
        if (image)
        {
            [_cache setObject:image forKey:absolutePath];
        }
        
        return image;
    }
}

+ (void)asyncImageInDocumentsDirectory:(NSString *)absolutePath completion:(void (^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @autoreleasepool
        {
            UIImage *image = [UIImage imageInDocumentsDirectory:absolutePath];
            
            // Display on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion)
                {
                    completion(image);
                }
            });
        }
    });
}

+ (void)asyncImageInCachesDirectory:(NSString *)absolutePath completion:(void (^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @autoreleasepool
        {
            UIImage *image = [UIImage imageInCachesDirectory:absolutePath];
            
            // Display on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completion)
                {
                    completion(image);
                }
            });
        }
    });
}

@end
