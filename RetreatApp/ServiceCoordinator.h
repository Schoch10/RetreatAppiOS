//
//  ServiceCoordinator.h
//  MindTapiPhone
//
//  Created by Brendan Schoch on 10/2/14.
//  Copyright (c) 2014 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MindTapMobileServiceClient.h"
#import "SCOperation.h"

typedef NS_ENUM(NSInteger, CMTTaskPriority) {
    CMTTaskPriorityLow,
    CMTTaskPriorityMedium,
    CMTTaskPriorityHigh
};

@class MTServiceConnectionOperation;

@interface ServiceCoordinator : NSObject

+(ServiceCoordinator*)sharedCoordinator;
//-(MindTapMobileServiceClient*)serviceClientWithoutAuth;
//-(MindTapMobileServiceClient*)serviceClientWithAuth;
+(void)addLocalOperation:(SCOperation*)operation priority:(CMTTaskPriority)priority;
+(void)addLocalOperation:(SCOperation *)operation completion:(void (^)(void))completion;
//+(void)addNetworkOperation:(MTServiceConnectionOperation*)operation priority:(CMTTaskPriority)priority;
//-(void)completeNetworkOperation:(MTServiceConnectionOperation*)operation;
-(void)completeLocalOperation:(SCOperation *)operation;
//-(void)cancelAllOperations;

@end
