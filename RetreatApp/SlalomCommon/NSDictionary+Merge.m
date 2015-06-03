//
//  NSDate+SlalomCommon.m
//  SlalomCommon
//
//  Created by James Irvine on 1/24/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "NSDictionary+Merge.h"

@implementation NSDictionary (Merge)

+ (NSDictionary *) dictionaryByMerging: (NSDictionary *) dict1 with: (NSDictionary *) dict2 {
    __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dict1];
    
    [dict2 enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [result setValue:obj forKey:key];
    }];    
    return (NSDictionary *)[result mutableCopy];
}

- (NSDictionary *) dictionaryByMergingWith: (NSDictionary *) dict {
    return [[self class] dictionaryByMerging: self with: dict];
}


@end