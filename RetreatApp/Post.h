//
//  Post.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSSet *user;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
