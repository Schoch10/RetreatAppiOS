//
//  CreateUserNetworkOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/10/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"

@protocol CreateUserNetworkOperationDelegate <NSObject>

- (void)createUserNetworkOperationDidSucceedWithUserId:(NSNumber *)userId;
- (void)createUserNetworkOperationDidFail:(NSError *)error;

@end

@interface CreateUserNetworkOperation : RetreatAppServiceConnectionOperation <RetreatServiceTaskDelegate>

- (id)initCreateUserOperationWithUsername:(NSString *)username;

@property (nonatomic, weak) id<CreateUserNetworkOperationDelegate> createUserOperationDelegate;
@property (nonatomic, strong) NSString *username;


@end
