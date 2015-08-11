//
//  Post+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Post+Extensions.h"
#import "CoreDataManager.h"

@implementation Post (Extensions)

+ (NSMutableDictionary *)postMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *postMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        postMap = [coreDataManager objectUriMap:@"Post" keyName:@"postID" context:context];
    });
    return postMap;
}


+ (Post *)postUpsertWithPostId:(NSNumber *)postId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext {
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *postMap = [self postMapInContext:context];
        NSURL *objectUri = [postMap objectForKey:postId];
        
        Post *post = nil;
        if(objectUri) {
            post = (Post *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!post) {
            post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
            post.postID = postId;
            [context obtainPermanentIDsForObjects:@[post] error:nil];
            [postMap setObject:post.objectID.URIRepresentation forKey:postId];
        }
        return post;
    }
}

@end
