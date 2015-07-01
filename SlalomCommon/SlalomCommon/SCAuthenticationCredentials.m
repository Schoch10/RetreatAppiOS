//
//  SCAuthenticationCredentials.m
//  SlalomCommon
//
//  Created by Om Vyas on 3/29/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "SCAuthenticationCredentials.h"

@implementation SCAuthenticationCredentials

@synthesize userId, password, authToken;

- (id) initForUserId: (NSString *) userIdParam
        withPassword: (NSString *) passwordParam
       withAuthToken: (NSString *) authTokenParam
{
    userId = userIdParam;
    password = passwordParam;
    authToken = authTokenParam;
    
    return self;
}

@end
