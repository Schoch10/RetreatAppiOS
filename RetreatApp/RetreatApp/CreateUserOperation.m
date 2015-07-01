//
//  CreateUserOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CreateUserOperation.h"
#import "CoreDataManager.h"
#import "User+Extensions.h"
#import "ServiceCoordinator.h"

@implementation CreateUserOperation

- (instancetype)initUserWithUserName:(NSString *)username
{
    self = [super init];
    if (self) {
        self.username = username;
    }
    return self;
}

- (void)doWork
{
    CoreDataManager *coreData = [CoreDataManager sharedManager];
    NSManagedObjectContext *context = coreData.operationContext;
    User *user = [User userUpsertWithUserId:@(0) inManagedObjectContext:context];
    user.name = self.username;
    [coreData saveContext:context];
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}


@end
