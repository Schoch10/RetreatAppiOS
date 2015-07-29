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
    NetworkStatus networkStatus = [[Reachability reachabilityWithHostName:[ServiceEndpoints getHostnameForSelectedEnvironment]] currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        SCLogMessage(kLogLevelDebug, @"Service host %@ not reachable", [self getHostnameForSelectedEnvironment]);
        return false;
    } else {
        return true;
    }
}

+(NSString *)getHostnameForSelectedEnvironment
{
    return @"test";
}

+(NSString *)getEndpointURL:(NSString *)serviceType
{
    return @"test";
}


@end

