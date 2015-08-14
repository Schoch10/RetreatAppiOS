//
//  GameInstructionsModalViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/13/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameInstructionsModalDelegate <NSObject>

- (void)dismissGameInstructionsModalViewController;

@end


@interface GameInstructionsModalViewController : UIViewController

@property (nonatomic, weak) id<GameInstructionsModalDelegate> delegate;

@end
