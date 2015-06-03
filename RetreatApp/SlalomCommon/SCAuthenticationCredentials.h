//
//  SCAuthenticationCredentials.h
//  SlalomCommon
//
//  Created by Om Vyas on 3/29/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAuthenticationCredentials : NSObject

@property (strong, nonatomic, readonly) NSString *userId;
@property (strong, nonatomic, readonly) NSString *password;
@property (strong, nonatomic, readonly) NSString *authToken;

- (id) initForUserId: (NSString *) userIdParam
        withPassword: (NSString *) passwordParam
       withAuthToken: (NSString *) authTokenParam;

@end




