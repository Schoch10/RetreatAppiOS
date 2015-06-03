//
//  NSArray+Extensions.m
//  SlalomCommon
//
//  Created by Raphael Miller on 4/11/12.
//  Copyright 2011 Slalom Consulting. All rights reserved.
//

#import "NSArray+Extensions.h"


@implementation NSArray (Extensions)

- (BOOL)containsValue:(NSString *)value
{
	for(NSString *item in self)
	{
		if([item isEqualToString:value])
		{
			return YES;
		}
	}
	
	return NO;
}

- (id)objectMatchingBlock:(BOOL(^)(id))block {
	for (NSObject *object in self) {
		if(block(object)) {
			return object;
		}
	}
	return nil;
}

@end
