//
//  Game+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Game+Extensions.h"
#import "CoreDataManager.h"

@implementation Game (Extensions)

+ (NSMutableDictionary *)gameMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *gameMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        gameMap = [coreDataManager objectUriMap:@"Game" keyName:@"gameId" context:context];
    });
    return gameMap;
}


+ (Game *)gameUpsertWithGameId:(NSNumber *)gameId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;
{
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *gameMap = [self gameMapInContext:context];
        NSURL *objectUri = [gameMap objectForKey:gameId];
    
        Game *game = nil;
        if(objectUri) {
            game = (Game *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!game) {
            game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:context];
            game.gameId = gameId;
            [context obtainPermanentIDsForObjects:@[game] error:nil];
            [gameMap setObject:game.objectID.URIRepresentation forKey:gameId];
    }
        return game;
    }
}

@end
