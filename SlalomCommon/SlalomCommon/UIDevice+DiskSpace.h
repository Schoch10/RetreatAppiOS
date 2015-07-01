//
//  UIDevice+DiskSpace.h
//  SlalomCommon
//
//  Created by Greg Martin on 3/31/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (DiskSpace)

+ (double)totalDiskSpace;
+ (double)freeDiskSpace;
+ (double)usedDiskSpace;
+ (NSString *)displaySize:(double)bytes;

@end
