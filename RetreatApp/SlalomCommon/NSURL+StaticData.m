//
//  NSURL+StaticData.m
//  SlalomCommon
//
//  Created by James Irvine on 1/30/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "NSURL+StaticData.h"

@implementation NSURL (StaticData)
-(BOOL)isStaticDataURL {
    return [[self scheme] isEqualToString:@"staticdata"];
}
-(NSURL*)URLForStaticData {
    if (![self isStaticDataURL]) {
        return self;
    }
    NSString *filename = [[self resourceSpecifier] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSURL *URL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    return URL;
}

@end
