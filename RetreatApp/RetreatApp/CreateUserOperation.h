//
//  CreateUserOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SCOperation.h"

@interface CreateUserOperation : SCOperation

- (instancetype)initUserWithUserName:(NSString *)username;

@property (strong, nonatomic) NSString *username;

@end
