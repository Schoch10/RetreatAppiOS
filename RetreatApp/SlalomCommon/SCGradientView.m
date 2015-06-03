//
//  SCGradientView.m
//  SlalomCommon
//
//  Created by Cameron Mallory on 4/1/13.
//  Copyright (c) 2013 Slalom, LLC. All rights reserved.
//

#import "SCGradientView.h"


#define kStartLocation 0.001f
#define kEndLocation 0.9999f

@interface ColorInfo : NSObject
@property (strong, nonatomic) UIColor *color;
@property  CGFloat location;
@end

@implementation ColorInfo

-(id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

@end


@interface SCGradientView()
{
    NSMutableArray *data;
}

@end


@implementation SCGradientView

- (void)commonInit
{
    data = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    self.gradientDirection = SCGradientDirectionVertical;
}

-(id)init
{
    self = [super init];
    if ( self )
    {
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locs [data.count];
    CGFloat components[data.count * 4];
    int locIndex = 0;
    int colIndex = 0;
    for (ColorInfo *ci in data) {
        locs[locIndex++] = ci.location;
        const CGFloat *comps = CGColorGetComponents([ci.color CGColor]);
        components[colIndex++] = comps[0];
        components[colIndex++] = comps[1];
        components[colIndex++] = comps[2];
        components[colIndex++] = comps[3];
    }
    CGGradientRef backgroundGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locs, data.count);
    
    CGRect bounds = self.bounds;
    
    if(self.gradientDirection == SCGradientDirectionVertical)
    {
        CGContextDrawLinearGradient(currentContext, backgroundGradient, CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds)), CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds)), 0);
    }
    else if(self.gradientDirection == SCGradientDirectionHorizontal)
    {
        CGContextDrawLinearGradient(currentContext, backgroundGradient, CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds)), CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds)), 0);
    }
    
    CGGradientRelease(backgroundGradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)clear
{
    [data removeAllObjects];
}

-(void)setStartColor:(UIColor *)start
{
    _startColor = start;
    [self addColor:start atLocation:kStartLocation];
}

-(void)setEndColor:(UIColor *)end
{
    _endColor = end;
    [self addColor:end atLocation:kEndLocation];
}

-(void)setMiddleColor:(UIColor *)middle
{
    _middleColor = middle;
    [self addColor:middle atLocation:(kEndLocation-kStartLocation)/2];
}

-(void)addColor:(UIColor *)color atLocation:(CGFloat)location
{
    // 0.0 or 1.0 won't get included, so adjust if necessary
    if ( location <= 0.0f)
        location = kStartLocation;
    if ( location >= 1.0f)
        location = kEndLocation;
    
    if ( color )
    {
        ColorInfo *ci = [[ColorInfo alloc] init];
        ci.color = color;
        ci.location = location;
        [data addObject:ci];
    }
}
@end
