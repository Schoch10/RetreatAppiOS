//
//  SCConfigurationUtil.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "SCConfigurationUtil.h"

@implementation SCConfigurationUtil

+ (id)objectForKey:(NSString *)key
{
    return [SCConfigurationUtil objectForKey:key overrideEnv:nil];
}

+ (NSURL*)URLForKey:(NSString*)key {
    NSURL *URL = [SCConfigurationUtil objectForKey:key overrideEnv:nil];
    if([[URL scheme] isEqualToString:@"staticdata"]) {
        return [[NSBundle mainBundle] URLForResource:[URL resourceSpecifier] withExtension:nil];
    }
    return URL;
}

+ (id)objectForKey:(NSString *)key overrideEnv:(NSString *)env
{
    id value = nil;
	
	NSDictionary *infoDict = [[NSBundle bundleForClass:[self class]] localizedInfoDictionary];
	
    if(![[infoDict allKeys] containsObject:key])
    {
        infoDict = [[NSBundle bundleForClass:[self class]] infoDictionary];
    }
	
	// Check if its a system property
	if ([key rangeOfString:@"CFBundle"].location == 0)
	{
		return [infoDict valueForKey:key];
	}
	
	value = [infoDict valueForKey:key];
	
	if([value isKindOfClass:[NSDictionary class]])
	{
		if(env == nil)
		{
			env = [infoDict valueForKey:@"env"];
		}
		
        if(env != nil)
        {
            // check for environment specific variable within dictionary
            // otherwise just return dictionary
            if([[value allKeys] containsObject:env])
            {
                value = [value valueForKey:env];
            }
        }
	}
	
	return value;
}


+ (NSString *)applicationBundleId
{
    return [self objectForKey:@"CFBundleIdentifier"];
}


+ (NSString*)applicationShortVersionString
{
	return [self objectForKey:@"CFBundleShortVersionString"];
}


+ (NSString *)applicationBuildNumberString
{
    return [self objectForKey:@"CFBundleVersion"];
}


+ (NSString *)applicationDisplayName
{
	return [self objectForKey:@"CFBundleDisplayName"];
}


+ (NSString *)applicationDisplayVersion
{
    return [NSString stringWithFormat:@"%@ (%@)", [SCConfigurationUtil applicationShortVersionString], [SCConfigurationUtil applicationBuildNumberString]];
}


+ (NSString *)applicationDisplayVersionShort
{
    return [NSString stringWithFormat:@"Version %@", [SCConfigurationUtil applicationShortVersionString]];
}

@end
