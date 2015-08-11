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
        Checkin *checkin = [Checkin checkinUpsertWithCheckinId:checkinID inManagedObjectContext:managedObjectContext];
        id checkinTimeStamp = pollDictionary[@"CheckinTimeStamp"];
        if ([checkinTimeStamp isKindOfClass:[NSDate class]]) {
            checkin.checkinDate = checkinTimeStamp;
        } else {
            SCLogMessage(kLogLevelDebug, @"timestamp error");
        }
        id checkinLocation = pollDictionary[@"Location"];
        if ([checkinLocation isKindOfClass:[NSString class]]) {
            checkin.location = checkinLocation;
        } else {
            SCLogMessage(kLogLevelDebug, @"error");
        }
        id checkinLocationId = pollDictionary[@"LocationId"];
        if ([checkinLocationId isKindOfClass:[NSNumber class]]) {
            checkin.locationId = checkinLocationId;
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
    if (saved) {
        SCLogMessage(kLogLevelDebug, @"saved");
    } else {
        SCLogMessage(kLogLevelError, @"No checkins saved");
    }
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
