//
//  Location.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checkin;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSSet *checkin;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addCheckinObject:(Checkin *)value;
- (void)removeCheckinObject:(Checkin *)value;
- (void)addCheckin:(NSSet *)values;
- (void)removeCheckin:(NSSet *)values;

@end
