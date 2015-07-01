//
//  SettingsManager.h
//  RetreatApp
//
//  Created by Brendan Schoch on 5/29/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsManager : NSObject

+(SettingsManager *)sharedManager;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSData *userImage;

@end
