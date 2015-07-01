//
//  CheckinOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SCOperation.h"

@interface CheckinOperation : SCOperation

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *location;

- (instancetype)initForUser:(NSString *)username withLocation:(NSString *)location;

@end
