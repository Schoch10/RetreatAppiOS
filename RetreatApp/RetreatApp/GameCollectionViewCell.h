//
//  GameCollectionViewCell.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveQuizAnswerOperation.h"


@interface GameCollectionViewCell : UICollectionViewCell <UITextFieldDelegate, SaveQuizAnswerOperationDelegate>

@property (strong, nonatomic) NSString *questionString;
@property (strong, nonatomic) NSString *answerString;
@property (weak, nonatomic) IBOutlet UITextField *gameAnswerTextField;
@property (nonatomic) NSInteger cardId;
@property (nonatomic) NSIndexPath *cardIndex;

@end
