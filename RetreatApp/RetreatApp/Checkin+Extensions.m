//
//  Checkin+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Checkin+Extensions.h"
#import "CoreDataManager.h"

@implementation Checkin (Extensions)

+ (NSMutableDictionary *)checkinMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *checkinMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        checkinMap = [coreDataManager objectUriMap:@"Checkin" keyName:@"checkinID" context:context];
    });
    return checkinMap;
}


+ (Checkin *)checkinUpsertWithCheckinId:(NSNumber *)checkinId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext {
    
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *checkinMap = [self checkinMapInContext:context];
        NSURL *objectUri = [checkinMap objectForKey:checkinId];
        
        Checkin *checkin = nil;
        if(objectUri) {
            checkin = (Checkin *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!checkin) {
            checkin = [NSEntityDescription insertNewObjectForEntityForName:@"Checkin" inManagedObjectContext:context];
            checkin.checkinID = checkinId;
            [context obtainPermanentIDsForObjects:@[checkin] error:nil];
            [checkinMap setObject:checkin.objectID.URIRepresentation forKey:checkinId];
        }
        return checkin;
    }
}

@end
