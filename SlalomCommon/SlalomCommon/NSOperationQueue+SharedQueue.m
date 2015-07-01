//
//  NSObject+SharedQueue.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"


@implementation NSOperationQueue (SharedQueue)

+(NSOperationQueue*)sharedOperationQueue
{
	static NSOperationQueue* sharedQueue = nil;
	
	@synchronized(self)
	{
		if (sharedQueue == nil) 
		{
			sharedQueue = [[NSOperationQueue alloc] init];
            [sharedQueue setName:@"Shared Operation Queue"];
			[sharedQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
		}
	}
	
	return sharedQueue;
}

@end
