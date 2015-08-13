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
- (BOOL)iosIsAtLeastVersion:(NSString *)version;


@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSData *userImage;
@property (nonatomic, strong) NSString *lastLaunchedAppVersion;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *currentUserCheckinLocation;

@end
