//
//  ServiceCoordinator.h
//  MindTapiPhone
//
//  Created by Brendan Schoch on 10/2/14.
//  Copyright (c) 2014 Slalom Consulting. All rights reserved.
//

#import "SCOperation.h"
#import "RetreatAppServicesClient.h"

typedef NS_ENUM(NSInteger, CMTTaskPriority) {
    CMTTaskPriorityLow,
    CMTTaskPriorityMedium,
    CMTTaskPriorityHigh
};

@class RetreatAppServiceConnectionOperation;

@interface ServiceCoordinator : NSObject

+(ServiceCoordinator*)sharedCoordinator;
-(RetreatAppServicesClient *)serviceClientWithoutAuth;
-(RetreatAppServicesClient *)serviceClientWithAuth; 
+(void)addLocalOperation:(SCOperation*)operation priority:(CMTTaskPriority)priority;
+(void)addLocalOperation:(SCOperation *)operation completion:(void (^)(void))completion;
+(void)addNetworkOperation:(RetreatAppServiceConnectionOperation *)operation priority:(CMTTaskPriority)priority;
-(void)completeNetworkOperation:(RetreatAppServiceConnectionOperation*)operation;
-(void)completeLocalOperation:(SCOperation *)operation;
-(void)cancelAllOperations;

@end
