//
//  Game.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSNumber * gameId;

@end
