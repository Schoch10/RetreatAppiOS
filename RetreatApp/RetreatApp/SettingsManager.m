//
//  SettingsManager.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/29/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SettingsManager.h"
#import "SCKeychain.h"
#import "NSDate+Extensions.h"
#import "AppDelegate.h"

static NSString * const CMTSettingsLastLaunchedAppVersion = @"lastLaunchedAppVersion";
static NSString * const RAUserID = @"userId";
static NSString * const RACurrentUserCheckinLocation = @"currentUserCheckinLocation";
static NSString * const RAUserReadGameInstructions = @"userReadGameInstructions";
static NSString * const RACurrentUserLocationName = @"currentUserLocationName";
static NSString * const RALastUpdateForCave = @"lastUpdateForCave";
static NSString * const RALastUpdateForLobby = @"lastUpdateForLobby";
static NSString * const RALastUpdateForGolf = @"lastUpdateForGolf";
static NSString * const RALastUpdateForLawnGames = @"lastUpdateForLawnGames";
static NSString * const RALastUpdateForTown = @"lastUpdateForTown";
static NSString * const RALastUpdateForOutdoor = @"lastUpdateForOutdoor";
static NSString * const RALastUpdateForStickneys = @"lastUpdateForStickneys";
static NSString * const RALastUpdateForPool = @"lastUpdateForPool";
static NSString * const RALastUpdateForPresidentialFoyer = @"lastUpdateForPresidentialFoyer";
static NSString * const RALastUpdateForAfterParty = @"lastUpdateForAfterParty";

@interface SettingsManager ()
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;
@end

@implementation SettingsManager
{
    NSNumber *_userId;
    NSNumber *_currentUserCheckinLocation;
    BOOL _userReadGameInstructions;
}

