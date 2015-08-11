//
//  Checkin+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/5/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Checkin.h"

@interface Checkin (Extensions)

+ (Checkin *)checkinUpsertWithCheckinId:(NSNumber *)checkinId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;

@end
