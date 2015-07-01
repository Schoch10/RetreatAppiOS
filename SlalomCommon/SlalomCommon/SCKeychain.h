//
//  SCKeychain.h
//  SlalomCommon
//
//  Created by Greg Martin on 5/3/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUsernameKey @"kUsernameKey"
#define kPasswordKey @"kPasswordKey"

@interface SCKeychain : NSObject 
{    
}

+ (BOOL)setString:(NSString *)string forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key;

@end
