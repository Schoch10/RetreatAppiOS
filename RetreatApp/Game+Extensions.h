//
//  Game+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Game.h"

@interface Game (Extensions)
+ (Game *)gameUpsertWithGameId:(NSNumber *)gameId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;
@end
