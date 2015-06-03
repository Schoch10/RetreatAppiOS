//
//  SCNetworkOperation.m
//  SlalomCommon
//
//  Created by Greg Martin on 12/4/11.
//  Copyright (c) 2011 Slalom, LLC. All rights reserved.
//

#import "SCNetworkOperation.h"
#import "SCFileUtil.h"

@interface SCNetworkOperation ()

- (void)timeoutFired;
- (void)resetConnection;

@end

@implementation SCNetworkOperation
{
    NSString *tempPath;
    NSFileHandle *outputHandle;
}

- (void)start
{
    // default
    _timeoutInterval = 30;
    
    if(![self hasBeenCancelled])
    {
        [super start];
    }
}

- (BOOL)startRequest:(NSURLRequest *)request
{
    if([self hasBeenCancelled])
    {
        return NO;
    }
    
    if(!request)
    {
        [self requestFailedWithError:nil];
        
        return NO;
    }
    
    if(conn)
    {
        [self resetConnection];
    }
    
    [self startNetworkActivityIndicator];
    
    authenticationAttempt = 0;
    currentProgress = 0.0;
    contentSize = 0;
    bytesReceived = 0;
    conn = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
    
    if(conn)
    {
        // If downloadPath has been specificed setup file handle and temporary file
        if(self.downloadPath)
        {
            // create temp file path
            tempPath = [SCFileUtil temporaryFilePath];
            
            // create file handle
            outputHandle = [NSFileHandle fileHandleForWritingAtPath:tempPath];
        }
        
        // This code allows a ASync NSURLConnection to run in our operation, otherwise it runs on the main thread
        NSRunLoop* rl = [NSRunLoop currentRunLoop]; // Get the runloop
        
        if(_timeoutInterval > 0)
        {
            timeoutTimer = [NSTimer timerWithTimeInterval:_timeoutInterval target:self selector:@selector(timeoutFired) userInfo:nil repeats:NO];
            [rl addTimer:timeoutTimer forMode:NSDefaultRunLoopMode];
        }
        else
        {
            port = [NSPort port];
            [rl addPort:port forMode:NSDefaultRunLoopMode];
        }
        
        [conn scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
        [conn start];
        [rl run];
    }
    
    return conn != nil; // if nil, issue creating connection
}


- (void)timeoutFired
{
    [self requestFailedWithError:[NSError errorWithDomain:@"com.slalom.libSlalomCommon"
                                                     code:408
                                                 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"URL Connection Timeout Occurred. Connection time exceeded timeout value (%f seconds).", _timeoutInterval]}]];
}


- (void)requestFailedWithError:(NSError *)error
{
    SCLogMessage(kLogLevelError, @"%@", error);
    
    [self notifyOfFailure:error];
}



- (void)requestSucceeded
{
    // Override in inheriting class to do something with success
    [self notifyOfSuccess:nil];
}

- (void)progressUpdate
{
    // Override in inheriting class to do something with the progress of the download
}


- (void)resetConnection
{
    [self stopNetworkActivityIndicator];
    
    [conn cancel];
    
    [timeoutTimer invalidate];
    
    if(port)
    {
        NSRunLoop* rl = [NSRunLoop currentRunLoop];
        [rl removePort:port forMode:NSDefaultRunLoopMode];
    }
}


- (void)completeOperation
{
    [self resetConnection];
    
    [super completeOperation];
}


#pragma mark - NSURLConnection Methods


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [timeoutTimer invalidate];
    
    // Notify of error
    [self requestFailedWithError:error];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(![self hasBeenCancelled])
    {
        if([response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            statusCode = httpResponse.statusCode;
            contentType = (httpResponse.allHeaderFields)[@"Content-Type"];
            responseHeaders = httpResponse.allHeaderFields;
            
            if (statusCode == 200)
            {
                contentSize = [response expectedContentLength];
            }
        }
        [timeoutTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeoutInterval]];
        responseData = [NSMutableData data];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(![self hasBeenCancelled])
    {
        if(data && data.length > 0)
        {
            // write to disk if output specified, otherwise load into memory
            if(outputHandle)
            {
                [outputHandle writeData:data];
            }
            else
            {
                [responseData appendData:data];
            }
            
            bytesReceived += data.length;
            currentProgress = ((float) bytesReceived / (float) contentSize);
            
            // Broadcast a notification with the progress change
            [self progressUpdate];
            
            // Reset the timer
            [timeoutTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeoutInterval]];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if(![self hasBeenCancelled])
    {
        if(bytesWritten > 0)
        {
            currentProgress = ((float) totalBytesWritten / (float) totalBytesExpectedToWrite);
            [timeoutTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeoutInterval]];
            [self progressUpdate];
        }
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(![self hasBeenCancelled])
    {
        [timeoutTimer invalidate];
        
        if(outputHandle)
        {
            [outputHandle closeFile];
            outputHandle = nil;
            
            // Only move file if this was successful
            if(statusCode >= 200 && statusCode < 300)
            {
                NSError *error = nil;
                
                if([[NSFileManager defaultManager] fileExistsAtPath:self.downloadPath])
                {
                    // Remove existing file at destination
                    [[NSFileManager defaultManager] removeItemAtPath:self.downloadPath error:&error];
                }
                else
                {
                    // Ensure path leading to file exists
                    [[NSFileManager defaultManager] createDirectoryAtPath:[self.downloadPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
                }
                
                if(error)
                {
                    [self requestFailedWithError:error];
                    
                    return;
                }
                
                // copy completed file from temp to requested location
                [[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:self.downloadPath error:&error];
                
                if(error)
                {
                    [self requestFailedWithError:error];
                    
                    return;
                }
            }
        }
        
        [self requestSucceeded];
    }
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return ![protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        if(self.allowUntrustedServers)
        {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
        else
        {
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
    else
    {
        if(authenticationAttempt == 0)
        {
            [timeoutTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeoutInterval]];
            [[challenge sender] useCredential:credentials forAuthenticationChallenge:challenge];
            authenticationAttempt++;
        }
        else
        {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Authentication Error"};
            NSError *authError = [NSError errorWithDomain:@"com.slalom.libSlalomCommon" code:401 userInfo:userInfo];
            [self connection:connection didFailWithError:authError];
        }
    }
}


- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    //Do not cache creds by default. Force re-auth everytime.
    return NO;
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    //Do not cache results from the connection. Saves on memory footprint.
    return nil;
}


@end
