//
//  SCConcurrentOperation.m
//  SlalomCommon
//
//  Created by Greg Martin on 12/4/11.
//  Copyright (c) 2011 Slalom, LLC. All rights reserved.
//

#import "SCConcurrentOperation.h"

@implementation SCConcurrentOperation

- (id)init 
{
    if (self = [super init]) 
    {
        executing = NO;
        finished = NO;
    }
    
    return self;
}


- (BOOL)isConcurrent 
{
    return YES;
}


- (BOOL)isExecuting 
{
    return executing;
}


- (BOOL)isFinished 
{
    return finished;
}


- (void)start 
{
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
    
        finished = YES;
        
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];

    executing = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    
    [self main];
}


- (BOOL)hasBeenCancelled
{
    if([self isCancelled])
    {
        [self completeOperation];
        
        return YES;
    }
    
    return NO;
}


- (void)completeOperation 
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    [super completeOperation];
}

@end
