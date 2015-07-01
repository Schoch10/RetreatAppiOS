//
//  CheckinOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CheckinOperation.h"
#import "CoreDataManager.h"
#import "ServiceCoordinator.h"
#import "Checkin+Extensions.h"


@implementation CheckinOperation

- (instancetype)initForUser:(NSString *)username withLocation:(NSString *)location
{
    self = [super init];
    if (self) {
        self.username = username;
        self.location = location;
    }
    return self;
}

- (void)doWork
{
    CoreDataManager *coreData = [CoreDataManager sharedManager];
//    NSManagedObjectContext *context = coreData.operationContext;
//    Checkin *checkin = [Checkin checkinUpsertWithCheckinId:@(0) forUser:self.username forLocation:self.location inManagedObjectContext:context];
 //   [coreData saveContext:context];
   // [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}
@end
