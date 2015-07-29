//
//  ServiceCoordinator.m
//  MindTapiPhone
//
//  Created by Brendan Schoch on 10/2/14.
//  Copyright (c) 2014 Slalom Consulting. All rights reserved.
//

#import "ServiceCoordinator.h"
#import "SettingsManager.h"
#import "RetreatAppServiceConnectionOperation.h"
#import "ServiceEndpoints.h"

@interface ServiceCoordinator()

@property (nonatomic, strong) NSMutableSet *highPriorityNetworkOperations;
@property (nonatomic, strong) NSMutableSet *mediumPriorityNetworkOperations;
@property (nonatomic, strong) NSMutableSet *lowPriorityNetworkOperations;
@property (nonatomic, strong) NSMutableArray *deferredNetworkOperations;
@property (nonatomic, strong) NSMutableArray *deferredLocalOperations;

@end

@implementation ServiceCoordinator
{
    NSOperationQueue *_highOperationQueue;
    NSOperationQueue *_defaultOperationQueue;
    NSOperationQueue *_lowOperationQueue;
    NSOperationQueue *_serialOperationQueue;
    RetreatAppServicesClient *_serviceClient;
}

+(ServiceCoordinator*)sharedCoordinator
{
    static ServiceCoordinator *_sharedCoordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCoordinator = [[ServiceCoordinator alloc] init];
    });
    return _sharedCoordinator;
}

-(id)serviceClientWithoutAuth
{
    return [[RetreatAppServicesClient alloc] init];
}

-(id)serviceClientWithAuth
{
    SettingsManager *settings = [SettingsManager sharedManager];
    @synchronized(self) {
        if (!_serviceClient) {
            [settings addObserver:self forKeyPath:@"authToken" options:NSKeyValueObservingOptionNew context:nil];
            _serviceClient = [[RetreatAppServicesClient alloc] initWithAuthToken:nil];
        }
    }
    return _serviceClient;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    SettingsManager *settings = [SettingsManager sharedManager];
    if (object == settings) {
        if ([keyPath isEqualToString:@"authToken"]) {
            @synchronized(self) {
                _serviceClient = nil;
                [settings removeObserver:self forKeyPath:@"authToken"];
            }
        }
    }
}

