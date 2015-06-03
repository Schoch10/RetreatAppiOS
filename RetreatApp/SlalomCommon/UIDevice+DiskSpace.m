//
//  UIDevice+DiskSpace.m
//  SlalomCommon
//
//  Created by Greg Martin on 3/31/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "UIDevice+DiskSpace.h"

@implementation UIDevice (DiskSpace)

+ (double)totalDiskSpace
{
    double totalSpace = 0;
    
    NSError *error = nil;  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
    
    if (dictionary) 
    { 
        NSNumber *fileSystemSizeInBytes = dictionary[NSFileSystemSize];  
        totalSpace = [fileSystemSizeInBytes doubleValue];
    }  
    
    return totalSpace;
}


+ (double)freeDiskSpace
{
    double totalFreeSpace = 0;
    
    NSError *error = nil;  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
    
    if (dictionary)
    {  
        NSNumber *freeFileSystemSizeInBytes = dictionary[NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes doubleValue];
    }  
    
    return totalFreeSpace;
}

+ (double)usedDiskSpace
{
    return [UIDevice totalDiskSpace] - [UIDevice freeDiskSpace];
}

+ (NSString *)displaySize:(double)bytes
{
    static NSNumberFormatter *numberFormatter = nil;
    
    if(!numberFormatter)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [numberFormatter setMaximumFractionDigits:1];
        [numberFormatter setMinimumFractionDigits:1];
    }
    
    if(bytes < kBytesInKilobyte)
    {
        return [NSString stringWithFormat:@"%@B", [numberFormatter stringFromNumber:@(bytes)]];
    }
    else if(bytes < kBytesInMegabyte)
    {
        return [NSString stringWithFormat:@"%@KB", [numberFormatter stringFromNumber:@(bytes / kBytesInKilobyte)]];
    }
    else if(bytes < kBytesInGiabyte)
    {
        return [NSString stringWithFormat:@"%@MB", [numberFormatter stringFromNumber:@(bytes / kBytesInMegabyte)]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@GB", [numberFormatter stringFromNumber:@(bytes / kBytesInGiabyte)]];
    }
}

@end
