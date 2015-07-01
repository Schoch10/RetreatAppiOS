//
//  SCNetworkOperation.h
//  SlalomCommon
//
//  Created by Greg Martin on 12/4/11.
//  Copyright (c) 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConcurrentOperation.h"

@interface SCNetworkOperation : SCConcurrentOperation <NSURLConnectionDelegate>
{
    NSURLConnection *conn;
    NSURLCredential *credentials;
    NSInteger statusCode;
    NSString *contentType;
    NSInteger authenticationAttempt;
    NSMutableData *responseData;
    NSTimer *timeoutTimer;
    long long contentSize;
    NSUInteger bytesReceived;
    float currentProgress;
    NSDictionary *responseHeaders;
    NSPort *port;
}

@property (nonatomic) NSTimeInterval timeoutInterval;
@property (nonatomic) BOOL allowUntrustedServers;
@property (nonatomic, retain) NSString *downloadPath;

- (BOOL)startRequest:(NSURLRequest *)request;
- (void)requestFailedWithError:(NSError *)error;
- (void)requestSucceeded;
- (void)progressUpdate;

// Subclasses can override this to change which status codes succeed. Otherwise only 200-299 succeed.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
