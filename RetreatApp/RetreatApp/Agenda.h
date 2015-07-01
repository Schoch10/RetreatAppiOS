//
//  Agenda.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/22/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Agenda : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * time;

@end
