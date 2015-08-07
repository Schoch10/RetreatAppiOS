//
//  ServiceEndpoints.m
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "ServiceEndpoints.h"
#import "SettingsManager.h"

@interface ServiceEndpoints()
@end

@implementation ServiceEndpoints

+(BOOL)isHostReachable
{
    return true;
}

+(NSString *)getHostnameForSelectedEnvironment
{
    return @"http://tpartyservice-dev.elasticbeanstalk.com/home/pollparticipantlocations";

}

+(NSString *)getEndpointURL:(NSString *)serviceType
{
    return @"http://tpartyservice-dev.elasticbeanstalk.com/home/pollparticipantlocations";
}


@end

