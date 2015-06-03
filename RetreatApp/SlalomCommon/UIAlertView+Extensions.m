//
//  UIAlertViewExtensions.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "UIAlertView+Extensions.h"


@implementation UIAlertView (Extensions)

+ (void)showAlertWithMessage:(NSString *)message
{
	[UIAlertView showAlertWithMessage:message title:nil sender:nil];
}


+ (void)showAlertWithMessage:(NSString *)message title:(NSString *)title sender:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:sender
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	
	[alert show];
}

+ (void)showNetworkErrorMessage {
    [self showAlertWithMessage:SCLocStr(@"NetworkErrorMessage") title:SCLocStr(@"NetworkErrorTitle") sender:nil];
}

+ (void)showFeatureNotImplementedMessage {
    [self showAlertWithMessage:SCLocStr(@"FeatureNotImplemented") title:nil sender:nil];
}


@end
