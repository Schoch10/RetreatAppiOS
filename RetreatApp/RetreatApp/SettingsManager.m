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

@interface SettingsManager ()
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;
@end

@implementation SettingsManager
{
    NSNumber *_userId;
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


@end
