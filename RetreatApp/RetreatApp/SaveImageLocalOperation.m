//
//  SaveImageLocalOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SaveImageLocalOperation.h"
#import "CoreDataManager.h"
#import "Post.h"


@implementation SaveImageLocalOperation

- (instancetype)initWithPostId:(NSNumber *)postId withImage:(NSData *)imageData {
    self = [super init];
    if (self) {
        self.postId = postId;
        self.imageData = imageData;
    }
    return self;
}

- (void)doWork {
    CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *backgroundContext = coreDataManager.operationContext;
    NSFetchRequest *currentPostFetch = [[NSFetchRequest alloc]initWithEntityName:@"Post"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", self.postId];
    currentPostFetch.predicate = predicate;
    NSError *error = nil;
    NSArray *currentPostArray = [backgroundContext executeFetchRequest:currentPostFetch error:&error];
    if (currentPostArray != nil) {
        Post *currentPost = [currentPostArray objectAtIndex:0];
        currentPost.imageCache = self.imageData;
    }
}

@end
