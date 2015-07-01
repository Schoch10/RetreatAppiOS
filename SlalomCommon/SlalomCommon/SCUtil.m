//
//  SCUtil.m
//  SlalomCommon
//
//  Created by Greg Martin on 10/13/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "SCUtil.h"

@implementation SCUtil

/* Creates a globally unique identifier */
+ (NSString *)GUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *result = (__bridge NSString *)string;
    CFRelease(string);
    
    return result;
}

@end
