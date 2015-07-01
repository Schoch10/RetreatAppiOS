//
//  UIImage+Resize.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/27/13.
//  Copyright (c) 2013 Slalom, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/** Resizes an image but maintains aspect ratio */
- (UIImage *)imageSizedToFit:(CGSize)size;

/** Crop an image to the specific rect */
- (UIImage *)imageCropedToRect:(CGRect)rect;

/** Crops image to specified aspect ratio and resizes to match size */
- (UIImage *)imageCropedAndScaleSize:(CGSize)size;

@end
