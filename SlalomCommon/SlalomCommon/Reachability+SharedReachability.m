//
//  Reachability+SharedReachability.m
//  SlalomCommon
//
//  Created by Greg Martin on 4/3/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "Reachability+SharedReachability.h"

@implementation Reachability (SharedReachability)



+ (BOOL) hasConnection
{
    return ([[Reachability sharedReachability] currentReachabilityStatus] != NotReachable );
}


+(Reachability*)sharedReachability
{
	static Reachability* SharedReachability = nil;
	
	@synchronized(self)
	{
		if (SharedReachability == nil) 
		{
			SharedReachability = [Reachability reachabilityForInternetConnection];
		}
	}
	
	return SharedReachability;
}

@end
