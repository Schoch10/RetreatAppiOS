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
    NSArray *questionsArray = @[@"Attended the Boston Business Journal Best Places to Work Award Ceremony?", @"Can Name 5 of Slalom's Core Values?", @"Volunteered at the Greater Boston Food Bank with Slalom?", @"Has Run the Boston Marathon?", @"Participated in Last Year's Shuffleboard Tournament", @"Part of the Slalom Boston First 20?", @"Won a Mogul Award?", @"Has Hiked Mt. Washington?", @"Started at Slalom After Jan 1, 2015?", @"is Wearing their Slalom Fitbit?", @"Plays a Musical Instrument?", @"Developed this app!"];
    
    for (int i=0; i < questionsArray.count; i++) {
        Game *game = [Game gameUpsertWithGameId:@(i) inManagedObjectContext:context];
        game.question = [questionsArray objectAtIndex:i];
    }
    [coreData saveContext:context];
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}


@end
