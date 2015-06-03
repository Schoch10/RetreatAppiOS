//
//  NSError+Extensions.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/9/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extensions)

+ (id)errorWithException:(NSException *)exception;
- (BOOL)isSSLError;

@end
