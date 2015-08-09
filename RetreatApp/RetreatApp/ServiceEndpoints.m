//
//  ServiceEndpoints.m
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "ServiceEndpoints.h"
#import "SettingsManager.h"

typedef NS_ENUM(NSInteger, RALocation) {
    RALocationBar,
    RALocationLobby,
    RALocationGolf,
    RALocationLawnGames,
    RALocationSpa,
    RALocationZipline,
    RALocationOutdoorActivity,
    RALocationTown,
    RALocationBanquet,
    RALocationAfterParty
};


@interface ServiceEndpoints()
@end

@implementation ServiceEndpoints

+(BOOL)isHostReachable
{
    return true;
}

+(NSString *)getHostnameForSelectedEnvironment
{
    return @"http://tpartyservice-dev.elasticbeanstalk.com/home/checkin?";

}

+(NSString *)getEndpointURL:(NSString *)endpoint
{
    if ([endpoint isEqualToString:@"checkin"]) {
        return @"http://tpartyservice-dev.elasticbeanstalk.com/home/checkin?";
    } else if ([endpoint isEqualToString:@"pollLocations"]) {
        return @"http://tpartyservice-dev.elasticbeanstalk.com/home/pollparticipantlocations";
    } else {
        return @"error";
    }
}

@end

