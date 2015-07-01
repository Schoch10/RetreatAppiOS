//
//  SCAppDelegateBase.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/20/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

void uncaughtExceptionHandler(NSException *exception);

/** The base AppDelegate to be used by all applications so that common functions such as logging are instantiated properly. */
@interface SCAppDelegateBase : UIResponder <UIApplicationDelegate> 
{
}

/** The application's window. */
@property (nonatomic, retain) UIWindow *window;

/** The application's root view controller. */
@property (nonatomic, retain) UIViewController *rootViewController;

/** Determines application log level from the Info.plist. */
- (void)determineLogLevel;

/** This method must be overridden by inheriting classes and must set the value of `rootViewController`. */
- (void)setupUserInterfaceWithOptions:(NSDictionary*)launchOptions;

@end
