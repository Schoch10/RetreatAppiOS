//
//  AddLocationsOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "AddLocationsOperation.h"
#import "CoreDataManager.h"
#import "Location+Extensions.h"
#import "ServiceCoordinator.h"

@implementation AddLocationsOperation

-(instancetype)initLocations {
    self = [super init];
    return self;
}

- (void)doWork {
    CoreDataManager *coreData = [CoreDataManager sharedManager];
    NSManagedObjectContext *managedObjectContext = coreData.operationContext;
    NSArray *locations = @[@"The Cave", @"Lobby and Terrace", @"Golf", @"Lawn Games", @"Spa", @"Outdoor Activities/Town", @"Stickney's", @"Pool", @"Presidential Foyer", @"Afterparty"];
    for (int i=0; i < locations.count; i++) {
        Location *location = [Location locationUpsertWithLocationId:@(i+3) inManagedObjectContext:managedObjectContext];
        location.locationName = [locations objectAtIndex:i];
    }
    [coreData saveContext:managedObjectContext];
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}

@end
