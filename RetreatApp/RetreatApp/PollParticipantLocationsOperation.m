//
//  PollParticipantLocationsOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/7/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "PollParticipantLocationsOperation.h"
#import "CoreDataManager.h"
#import "SettingsManager.h"
#import "Checkin+Extensions.h"
#import "Location+Extensions.h"

@implementation PollParticipantLocationsOperation

- (id)initPollParticipantOperation {
    
    if(self = [super initWithMethod:RESTMethodGet
                        forEndpoint:@"pollLocations"
                         withParams:nil])
    {
        self.delegate = self;
    }
    
    return self;
}

#pragma mark - MTServiceOperationDelegate Methods
-(void)serviceTaskDidReceiveResponseJSON:(id)responseJSON
{
    CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *managedObjectContext = [coreDataManager operationContext];
    for (NSDictionary *pollDictionary in responseJSON) {
        NSNumber *checkinID = pollDictionary[@"CheckinId"];
        NSNumber *userID = pollDictionary[@"UserId"];
        Checkin *checkin = [Checkin checkinUpsertWithUserId:userID inManagedObjectContext:managedObjectContext];
        checkin.checkinID = checkinID;
        id checkinTimeStamp = pollDictionary[@"CheckinTimeStamp"];
        if ([checkinTimeStamp isKindOfClass:[NSDate class]]) {
            checkin.checkinDate = checkinTimeStamp;
        } else {
            SCLogMessage(kLogLevelDebug, @"timestamp error");
        }
        id checkinLocation = pollDictionary[@"Location"];
        if ([checkinLocation isKindOfClass:[NSString class]]) {
        } else {
            SCLogMessage(kLogLevelDebug, @"error");
        }
        id checkinLocationId = pollDictionary[@"LocationId"];
        if ([checkinLocationId isKindOfClass:[NSNumber class]]) {
            NSNumber *locationId = checkinLocationId;
            Location *location = [Location locationUpsertWithLocationId:locationId inManagedObjectContext:managedObjectContext];
            checkin.checkinLocation = location;
        } else {
            SCLogMessage(kLogLevelDebug, @"error");
        }
        id checkinUserName = pollDictionary[@"UserName"];
        if ([checkinUserName isKindOfClass:[NSString class]]) {
            checkin.username = checkinUserName;
        } else {
            SCLogMessage(kLogLevelDebug, @"error");
        }
    }
    BOOL saved = [coreDataManager saveContext:managedObjectContext];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (saved) {
            [self.pollParticipantDelegate pollParticipantLocationDidSucceed];
        } else {
            NSError *error;
            [self.pollParticipantDelegate pollParticipantLocationDidFailWithError:error];
        }
    });
}

-(void)serviceTaskDidReceiveStatusFailure:(HttpStatusCode)httpStatusCode
{
    SCLogMessage(kLogLevelError, @"Failed status code %li", (long)httpStatusCode);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pollParticipantDelegate pollParticipantLocationDidFailWithError:nil];
    });
}

-(void)serviceTaskDidFailToCompleteRequest:(NSError *)error
{
    SCLogMessage(kLogLevelError, @"Failed with error: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pollParticipantDelegate pollParticipantLocationDidFailWithError:error];
    });
}


@end
