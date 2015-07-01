//
//  SCAppDelegateBase.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/20/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "SCAppDelegateBase.h"

void uncaughtExceptionHandler(NSException *exception) 
{
    if([exception respondsToSelector:@selector(callStackSymbols)])
    {
        SCLogMessageWithNoClassInfo(kLogLevelError, @"Uncaught Exception: %@", [NSString stringWithFormat:@"%@\n%@", exception, exception.callStackSymbols]);
    }
}

@implementation SCAppDelegateBase

@synthesize window;
@synthesize rootViewController;

#pragma mark -
#pragma mark Application lifecycle


- (void)setupUserInterfaceWithOptions:(NSDictionary *)launchOptions
{
    // Implement in inheriting class to set rootViewController.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    	
	[self determineLogLevel];
	
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
	{
		SCLogMessage(kLogLevelError, @"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	// Add the view controller's view to the window and display.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    [self setupUserInterfaceWithOptions:launchOptions];
    
    self.window.rootViewController = self.rootViewController;
	[self.window makeKeyAndVisible];
	
	return YES;
}


#pragma mark - Private Methods


- (void)determineLogLevel
{
	//Set Logging Level
	NSString *tempLogLevel = [SCConfigurationUtil objectForKey:@"logLevel"];
	
	if ([tempLogLevel caseInsensitiveCompare:@"DEBUG"] == NSOrderedSame)
	{
		logLevel= kLogLevelDebug;
	}
	else if ([tempLogLevel caseInsensitiveCompare:@"INFO"] == NSOrderedSame)
	{
		logLevel= kLogLevelInfo;
	}
	else if ([tempLogLevel caseInsensitiveCompare:@"WARN"] == NSOrderedSame)
	{
		logLevel= kLogLevelWarn;
	}
	else if ([tempLogLevel caseInsensitiveCompare:@"ERROR"] == NSOrderedSame)
	{
		logLevel= kLogLevelError;
	}
	else 
	{
		logLevel = 0;
	}
}

@end
