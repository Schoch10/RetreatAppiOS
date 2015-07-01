//
//  SaveQuizAnswer.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SCOperation.h"

@protocol SaveQuizAnswerOperationDelegate <NSObject>

- (void)quizAnswerOperationDidSucceedWithAnswer:(NSString *)answer;

@end

@interface SaveQuizAnswerOperation : SCOperation

@property (nonatomic) NSInteger gameId;
@property (strong, nonatomic) NSString *answer;
@property (weak, nonatomic) id<SaveQuizAnswerOperationDelegate> saveQuizOperationDelegate;

- (instancetype)initGameAnswerWithGameId:(NSInteger)gameId forAnswer:(NSString *)answer;


@end
