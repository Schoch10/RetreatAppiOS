//
//  Location+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Location.h"

@interface Location (Extensions)
+ (Location *)locationUpsertWithLocationId:(NSNumber *)locationId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;
@end
