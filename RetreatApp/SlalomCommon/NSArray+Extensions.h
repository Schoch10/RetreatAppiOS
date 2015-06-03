//
//  NSArray+Extensions.h
//  SlalomCommon
//
//  Created by Raphael Miller on 4/11/12.
//  Copyright 2011 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Extensions)

- (BOOL)containsValue:(NSString *)value;

// The block should determine if the item is a match. If so, return YES, if not, return NO.
// Iteration stops when YES is returned by the block, and the method returns the item matched.
// If the block always returns NO, then nil is returned.
- (id)objectMatchingBlock:(BOOL(^)(id item))block;

@end
