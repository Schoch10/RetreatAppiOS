//
//  Location+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Location+Extensions.h"
#import "CoreDataManager.h"

@implementation Location (Extensions)

+ (NSMutableDictionary *)locationMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *locationMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        locationMap = [coreDataManager objectUriMap:@"Location" keyName:@"locationId" context:context];
    });
    return locationMap;
}


+ (Location *)locationUpsertWithLocationId:(NSNumber *)locationId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext {
    
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *locationMap = [self locationMapInContext:context];
        NSURL *objectUri = [locationMap objectForKey:locationId];
        
        Location *location = nil;
        if(objectUri) {
            location = (Location *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!location) {
            location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
            location.locationId = locationId;
            [context obtainPermanentIDsForObjects:@[location] error:nil];
            [locationMap setObject:location.objectID.URIRepresentation forKey:locationId];
        }
        return location;
    }
}


@end
