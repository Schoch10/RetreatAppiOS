//
//  Reachability+SharedReachability.h
//  SlalomCommon
//
//  Created by Greg Martin on 4/3/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "Reachability.h"

@interface Reachability (SharedReachability)

+(Reachability*)sharedReachability;

+(BOOL)  hasConnection;
@end
