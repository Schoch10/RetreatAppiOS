//
//  UIColor+Extensions.h
//  SlalomCommon
//
//  Created by Cameron Mallory on 4/9/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)


+(UIColor *) colorWithHex: (int)rgbValue;
+(UIColor *) colorWithHex: (int)rgbValue alpha:(float) a;
@end
