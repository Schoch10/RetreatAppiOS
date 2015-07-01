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
@property (weak, nonatomic) IBOutlet UITextField *gameAnswerTextField;
@property (weak, nonatomic) IBOutlet UITextView *gameQuestionTextView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

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
        self.gameAnswerTextField.text = answerString;
        self.answerLabel.text = answerString;
        _answerString = answerString;
    }
}

- (void)flipCell {
    
    [UIView transitionWithView:self.contentView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        if (!self.gameAnswerTextField.hidden) {
                            self.gameAnswerTextField.hidden = YES;
                            self.answerLabel.hidden = NO;
                        } else {
                            self.gameAnswerTextField.hidden = NO;
                            self.answerLabel.hidden = YES;
                        }
                        
                    } completion:nil];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.contentView.backgroundColor = [UIColor greenColor];
    self.answerLabel.text = self.gameAnswerTextField.text;
    SaveQuizAnswerOperation *saveQuizAnswer = [[SaveQuizAnswerOperation alloc]initGameAnswerWithGameId:self.cardId forAnswer:textField.text];
    [ServiceCoordinator addLocalOperation:saveQuizAnswer completion:^(void){}];
    return YES;
}

- (void)awakeFromNib {
    self.gameAnswerTextField.hidden = YES;
    self.gameQuestionTextView.userInteractionEnabled = NO;
    self.answerLabel.hidden = YES;
    if (self.answerString != nil) {
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    if (self.gameAnswerTextField.hidden == NO && self.answerString != nil) {
        self.answerLabel.hidden = YES;
    } else {
        self.answerLabel.hidden = NO;
    }
}

- (void)quizAnswerOperationDidSucceedWithAnswer:(NSString *)answer
{
    self.answerLabel.text = answer;
}

@end