+ (SettingsManager *)sharedManager
{
    static SettingsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
        
        for (NSDictionary *prefSpecification in preferences) {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            id value = [prefSpecification objectForKey:@"DefaultValue"];
            
            if (key && value) {
                [defaults setObject:value forKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return instance;
}

- (BOOL)boolForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (void)setObject:(id)value forKey:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUsername:(NSString *)username
{
    [self setObject:username forKey:kUsernameKey];
}

- (NSString *)username
{
    return [self objectForKey:kUsernameKey];
}

- (void)setCurrentCheckinLocationName:(NSString *)currentCheckinLocationName {
    [self setObject:currentCheckinLocationName forKey:RACurrentUserLocationName];
}

- (NSString *)currentCheckinLocationName {
    return [self objectForKey:RACurrentUserLocationName];
}

- (void)setUserImage:(NSData *)userImage
{
    [self setObject:userImage forKey:@"userImage"];
}

- (NSData *)userImage
{
    return [self objectForKey:@"userImage"];
}


- (BOOL)iosIsAtLeastVersion:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending);
}

- (NSString *)lastLaunchedAppVersion
{
    return [self objectForKey:CMTSettingsLastLaunchedAppVersion];
}

- (void)setLastLaunchedAppVersion:(NSString *)lastLaunchedAppVersion
{
    [self setObject:lastLaunchedAppVersion forKey:CMTSettingsLastLaunchedAppVersion];
}


- (NSNumber *)userId
{
    if (_userId == nil) {
        _userId = [self objectForKey:RAUserID];
    }
    return _userId;
}

- (void)setUserId:(NSNumber *)userId
{
    _userId = userId;
    [self setObject:userId forKey:RAUserID];
}

- (NSNumber *)currentUserCheckinLocation {
    if (_currentUserCheckinLocation == nil) {
        _currentUserCheckinLocation = [self objectForKey:RACurrentUserCheckinLocation];
    }
    return _currentUserCheckinLocation;
}

- (void)setCurrentUserCheckinLocation:(NSNumber *)currentUserCheckinLocation {
    _currentUserCheckinLocation = currentUserCheckinLocation;
    [self setObject:currentUserCheckinLocation forKey:RACurrentUserCheckinLocation];
}

-(BOOL)userReadGameInstructions
{
    return [self boolForKey:RAUserReadGameInstructions];
}

-(void)setUserReadGameInstructions:(BOOL)userReadGameInstructions
{
    [self setBool:userReadGameInstructions forKey:RAUserReadGameInstructions];
}

-(void)setLastUpdateForTheCave:(NSDate *)lastUpdateForTheCave {

    [self setObject:lastUpdateForTheCave forKey:RALastUpdateForCave];
}

-(NSDate *)lastUpdateForTheCave {
    return [self objectForKey:RALastUpdateForCave];
}

- (void)setLastUpdateForTheLobby:(NSDate *)lastUpdateForTheLobby {
    [self setObject:lastUpdateForTheLobby forKey:RALastUpdateForLobby];
}

- (NSDate *)lastUpdateForTheLobby {
    return [self objectForKey:RALastUpdateForLobby];
}

- (void)setLastUpdateForGolf:(NSDate *)lastUpdateForGolf {
    [self setObject:lastUpdateForGolf forKey:RALastUpdateForGolf];
}

- (NSDate *)lastUpdateForGolf {
    return [self objectForKey:RALastUpdateForGolf];
}

- (void)setLastUpdateForLawnGames:(NSDate *)lastUpdateForLawnGames{
    [self setObject:lastUpdateForLawnGames forKey:RALastUpdateForLawnGames];
}

- (NSDate *)lastUpdateForLawnGames {
    return [self objectForKey:RALastUpdateForLawnGames];
}

- (void)setLastUpdateForTown:(NSDate *)lastUpdateForTown {
    [self setObject:lastUpdateForTown forKey:RALastUpdateForTown];
}

- (NSDate *)lastUpdateForTown {
    return [self objectForKey:RALastUpdateForTown];
}

- (void)setLastUpdateForOutdoorActivities:(NSDate *)lastUpdateForOutdoorActivities {
    [self setObject:lastUpdateForOutdoorActivities forKey:RALastUpdateForOutdoor];
}

- (NSDate *)lastUpdateForOutdoorActivities {
    return [self objectForKey:RALastUpdateForOutdoor];
}

- (void)setLastUpdateForStickneys:(NSDate *)lastUpdateForStickneys {
    [self setObject:lastUpdateForStickneys forKey:RALastUpdateForStickneys];
}

- (NSDate *)lastUpdateForStickneys {
    return [self objectForKey:RALastUpdateForStickneys];
}

- (void)setLastUpdateForPool:(NSDate *)lastUpdateForPool {
    [self setObject:lastUpdateForPool forKey:RALastUpdateForPool];
}

- (NSDate *)lastUpdateForPool {
    return [self objectForKey:RALastUpdateForPool];
}

- (void)setLastUpdateForPresidentialFoyer:(NSDate *)lastUpdateForPresidentialFoyer {
    [self setObject:lastUpdateForPresidentialFoyer forKey:RALastUpdateForPresidentialFoyer];
}

- (NSDate *)lastUpdateForPresidentialFoyer {
    return [self objectForKey:RALastUpdateForPresidentialFoyer];
}

- (void)setLastUpdateForTheAfterParty:(NSDate *)lastUpdateForTheAfterParty {
    [self setObject:lastUpdateForTheAfterParty forKey:RALastUpdateForAfterParty];
}

- (NSDate *)lastUpdateForTheAfterParty {
    return [self objectForKey:RALastUpdateForAfterParty];
}

- (NSDate *)checkLastUpdateForLocation:(NSNumber *)locationId {
    switch ([locationId intValue]) {
        case 3:
            return [self lastUpdateForTheCave];
            break;
        case 4:
            return [self lastUpdateForTheLobby];
            break;
        case 5:
            return [self lastUpdateForGolf];
            break;
        case 6:
            return [self lastUpdateForLawnGames];
            break;
        case 7:
            return [self lastUpdateForTown];
            break;
        case 8:
            return [self lastUpdateForOutdoorActivities];
            break;
        case 9:
            return [self lastUpdateForStickneys];
            break;
        case 10:
            return [self lastUpdateForPool];
            break;
        case 11:
            return [self lastUpdateForPresidentialFoyer];
            break;
        case 12:
            return [self lastUpdateForTheAfterParty];
            break;
        default:
            return nil;
            break;
    }
}

- (void)setLastUpdateForLocation:(NSNumber *)locationId {
    NSDate *currentDate = [NSDate date];
    switch ([locationId intValue]) {
        case 3:
            self.lastUpdateForTheCave = currentDate;
            break;
        case 4:
            self.lastUpdateForTheLobby = currentDate;
            break;
        case 5:
            self.lastUpdateForGolf = currentDate;
            break;
        case 6:
            self.lastUpdateForLawnGames = currentDate;
            break;
        case 7:
            self.lastUpdateForTown = currentDate;
            break;
        case 8:
            self.lastUpdateForOutdoorActivities = currentDate;
            break;
        case 9:
            self.lastUpdateForStickneys = currentDate;
            break;
        case 10:
            self.lastUpdateForPool = currentDate;
            break;
        case 11:
            self.lastUpdateForPresidentialFoyer = currentDate;
            break;
        case 12:
            self.lastUpdateForTheAfterParty = currentDate;
            break;
        default:
            break;
    }
}

@end
