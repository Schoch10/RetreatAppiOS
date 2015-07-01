//
//  NSDate+SlalomCommon.m
//  SlalomCommon
//
//  Created by James Irvine on 1/24/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Merge)

+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2;
- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict;

@end