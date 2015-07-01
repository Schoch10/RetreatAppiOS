//
//  SCGradientView.h
//  SlalomCommon
//
//  Created by Cameron Mallory on 4/1/13.
//  Copyright (c) 2013 Slalom, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGradientView;

typedef NS_ENUM(NSUInteger, SCGradientDirection)
{
    SCGradientDirectionVertical = 0,
    SCGradientDirectionHorizontal = 1
};

@interface SCGradientView : UIView

@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *middleColor;
@property (strong, nonatomic) UIColor *endColor;
@property (assign, nonatomic) SCGradientDirection gradientDirection;

- (void)clear;
- (void)addColor:(UIColor*)color atLocation:(CGFloat)location;

@end



