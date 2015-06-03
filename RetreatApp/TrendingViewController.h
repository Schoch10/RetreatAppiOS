//
//  TrendingViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendingModalViewController.h"
#import "CheckinViewController.h"
#import "PostModalViewController.h"

@interface TrendingViewController : UIViewController <TrendingModalViewDelegate, CheckinModalViewControllerDelegate, PostModalViewControllerDelegate>

@property (strong, nonatomic) Class sendingClass;

@end
