//
//  SCConfigurationUtil.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This utility provides a wrapper for accessing values from the Info.plist in the application bundle.  Entries can be environment specific if the env value is set and the setting being requested is a dictionary with keys for each environment. */
@interface SCConfigurationUtil : NSObject
{
}

/** Retrieves a value from the Info.plist based on the passed in key.  The value may be environment specific if the env value is set and if the value is a dictonary type.
 
 @param key The name of the key to retrieve the value for.
 */
+ (id)objectForKey:(NSString *)key;

+ (NSURL*)URLForKey:(NSString*)key;

/** Retrieves a value from the Info.plist based on the passed in key.  The value may be environment specific and the envrionment can be overriden.
 
 @param key The name of the key to retrieve the value for.
 @param env The environment to override the settings with
 */
+ (id)objectForKey:(NSString *)key overrideEnv:(NSString *)env;

/** Retrieves the application bundle id from the Info.plist. */
+ (NSString *)applicationBundleId;

/** Retrieves the application marketing version from the Info.plist. */
+ (NSString *)applicationShortVersionString;

/** Retrieves the application build version from the Info.plist. */
+ (NSString *)applicationBuildNumberString;

/** Retrieves the application display name from the Info.plist. */
+ (NSString *)applicationDisplayName;

/** Retrieves and displays the applications version containing the marketing version and the build in "1.0 (1000)" format. */
+ (NSString *)applicationDisplayVersion;

/** Retrieves and displays the applications version containing the marketing version in "Version 1.0" format. */
+ (NSString *)applicationDisplayVersionShort;

@end
