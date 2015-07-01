//
//  UIAlertView+Extensions.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAlertView (Extensions)

/** Quickly show an alert with a message. */
+ (void)showAlertWithMessage:(NSString *)message;

/** Quickly show an alert with a title, message and delegate */
+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title sender:(id)sender;

/** Shows a generic network error message */
+ (void)showNetworkErrorMessage;

/** Shows a message that the feature is not currently implemented and logs a warning */
+ (void)showFeatureNotImplementedMessage;

@end
