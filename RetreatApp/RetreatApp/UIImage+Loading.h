//
//  UIImage+Loading.h
//  SlalomCommon
//
//  Created by Greg Martin on 7/1/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Loading)

+ (void)clearCache;

+ (BOOL)imageIsCached:(NSString *)absolutePath;
+ (UIImage *)cachedImage:(NSString *)absolutePath;

+ (UIImage *)imageInDocumentsDirectory:(NSString *)absolutePath;
+ (UIImage *)imageInCachesDirectory:(NSString *)absolutePath;

+ (void)asyncImageInDocumentsDirectory:(NSString *)absolutePath completion:(void (^)(UIImage *image))completion;
+ (void)asyncImageInCachesDirectory:(NSString *)absolutePath completion:(void (^)(UIImage *image))completion;

@end
