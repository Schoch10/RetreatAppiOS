//
//  User+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "User.h"

@interface User (Extensions)
+ (User *)userUpsertWithUserId:(NSNumber *)userId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;
@end
