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
- (NSDate *)checkLastUpdateForLocation:(NSNumber *)locationId;
- (void)setLastUpdateForLocation:(NSNumber *)locationId;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSData *userImage;
@property (nonatomic, strong) NSString *lastLaunchedAppVersion;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *currentUserCheckinLocation;
@property (nonatomic, strong) NSString *currentCheckinLocationName;
@property (nonatomic) BOOL userReadGameInstructions;
@property (nonatomic, strong) NSDate *lastUpdateForTheCave;
@property (nonatomic, strong) NSDate *lastUpdateForTheLobby;
@property (nonatomic, strong) NSDate *lastUpdateForGolf;
@property (nonatomic, strong) NSDate *lastUpdateForLawnGames;
@property (nonatomic, strong) NSDate *lastUpdateForTown;
@property (nonatomic, strong) NSDate *lastUpdateForOutdoorActivities;
@property (nonatomic, strong) NSDate *lastUpdateForStickneys;
@property (nonatomic, strong) NSDate *lastUpdateForPool;
@property (nonatomic, strong) NSDate *lastUpdateForPresidentialFoyer;
@property (nonatomic, strong) NSDate *lastUpdateForTheAfterParty;

@end
