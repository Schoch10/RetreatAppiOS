//
//  GameCollectionViewCell.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "GameCollectionViewCell.h"
#import "SaveQuizAnswerOperation.h"
#import "Game+Extensions.h"
#import "CoreDataManager.h"
#import "ServiceCoordinator.h"

@interface GameCollectionViewCell()
@property (weak, nonatomic) IBOutlet UITextView *gameQuestionTextView;

@end

@implementation GameCollectionViewCell

- (void)setQuestionString:(NSString *)questionString
{
    if (questionString) {
        self.gameQuestionTextView.text = questionString;
        _questionString = questionString;
    }
}

- (void)setAnswerString:(NSString *)answerString
{
    if (answerString) {
        _answerString = answerString;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.cardIndex.item >= 6) {
        dispatch_async(dispatch_get_main_queue(),^{
            NSDictionary *userInfo = @{@"indexPath": self.cardIndex};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollForKeyboardNotification" object:self userInfo:userInfo];
        });
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    SCLogMessage(kLogLevelDebug, @"cardId on cell %ld", (long)self.cardId);
    SaveQuizAnswerOperation *saveQuizAnswer = [[SaveQuizAnswerOperation alloc]initGameAnswerWithGameId:self.cardId forAnswer:self.gameAnswerTextField.text];
    saveQuizAnswer.saveQuizOperationDelegate = self;
    [ServiceCoordinator addLocalOperation:saveQuizAnswer completion:^(void){}];
    return YES;
}

- (void)awakeFromNib {
    self.gameAnswerTextField.hidden = NO;
    self.gameQuestionTextView.userInteractionEnabled = NO;
    [self.gameQuestionTextView sizeToFit];
}

- (void)quizAnswerOperationDidSucceedWithAnswer:(NSString *)answer
{
    dispatch_async(dispatch_get_main_queue(),^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnswerUpdated" object:self];
    });
}

@end
