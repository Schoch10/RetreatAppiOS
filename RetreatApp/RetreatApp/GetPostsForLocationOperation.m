//
//  GetPostsForLocationOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/10/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "GetPostsForLocationOperation.h"
#import "CoreDataManager.h"
#import "Post+Extensions.h"
#import "User.h"

@implementation GetPostsForLocationOperation

- (id)initGetPostsOperationForLocationId:(NSNumber *)locationId {
    
    if (self = [super initWithMethod:RESTMethodGet
                         forEndpoint:@"getPosts"
                          withParams:@{@"locationId": [locationId stringValue]}] ) {
        self.delegate = self;
    }
    return self;
}

- (void)serviceTaskDidReceiveResponseJSON:(id)responseJSON {
    CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *managedObjectContext = coreDataManager.operationContext;
    for (NSDictionary *postDictionary in responseJSON) {
        NSNumber *postId = postDictionary[@"PostId"];
        Post *post = [Post postUpsertWithPostId:postId inManagedObjectContext:managedObjectContext];
        id postTextJSON = postDictionary[@"PostText"];
        if ([postTextJSON isKindOfClass:[NSString class]]) {
            post.comment = postTextJSON;
        } else {
            SCLogMessage(kLogLevelDebug, @"Error");
        }
        id postLocationId = postDictionary[@"LocationId"];
        if ([postLocationId isKindOfClass:[NSNumber class]]) {
            post.locationId = postLocationId;
        } else {
            SCLogMessage(kLogLevelDebug, @"Error");
        }
        id postImageURL = postDictionary[@"S3ImageUrl"];
        if ([postImageURL isKindOfClass:[NSString class]]) {
            post.imageURL = postTextJSON;
        } else {
            SCLogMessage(kLogLevelDebug, @"Error");
        }
        id postUserId = postDictionary[@"UserId"];
        if ([postUserId isKindOfClass:[NSNumber class]]) {
            post.userid = postUserId;
        } else {
            SCLogMessage(kLogLevelDebug, @"Error");
        }
        id postUserName = postDictionary[@"UserName"];
        if ([postUserName isKindOfClass:[NSString class]]) {
            post.username = postUserName;
        } else {
            SCLogMessage(kLogLevelDebug, @"Error");
        }
    }
    BOOL saved = [coreDataManager saveContext:managedObjectContext];
    if (saved) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.getPostsForLocationDelegate getPostsForLocationDidSucceed];
        });
    } else {
        SCLogMessage(kLogLevelError, @"No posts saved");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            [self.getPostsForLocationDelegate getPostsForLocationDidFailWithError:error];
        });
    }
}

@end
