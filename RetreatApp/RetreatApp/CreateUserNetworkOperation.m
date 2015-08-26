//
//  CreateUserNetworkOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/10/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CreateUserNetworkOperation.h"
#import "CoreDataManager.h"
#import "User+Extensions.h"
#import "SettingsManager.h"

@implementation CreateUserNetworkOperation

- (id)initCreateUserOperationWithUsername:(NSString *)username {
    
    if(self = [super initWithMethod:RESTMethodPost
                        forEndpoint:@"createUser"
                         withParams:@{@"userName": username}])
    {
        self.delegate = self;
        self.username = username;
    }
    
    return self;
}

#pragma mark - MTServiceOperationDelegate Methods

-(void)serviceTaskDidReceiveResponseJSON:(id)responseJSON
{
    NSNumber *userIdFromJSON = responseJSON;
    if ([responseJSON intValue] == -1) {
        NSError *error = nil;
        [self serviceTaskDidFailToCompleteRequest:error];
    } else {
        CoreDataManager *coreData = [CoreDataManager sharedManager];
        NSManagedObjectContext *context = coreData.operationContext;
        User *user = [User userUpsertWithUserId:userIdFromJSON inManagedObjectContext:context];
        user.name = self.username;
        BOOL saved = [coreData saveContext:context];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (saved) {
                [self.createUserOperationDelegate createUserNetworkOperationDidSucceedWithUserId:userIdFromJSON];
            } else {
                NSError *error;
                error = [NSError errorWithDomain:ErrorCodeCoreDataFailedSave code:1 userInfo:@{@"createUser": @"Create User Failed"}];
                [self.createUserOperationDelegate createUserNetworkOperationDidFail:error];
            }
        });
    }
}

- (void)serviceTaskDidFailToCompleteRequest:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.createUserOperationDelegate createUserNetworkOperationDidFail:error];
    });
}

- (void)serviceTaskDidReceiveStatusFailure:(HttpStatusCode)httpStatusCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        [self.createUserOperationDelegate createUserNetworkOperationDidFail:error];
    });
}

@end
