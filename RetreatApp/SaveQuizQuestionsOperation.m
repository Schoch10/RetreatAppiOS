//
//  SaveQuizQuestionsOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SaveQuizQuestionsOperation.h"
#import "ServiceCoordinator.h"
#import "CoreDataManager.h"
#import "Game+Extensions.h"

@implementation SaveQuizQuestionsOperation

- (instancetype)initGame
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)doWork
{
    CoreDataManager *coreData = [CoreDataManager sharedManager];
    NSManagedObjectContext *context = coreData.operationContext;
    NSArray *questionsArray = @[@"How old is Russell?", @"What object does Mikey B look like when he stands?", @"Who Broke the Elevator?", @"Name an IM&A SSIS Architect?", @"How does Todd Richman get to work in the summer?", @"Who are Slalom's founders?", @"What is a fun fact about someone else?", @"What is Todd Christy's favorite snack?", @"What consultant was mounted by a cow?", @"What is the Dude's favorite hobby?", @"What is a fun fact about Barry?", @"Who has more than 3 siblings?"];
    
    for (int i=0; i < questionsArray.count; i++) {
        Game *game = [Game gameUpsertWithGameId:@(i) inManagedObjectContext:context];
        game.question = [questionsArray objectAtIndex:i];
    }
    [coreData saveContext:context];
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}


@end
