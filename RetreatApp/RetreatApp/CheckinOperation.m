//
//  CheckinOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/7/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CheckinOperation.h"
#import "CoreDataManager.h"

@implementation CheckinOperation

- (id)initCheckinOperationWithLocationForUser:(NSNumber *)userId withLocation:(NSNumber *)locationId {
    
    if(self = [super initWithMethod:RESTMethodPost
                        forEndpoint:@"checkin"
                         withParams:@{@"userId": userId, @"locationId": locationId}])
    {
        self.delegate = self;
        self.locationId = locationId;
    }
    
    return self;
}

#pragma mark - MTServiceOperationDelegate Methods

-(void)serviceTaskDidReceiveResponseJSON:(id)responseJSON
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.checkinOperationDelegate checkinOperationDidSucceed];
    });
}

- (void)serviceTaskDidFailToCompleteRequest:(NSError *)error {
    SCLogMessage(kLogLevelDebug, @"error");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.checkinOperationDelegate checkinOperationDidFailWithError:error];
    });
}

- (void)serviceTaskDidReceiveStatusFailure:(HttpStatusCode)httpStatusCode {
    SCLogMessage(kLogLevelDebug, @"error");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        [self.checkinOperationDelegate checkinOperationDidFailWithError:error];
    });
}

@end
