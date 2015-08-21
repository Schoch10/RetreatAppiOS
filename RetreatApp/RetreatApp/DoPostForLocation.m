//
//  DoPostForLocation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/10/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "DoPostForLocation.h"

@implementation DoPostForLocation

- (id)initDoPostForUser:(NSNumber *)userId forLocation:(NSNumber *)locationId withText:(NSString *)postText {
    if (self = [super initWithMethod:RESTMethodPost
                         forEndpoint:@"doPost"
                          withParams:@{@"userId": userId, @"locationId": [locationId stringValue], @"posttext": postText}]) {
        self.delegate = self;
    }
    return self;
}

- (id)initDoPostForUser:(NSNumber *)userId forLocation:(NSNumber *)locationId withText:(NSString *)postText withImage:(NSData *)postImage {
    if (self = [super initWithMethod:RESTMethodPost
                         forEndpoint:@"doPost"
                          withParams:@{@"userId": userId, @"locationId": [locationId stringValue], @"posttext": postText, @"postImage": postImage}]) {
        self.delegate = self;
    }
    return self;
}

- (void)serviceTaskDidReceiveResponseJSON:(id)responseJSON {
    SCLogMessage(kLogLevelDebug, @"do PostResponse %@", responseJSON);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.doPostForLocationDelegate doPostForLocationDidSucceed];
    });
    
}

- (void)serviceTaskDidFailToCompleteRequest:(NSError *)error {
    SCLogMessage(kLogLevelDebug, @"Error %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.doPostForLocationDelegate doPostForLocationDidFailWithError:error];
    });
}

- (void)serviceTaskDidReceiveStatusFailure:(HttpStatusCode)httpStatusCode {
    SCLogMessage(kLogLevelDebug, @"Error");
}

@end
