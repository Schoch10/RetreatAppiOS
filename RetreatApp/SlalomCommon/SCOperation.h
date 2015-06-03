//
//  SCOperation.h
//  SlalomCommon
//
//  Created by James Irvine on 1/5/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOperationQueue+SharedQueue.h"

#define ReturnIfCancelled() if([self isCancelled]) { return; }
#define ReturnValueIfCancelled(val) if([self isCancelled]) { return (val); }

/** Provides a common base class for all operations. */
@interface SCOperation : NSOperation 
{
}

/** Generic property for a delegate */
@property (nonatomic, weak) id delegate;

/** Delegate selector to be called on success */
@property SEL successSelector;

/** Delegate selector to be called on failure */
@property SEL failureSelector;

/** Set to YES to keep this operation running in the background after tha pp is closed */
@property (nonatomic) BOOL shouldRunInBackground;

/** Method where synchronous work is performed.  Should be overridden by inheriting classes. */
- (void)doWork;

/** Called at times where honoring isCancelled is appropriate */
- (BOOL)hasBeenCancelled;

/** Cleanup the operation */
- (void)completeOperation;

/** Internal method for notifying delegate of faiulre */
- (void)notifyOfFailure:(NSError *)error;

/** Internal method for notifying delegate of success */
- (void)notifyOfSuccess:(NSDictionary *)userInfo;

/** Starts the network activity indicator in a way that ensures it stays active through multiple concurrent operations */
- (void)startNetworkActivityIndicator;

/** Stops the network activity indicator in a way that ensures it stays active through multiple concurrent operations */
- (void)stopNetworkActivityIndicator;

/** Starts the network activity indicator in a way that ensures it stays active through multiple concurrent operations */
+ (void)startNetworkActivityIndicator;

/** Stops the network activity indicator in a way that ensures it stays active through multiple concurrent operations */
+ (void)stopNetworkActivityIndicator;

@end
