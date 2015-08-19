//
//  Checkin+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Checkin+Extensions.h"
#import "Location+Extensions.h"
#import "CoreDataManager.h"

@implementation Checkin (Extensions)

+ (NSMutableDictionary *)checkinMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *checkinMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        checkinMap = [coreDataManager objectUriMap:@"Checkin" keyName:@"userId" context:context];
    });
    return checkinMap;
}


+ (Checkin *)checkinUpsertWithUserId:(NSNumber *)userId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext {
    
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *checkinMap = [self checkinMapInContext:context];
        NSURL *objectUri = [checkinMap objectForKey:userId];
        
        Checkin *checkin = nil;
        if(objectUri) {
            checkin = (Checkin *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!checkin) {
            checkin = [NSEntityDescription insertNewObjectForEntityForName:@"Checkin" inManagedObjectContext:context];
            checkin.userId = userId;
            [context obtainPermanentIDsForObjects:@[checkin] error:nil];
            [checkinMap setObject:checkin.objectID.URIRepresentation forKey:userId];
        }
        return checkin;
    }
}

+ (NSInteger)getCheckinCountForLocation:(NSNumber *)locationId inManagedObjectContext: (NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Checkin"];
    NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"checkinLocation.locationId == %@", locationId];
    fetchRequest.predicate = locationPredicate;
    NSError *error = nil;
    NSArray *checkinsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return checkinsArray.count;    
}


@end
