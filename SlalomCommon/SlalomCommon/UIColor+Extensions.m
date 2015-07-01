//
//  UIColor+Extensions.m
//  SlalomCommon
//
//  Created by Cameron Mallory on 4/9/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//
//
//  c/o http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
//
#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)


+(UIColor *) colorWithHex: (int)rgbValue 
{
    return [UIColor colorWithHex: rgbValue alpha:1.0];
}

+(UIColor *) colorWithHex: (int)rgbValue alpha:(float) a
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a];
}



@end