-(NSOperationQueue *)highPriorityOperationQueue
{
    @synchronized(self) {
        if (_highOperationQueue == nil) {
            _highOperationQueue = [[NSOperationQueue alloc] init];
            [_highOperationQueue setName:@"High-priority operation queue"];
            [_highOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
        }
    }
    return _highOperationQueue;
}

-(NSOperationQueue *)defaultPriorityOperationQueue
{
    @synchronized(self) {
        if (_defaultOperationQueue == nil) {
            _defaultOperationQueue = [[NSOperationQueue alloc] init];
            [_defaultOperationQueue setName:@"Default-priority operation queue"];
            [_defaultOperationQueue setMaxConcurrentOperationCount:2];
        }
    }
    return _defaultOperationQueue;
}

- (NSOperationQueue *)lowPriorityOperationQueue
{
    @synchronized(self) {
        if (_lowOperationQueue == nil) {
            _lowOperationQueue = [[NSOperationQueue alloc] init];
            [_lowOperationQueue setName: @"Low-priority operation queue"];
            [_lowOperationQueue setMaxConcurrentOperationCount:1];
        }
    }
    return _lowOperationQueue;
}

- (NSMutableSet *)highPriorityNetworkOperations
{
    if (_highPriorityNetworkOperations == nil) {
        _highPriorityNetworkOperations = [[NSMutableSet alloc] init];
    }
    return _highPriorityNetworkOperations;
}

- (NSMutableSet *)mediumPriorityNetworkOperations
{
    if (_mediumPriorityNetworkOperations == nil) {
        _mediumPriorityNetworkOperations = [[NSMutableSet alloc] init];
    }
    return _mediumPriorityNetworkOperations;
}

- (NSMutableSet *)lowPriorityNetworkOperations
{
    if (_lowPriorityNetworkOperations == nil) {
        _lowPriorityNetworkOperations = [[NSMutableSet alloc] init];
    }
    return _lowPriorityNetworkOperations;
}

- (NSMutableArray *)deferredNetworkOperations
{
    if (_deferredNetworkOperations == nil) {
        _deferredNetworkOperations = [[NSMutableArray alloc] init];
    }
    return _deferredNetworkOperations;
}

- (NSMutableArray *)deferredLocalOperations
{
    if (_deferredLocalOperations == nil) {
        _deferredLocalOperations = [[NSMutableArray alloc] init];
    }
    return _deferredLocalOperations;
}

- (NSOperationQueue*)serialOperationQueue
{
    @synchronized(self) {
        if (_serialOperationQueue == nil) {
            _serialOperationQueue = [[NSOperationQueue alloc] init];
            [_serialOperationQueue setName:@"Serial operation queue"];
            [_serialOperationQueue setMaxConcurrentOperationCount:1];
        }
    }
    
    return _serialOperationQueue;
}

+ (void)addLocalOperation:(SCOperation *)operation completion:(void (^)(void))completion
{
    NSOperationQueue *serialQueue = [[ServiceCoordinator sharedCoordinator] serialOperationQueue];
    [serialQueue addOperation:operation];
    [serialQueue addOperationWithBlock:completion];
}

+ (void)addLocalOperation:(SCOperation *)operation priority:(CMTTaskPriority)priority
{
    NSOperationQueue *queue;
    ServiceCoordinator *coordinator = [ServiceCoordinator sharedCoordinator];
    switch (priority) {
        case CMTTaskPriorityHigh:
            queue = [coordinator highPriorityOperationQueue];
            break;
        case CMTTaskPriorityMedium:
            queue = [coordinator defaultPriorityOperationQueue];
            break;
        case CMTTaskPriorityLow:
            queue = [coordinator lowPriorityOperationQueue];
            break;
    }
    @synchronized (queue) {
        if ([queue.operations containsObject:operation]) {
            // There is already a duplicate operation pending. Don't clog up higher priority queues with duplicate requests.
            @synchronized (coordinator.deferredLocalOperations) {
                [coordinator.deferredLocalOperations addObject:operation];
            }
            return;
        }
    }
    [queue addOperation:operation];
}

+ (void)addNetworkOperation:(RetreatAppServiceConnectionOperation *)operation priority:(CMTTaskPriority)priority
{
    ServiceCoordinator *coordinator = [ServiceCoordinator sharedCoordinator];
    BOOL usingCachedData = [operation useCachedDataIfAvailable];
    operation.priority = priority;
    if ([operation shouldDownloadFromNetwork]) {
        NSError *deferredDueToError = nil;
        if (![ServiceEndpoints isHostReachable]) {
            deferredDueToError = [NSError errorWithDomain:kServiceErrorDomain code:ErrorCodeCannotFindHost userInfo:@{@"hostName":[ServiceEndpoints getHostnameForSelectedEnvironment]}];
        } else if (deferredDueToError) {
            [coordinator deferNetworkOperation:operation];
            if (!usingCachedData && !coordinator.highPriorityLoginIsInProgress) {
                [operation.delegate serviceTaskDidFailToCompleteRequest:deferredDueToError];
            }
        } else {
            [coordinator addNetworkOperation:operation];
        }
    } else if (!usingCachedData) {
        [operation completeFromCacheWithNoData];
    }
}

- (BOOL)highPriorityLoginIsInProgress
{
    return NO;
}

- (void)deferNetworkOperation:(RetreatAppServiceConnectionOperation *)operation
{
    @synchronized (self.deferredNetworkOperations) {
        [self.deferredNetworkOperations addObject:operation];
    }
}

- (void)addNetworkOperation:(RetreatAppServiceConnectionOperation *)operation
{
    // If we've already queued a given network operation, don't queue any duplicates. Just bump the priority.
    NSMutableSet *networkOperations;
    CMTTaskPriority priorityOfExistingOperationsToCheck = CMTTaskPriorityHigh;
    while (priorityOfExistingOperationsToCheck >= operation.priority) {
        switch (priorityOfExistingOperationsToCheck) {
            case CMTTaskPriorityHigh: {
                networkOperations = self.highPriorityNetworkOperations;
                break;
            }
            case CMTTaskPriorityMedium: {
                networkOperations = self.mediumPriorityNetworkOperations;
                break;
            }
            case CMTTaskPriorityLow: {
                networkOperations = self.lowPriorityNetworkOperations;
                break;
            }
        }
        @synchronized (networkOperations) {
            if ([networkOperations containsObject:operation]) {
                // There is already a duplicate operation pending. Don't clog up higher priority queues with duplicate requests.
                @synchronized (self.deferredNetworkOperations) {
                    [self.deferredNetworkOperations addObject:operation];
                }
                return;
            }
        }
        priorityOfExistingOperationsToCheck--;
    }
    [networkOperations addObject:operation];
    [operation resumeNetworkTask];
}

- (void)completeNetworkOperation:(RetreatAppServiceConnectionOperation *)operation
{
    [self removeFromNetworkQueueAndResumeDeferralsForOperation:operation];
}

- (void)removeFromNetworkQueueAndResumeDeferralsForOperation:(RetreatAppServiceConnectionOperation *)operation
{
    NSMutableSet *networkOperations;
    switch (operation.priority) {
        case CMTTaskPriorityHigh: {
            networkOperations = self.highPriorityNetworkOperations;
            break;
        }
        case CMTTaskPriorityMedium: {
            networkOperations = self.mediumPriorityNetworkOperations;
            break;
        }
        case CMTTaskPriorityLow: {
            networkOperations = self.lowPriorityNetworkOperations;
            break;
        }
    }
    @synchronized (networkOperations) {
        if ([networkOperations containsObject:operation]) {
            [networkOperations removeObject:operation];
        } else {
        }
    }
    // If any tasks were deferred waiting on this, resume them.
    NSMutableArray *resumingNetworkOperations = [[NSMutableArray alloc] init];
    @synchronized (self.deferredNetworkOperations) {
        for (RetreatAppServiceConnectionOperation *deferredOperation in self.deferredNetworkOperations) {
            if ([deferredOperation isEqual:operation]) {
                [resumingNetworkOperations addObject:deferredOperation];
            }
        }
        [self.deferredNetworkOperations removeObjectsInArray:resumingNetworkOperations];
    }
    for (RetreatAppServiceConnectionOperation *resumingOperation in resumingNetworkOperations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ServiceCoordinator addNetworkOperation:resumingOperation priority:resumingOperation.priority];
        });
    }
}

