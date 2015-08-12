//
//  Checkin.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Checkin : NSManagedObject

@property (nonatomic, retain) NSDate * checkinDate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * checkinID;
@property (nonatomic, retain) Location *checkinLocation;

@end
