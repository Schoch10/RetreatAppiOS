//
//  Agenda.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/19/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Agenda : NSManagedObject

@property (nonatomic, retain) NSNumber * agendaId;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * day;

@end