- (void)completeLocalOperation:(SCOperation *)operation
{
    [self resumeDeferralsForOperation:operation];
}

- (void)resumeDeferralsForOperation:(SCOperation*)operation
{
    // If any tasks were deferred waiting on this, resume them.
    NSMutableArray *resumingLocalOperations = [[NSMutableArray alloc] init];
    @synchronized (self.deferredLocalOperations) {
        for (SCOperation *deferredOperation in self.deferredLocalOperations) {
            if ([deferredOperation isEqual:operation]) {
                [resumingLocalOperations addObject:deferredOperation];
            }
        }
        [self.deferredLocalOperations removeObjectsInArray:resumingLocalOperations];
    }
    for (SCOperation *resumingOperation in resumingLocalOperations) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ServiceCoordinator addLocalOperation:resumingOperation priority:CMTTaskPriorityMedium];
        });
    }
}

- (void)cancelAllOperations
{
    @synchronized (self) {
        @synchronized (self.deferredNetworkOperations) {
            [self.deferredNetworkOperations removeAllObjects];
        }
        @synchronized (self.deferredLocalOperations) {
            [self.deferredLocalOperations removeAllObjects];
        }
        [_serialOperationQueue cancelAllOperations];
        [_lowOperationQueue cancelAllOperations];
        [_defaultOperationQueue cancelAllOperations];
        [_highOperationQueue cancelAllOperations];
        for (RetreatAppServiceConnectionOperation *operation in [self.lowPriorityNetworkOperations copy]) {
            [operation cancel];
        }
        for (RetreatAppServiceConnectionOperation *operation in [self.mediumPriorityNetworkOperations copy]) {
            [operation cancel];
        }
        for (RetreatAppServiceConnectionOperation *operation in [self.highPriorityNetworkOperations copy]) {
            [operation cancel];
        }
    }
}

@end