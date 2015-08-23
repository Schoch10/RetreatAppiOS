//
//  Post.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/23/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * locationId;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSData * imageCache;

@end
