//
//  RetreatAppServiceConnectionOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"
#import "ServiceEndpoints.h"
#import "SettingsManager.h"

static int const CMTServiceConnectionMaxAttempts = 2;

@interface RetreatAppServiceConnectionOperation()

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic) int numberOfAttempts;

@end

@implementation RetreatAppServiceConnectionOperation
{
    NSURL *_url;
}

-(NSString *)getRequestTypeString:(RESTMethod)requestType
{
    switch (requestType) {
        case RESTMethodGet:
            return @"GET";
        case RESTMethodPut:
            return @"PUT";
        case RESTMethodPost:
            return @"POST";
        case RESTMethodDelete:
            return @"DELETE";
        default:
            NSLog(@"-getRequestTypeString invalid RESTMethod. Expected GET, PUT, or POST");
            return nil;
    }
}

-(NSURL*)url
{
    return _url;
}

-(BOOL)isHttpStatusSucceeded:(HttpStatusCode)statusCode
{
    return statusCode >= HttpStatusCode200OK && statusCode < HttpStatusCode300MultipleChoices;
}

-(id)initWithMethod:(RESTMethod)requestType forEndpoint:(NSString *)endpoint withParams:(NSDictionary *)params
{
    NSString *endpointUrlString = [ServiceEndpoints getEndpointURL:endpoint];
    NSMutableDictionary *normalizedParams = [[NSMutableDictionary alloc] initWithCapacity:params.count];
    NSData *parameterData;
    for (NSString *parameterName in params.allKeys) {
        NSString *parameterTemplateSyntax = [NSString stringWithFormat:@"{%@}", parameterName];
        id parameterValueId = [params objectForKey:parameterName];
        NSString *parameterValue;
        if ([parameterValueId isKindOfClass:[NSString class]]) {
            parameterValue = parameterValueId;
            parameterData = nil;
        } else if ([parameterValueId respondsToSelector:@selector(stringValue)]) {
            parameterValue = [parameterValueId stringValue];
            parameterData = nil;
        } else if (!parameterValueId) {
            SCLogMessage(kLogLevelError, @"nil parameter value not allowed");
            continue;
        } else if ([parameterValueId isKindOfClass:[NSData class]]) {
            parameterValue = parameterValueId;
            parameterData = nil;
        } else {
            if ([parameterValueId isKindOfClass:[NSSet class]]) {
                parameterValueId = [parameterValueId allObjects];
            }
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterValueId
                                                               options:0 error:&error];
            parameterValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        if (parameterData == nil) {
            normalizedParams[parameterName] = parameterValueId;
            endpointUrlString = [endpointUrlString stringByReplacingOccurrencesOfString:parameterTemplateSyntax withString:parameterValue];
        }
    }
    _url = [NSURL URLWithString:endpointUrlString];
    if (!_url) {
        SCLogMessage(kLogLevelError, @"no url for endpoint %@ via template %@", endpoint, endpointUrlString);
        return nil;
    }
    NSMutableURLRequest *request = self.request = [NSMutableURLRequest requestWithURL:_url];
    request.HTTPMethod = [self getRequestTypeString:requestType];
    NSData *jsonData;
    NSError *error;
    SCLogMessage(kLogLevelDebug, @"%@", endpoint);
    switch (requestType) {
        case RESTMethodPost:
           if ([endpoint isEqualToString:@"doPost"]) {
               NSString *image_name = @"test";
               NSString *boundary = @"14737809831466499882746641449";
               NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
               [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
               NSMutableData *body = [NSMutableData data];
               [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
               [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"file\"; filename=\"%@\"\r\n",image_name] dataUsingEncoding:NSUTF8StringEncoding]];
               [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
               [body appendData:[NSData dataWithData:parameterData]];
               [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
               SCLogMessage(kLogLevelDebug, @"Data %@", body);
               request.HTTPBody = body;
    
            } else {
                jsonData = [NSJSONSerialization dataWithJSONObject:normalizedParams
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
                SCLogMessage(kLogLevelDebug, @"data: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
                request.HTTPBody = jsonData;
            }
            break;
        case RESTMethodGet:
            // GET needs no body.
            break;
            
        case RESTMethodPut:
            jsonData = [NSJSONSerialization dataWithJSONObject:normalizedParams
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
            SCLogMessage(kLogLevelDebug, @"data: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
            request.HTTPBody = jsonData;
            break;
        case RESTMethodDelete:
            //Delete has no body
            break;
        default:
            SCLogMessage(kLogLevelError, @"unimplemented REST method");
            break;
    }
    return self;
}

- (NSURLSessionDataTask *)dataTask
{
    if (_dataTask != nil) {
        return _dataTask;
    }
    _dataTask = [self.client createDataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            SCLogMessage(kLogLevelError, @"Network task error: %@", error);
            NSString *errorDomain = error.domain;
            NSInteger codeToReport = ErrorCodeDataTaskFailed;
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                switch (error.code) {
                    case NSURLErrorCannotFindHost:
                        errorDomain = kServiceErrorDomain;
                        codeToReport = ErrorCodeCannotFindHost;
                        break;
                    case NSURLErrorSecureConnectionFailed:
                        if (self.numberOfAttempts < CMTServiceConnectionMaxAttempts) {
                            // try again per https://github.com/AFNetworking/AFNetworking/issues/2314#issuecomment-56664366
                            NSURLSessionDataTask *failedTask = _dataTask;
                            _dataTask = nil;
                            _dataTask = self.dataTask;
                            self.numberOfAttempts++;
                            [ServiceCoordinator addNetworkOperation:self priority:self.priority];
                            failedTask = nil;
                            return;
                        }
                        errorDomain = kServiceErrorDomain;
                        codeToReport = ErrorCodeConnectionFailed;
                        break;
                    case NSURLErrorTimedOut:
                        errorDomain = kServiceErrorDomain;
                        codeToReport = ErrorCodeTimedOut;
                        break;
                }
            }
            NSError *errorToReport = [NSError errorWithDomain:errorDomain code:codeToReport userInfo:@{@"taskError":error,@"url":self.url}];
            [self.delegate serviceTaskDidFailToCompleteRequest:errorToReport];
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            id responseJSON;
            NSError *jsonError;
            switch(httpResponse.statusCode) {
                case HttpStatusCode200OK:
                    SCLogMessage(kLogLevelDebug, @"HTTP status 200 OK from %@", self.url);
                    responseJSON =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&jsonError];
                    if (jsonError) {
                        SCLogMessage(kLogLevelWarn, @"JSON error: %@, for response \"%@\"", jsonError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                        NSError *jsonErrorToReport =
                        [NSError errorWithDomain:kServiceErrorDomain
                                            code:ErrorCodeInvalidResponseJSON
                                        userInfo:@{@"jsonError": jsonError}];
                        [self.delegate serviceTaskDidFailToCompleteRequest:jsonErrorToReport];
                    } else {
                        //SCLogMessage(kLogLevelDebug, @"Read from %@ JSON: %@", self.url, responseJSON);
                        [self.delegate serviceTaskDidReceiveResponseJSON:responseJSON];
                    }
                    break;
                case HttpStatusCode204OK:
                    //Delete Success Code
                    [self.delegate serviceTaskDidReceiveResponseJSON:nil];
                    break;
                case HttpStatusCode401Unauthorized:
                    SCLogMessage(kLogLevelWarn, @"Unauthorized");
                    [self.delegate serviceTaskDidReceiveStatusFailure:httpResponse.statusCode];
                    break;
                default:
                    if ([self isHttpStatusSucceeded:httpResponse.statusCode]) {
                        SCLogMessage(kLogLevelWarn, @"HTTP status code %li succeeded", (long)httpResponse.statusCode);
                    } else {
                        SCLogMessage(kLogLevelWarn, @"HTTP status code %li failed", (long)httpResponse.statusCode);
                    }
                    [self.delegate serviceTaskDidReceiveStatusFailure:httpResponse.statusCode];
                    break;
            }
        }
        ServiceCoordinator *coordinator = [ServiceCoordinator sharedCoordinator];
        [coordinator completeNetworkOperation:self];
    }
                 ];
    return _dataTask;
}

- (void)cancel
{
    if (_dataTask) {
        [_dataTask cancel];
    }
    self.request = nil;
}

- (RetreatAppServicesClient *)client
{
    // Network operations that don't need an auth token can override this as -clientWithoutAuth
    return [[ServiceCoordinator sharedCoordinator] serviceClientWithAuth];
}

- (NSError *)errorForHttpStatusCode:(HttpStatusCode)httpStatusCode
{
    switch (httpStatusCode) {
        case HttpStatusCode401Unauthorized:
            return [NSError errorWithDomain:kServiceErrorDomain
                                       code:ErrorCodeUnauthorized
                                   userInfo:@{@"url": self.url}];
            
        default:
            return [NSError errorWithDomain:kServiceErrorDomain
                                       code:httpStatusCode
                                   userInfo:@{@"httpStatusCode": @(httpStatusCode),
                                              @"url": self.url
                                              }];
    }
}

- (BOOL)shouldDownloadFromNetwork
{
    // Subclasses should override this.
    return YES;
}

- (BOOL)useCachedDataIfAvailable
{
    // Subclasses should implement this.
    return NO;
}

- (void)completeFromCacheWithNoData
{
    // Subclasses should implement this.
}

// Only ServiceCoordinator should call this method directly.
- (void)resumeNetworkTask
{
    SettingsManager *settings = [SettingsManager sharedManager];
    if ([settings iosIsAtLeastVersion:@"8.0"]) {
        float dataTaskPriority;
        switch (self.priority) {
            case CMTTaskPriorityHigh:
                dataTaskPriority = NSURLSessionTaskPriorityHigh;
                break;
            case CMTTaskPriorityMedium:
                dataTaskPriority = NSURLSessionTaskPriorityDefault;
                break;
            case CMTTaskPriorityLow:
                dataTaskPriority = NSURLSessionTaskPriorityLow;
                break;
        }
        [self.dataTask setPriority:dataTaskPriority];
    }
    [self.dataTask resume];
}

@end

