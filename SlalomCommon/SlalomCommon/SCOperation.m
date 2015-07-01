//
//  SCOperation.m
//  SlalomCommon
//
//  Created by James Irvine on 1/5/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "SCOperation.h"
#import "NSError+Extensions.h"

static int activityIndicatorCount = 0;
static id activityIndicatorLock = nil;

@implementation SCOperation
{
    UIBackgroundTaskIdentifier backgroundTask;
    BOOL hasStartedActivityIndicator;
}

@synthesize delegate;
@synthesize successSelector;
@synthesize failureSelector;

+ (void)initialize
{
	if(self == [SCOperation class])
    {
		activityIndicatorLock = [[NSObject alloc] init];
	}
}


- (void)doWork
{
	@throw [NSException exceptionWithName:@"NotImplementedException" reason:@"This method must be implemented by the inheriting class." userInfo:nil];
}


- (void)main
{
    @autoreleasepool
    {
        @try
        {
            if(![self isCancelled])
            {
                if (self.shouldRunInBackground
                    && [UIDevice currentDevice].multitaskingSupported)
                {
                    backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                        
                        [self cancel];
                        
                        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                        
                        backgroundTask = UIBackgroundTaskInvalid;
                    }];
                }
                
                [self doWork];
            }
        }
        @catch (NSException * e)
        {
            SCLogMessage(kLogLevelError, @"%@:\n%@", e, e.callStackSymbols);
            
            [self notifyOfFailure:[NSError errorWithException:e]];
        }
    }
}


- (BOOL)hasBeenCancelled
{
    return [self isCancelled];
}


- (void)completeOperation
{
    if(backgroundTask)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        
        backgroundTask = UIBackgroundTaskInvalid;
    }
}


- (void)notifyOfFailure:(NSError *)error
{
    if(![self hasBeenCancelled])
    {
    if(self.delegate
       &&  [self.delegate respondsToSelector:self.failureSelector])
    {
        [self.delegate performSelectorOnMainThread:self.failureSelector withObject:error waitUntilDone:YES];
    }
    
    [self completeOperation];
}
}


- (void)notifyOfSuccess:(NSDictionary *)userInfo
{
    if(![self hasBeenCancelled])
    {
    if(self.delegate
       &&  [self.delegate respondsToSelector:self.successSelector])
    {
        [self.delegate performSelectorOnMainThread:self.successSelector withObject:userInfo waitUntilDone:YES];
    }
    
    [self completeOperation];
}
}


- (void)startNetworkActivityIndicator
{
    if(!hasStartedActivityIndicator)
    {
        hasStartedActivityIndicator = YES;
        
        [SCOperation startNetworkActivityIndicator];
    }
}


- (void)stopNetworkActivityIndicator
{
    if(hasStartedActivityIndicator)
    {
        hasStartedActivityIndicator = NO;
        
        [SCOperation stopNetworkActivityIndicator];
    }
}

+ (void)startNetworkActivityIndicator
{
    @synchronized(activityIndicatorLock)
    {
        if(activityIndicatorCount == 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        
        activityIndicatorCount++;
	}
}


+ (void)stopNetworkActivityIndicator
{
    @synchronized(activityIndicatorLock)
    {
        if(activityIndicatorCount > 0)
        {
            activityIndicatorCount--;
        }
        
        if(activityIndicatorCount == 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
 	}
}

@end
