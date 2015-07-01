//
//  NSObject+SharedQueue.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Provides a shared instance of an NSOperationQueue to the application. */
@interface NSOperationQueue (SharedQueue)

/** The shared instance */
+(NSOperationQueue*)sharedOperationQueue;

@end