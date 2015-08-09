//
//  RetreatAppServicesClient.h
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RESTMethod) {
    RESTMethodGet,
    RESTMethodPut,
    RESTMethodPost,
    RESTMethodDelete,
};

typedef NS_ENUM(NSInteger, RAEndpoint) {
    RAEndpointCreateUser,
    RAEndpointPollParticipants,
    RAEndpointCheckin
};

typedef NS_ENUM(NSInteger, HttpStatusCode) {
    HttpStatusCode200OK = 200,
    HttpStatusCode204OK = 204,
    HttpStatusCode300MultipleChoices = 300,
    HttpStatusCode400BadInputParameter = 400,
    HttpStatusCode401Unauthorized = 401,
    HttpStatusCode404NotFound = 404,
    HttpStatusCode405MethodNotExpected = 405,
    HttpStatusCode415UnsupportedMediaType = 415
};

@interface RetreatAppServicesClient : NSObject

@property (nonatomic, strong) NSString *environmentBaseURL;
@property (nonatomic, readonly) HttpStatusCode getHttpSucceeded;

// For unit tests
@property (nonatomic, readonly) NSURLSessionConfiguration *sessionConfiguration;


-(id)initWithAuthToken:(NSString*)authToken;

-(NSURLSessionDataTask*)createDataTaskWithRequest:(NSURLRequest*)request
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

-(void)suspendAllTasks;
-(void)cancelAllTasks;

@end
