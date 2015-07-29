//
//  ServiceEndpoints.h
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceEndpoints : NSObject

+(BOOL) isHostReachable;
+(NSString *)getHostnameForSelectedEnvironment;
+(NSString *)getEndpointURL:(id)serviceType;

@end
