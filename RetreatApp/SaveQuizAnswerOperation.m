//
//  SaveQuizAnswer.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SaveQuizAnswerOperation.h"
#import "CoreDataManager.h"
#import "Game+Extensions.h"
#import "ServiceCoordinator.h"

@implementation SaveQuizAnswerOperation

- (instancetype)initGameAnswerWithGameId:(NSInteger)gameId forAnswer:(NSString *)answer
{
    self = [super init];
    if (self) {
        self.gameId = gameId;
        self.answer = answer;
    }
    return self;
}

- (void)doWork
{
    CoreDataManager *coreData = [CoreDataManager sharedManager];
    NSManagedObjectContext *context = coreData.operationContext;
    NSLog(@"game id %li", (long)self.gameId);
    Game *game = [Game gameUpsertWithGameId:@(self.gameId) inManagedObjectContext:context];
    game.answer = self.answer;
    BOOL success =[coreData saveContext:context];
    if (success) {
        [self.saveQuizOperationDelegate quizAnswerOperationDidSucceedWithAnswer:game.answer];
    }
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}



@end
