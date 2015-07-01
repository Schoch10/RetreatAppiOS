//
//  UIFont+Extensions.m
//  SlalomCommon
//
//  Created by Cameron Mallory on 4/13/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "UIFont+Extensions.h"

@implementation UIFont (Extensions)


+(NSArray *) avaliableFontNames
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init ];
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    for (NSString *familyName in familyNames) {
        NSArray *fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName: familyName
                      ]];
        for (NSString *fontName in fontNames) {
            [retVal addObject: [NSString stringWithFormat:@"%@ - %@",familyName, fontName] ];
        }
    }    
    return retVal;
}
@end
