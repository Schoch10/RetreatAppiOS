//
//  RetreatAppServiceConnectionOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCoordinator.h"
#import "RetreatAppServicesClient.h"

@protocol RetreatServiceTaskDelegate <NSObject>

@required
-(void)serviceTaskDidReceiveResponseJSON:(id)responseJSON;

@optional
-(void)serviceTaskDidFailToCompleteRequest:(NSError *)error;
-(void)serviceTaskDidReceiveStatusFailure:(HttpStatusCode)httpStatusCode;

@end

@interface RetreatAppServiceConnectionOperation : NSObject <NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSObject<RetreatServiceTaskDelegate> *delegate;
@property (nonatomic, readonly) HttpStatusCode httpStatusSucceeded;
@property (nonatomic) CMTTaskPriority priority;
@property (nonatomic, readonly) NSURL *url;

-(id)initWithMethod:(RESTMethod)requestType forEndpoint:(NSString *)endpoint withParams:(NSDictionary *)params;
- (BOOL)shouldDownloadFromNetwork;
- (BOOL)useCachedDataIfAvailable;
- (void)resumeNetworkTask;
- (void)completeFromCacheWithNoData;
- (NSError*)errorForHttpStatusCode:(HttpStatusCode)statusCode;
- (void)cancel;

@end
