//
//  SCConcurrentOperation.h
//  SlalomCommon
//
//  Created by Greg Martin on 12/4/11.
//  Copyright (c) 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCOperation.h"

#define CompleteIfCancelled() if([self isCancelled]) { [self completeOperation]; return; }

@interface SCConcurrentOperation : SCOperation
{
    BOOL executing;
    BOOL finished;
}

@end
