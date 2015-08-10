//
//  RetreatAppServicesClient.m
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServicesClient.h"
#import "ServiceEndpoints.h"
#import "SettingsManager.h"

@implementation RetreatAppServicesClient
{
    NSDictionary *_parameters;
    RESTMethod _requestType;
    NSURLSession *_session;
}

-(instancetype)init
{
    return [self initWithAuthToken:nil];
}

-(instancetype)initWithAuthToken:(NSString*)authToken
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSMutableDictionary *headers =
        [NSMutableDictionary dictionaryWithDictionary:@{@"Content-Type": @"application/json"}];
        config.HTTPAdditionalHeaders = headers;
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

-(NSURLSessionDataTask*)createDataTaskWithRequest:(NSURLRequest*)request
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    return [_session dataTaskWithRequest:request completionHandler:completionHandler];
}

-(void)suspendAllTasks
{
    [_session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask *dataTask in dataTasks) {
            [dataTask suspend];
        }
        for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
            [uploadTask suspend];
        }
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
            [downloadTask suspend];
        }
    }];
}

-(void)cancelAllTasks
{
    // TODO: call this upon logout.
    [_session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask *dataTask in dataTasks) {
            [dataTask cancel];
        }
        for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
            [uploadTask cancel];
        }
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
            [downloadTask cancel];
        }
    }];
}

-(void)resumeAllTasks
{
    [_session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask *dataTask in dataTasks) {
            [dataTask resume];
        }
        for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
            [uploadTask resume];
        }
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
            [downloadTask resume];
        }
    }];
}

// For unit tests
-(NSURLSessionConfiguration *) sessionConfiguration
{
    return _session.configuration;
}

@end