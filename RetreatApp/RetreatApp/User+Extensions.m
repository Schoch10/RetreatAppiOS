//
//  User+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "User+Extensions.h"
#import "CoreDataManager.h"

@implementation User (Extensions)

+ (NSMutableDictionary *)gameMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *userMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        userMap = [coreDataManager objectUriMap:@"User" keyName:@"userID" context:context];
    });
    return userMap;
}


+ (User *)userUpsertWithUserId:(NSNumber *)userId inManagedObjectContext:(NSManagedObjectContext *)backgroundContext
{
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *userMap = [self gameMapInContext:context];
        NSURL *objectUri = [userMap objectForKey:userId];
        
        User *user = nil;
        if(objectUri) {
            user = (User *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!user) {
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            user.userID = userId;
            [context obtainPermanentIDsForObjects:@[user] error:nil];
            [userMap setObject:user.objectID.URIRepresentation forKey:userId];
        }
        return user;
    }
}


@end
