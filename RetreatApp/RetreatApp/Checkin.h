//
//  Checkin.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Checkin : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * checkinDate;
@property (nonatomic, retain) NSNumber * checkinID;
@property (nonatomic, retain) User *user;

@end
