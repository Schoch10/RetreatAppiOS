//
//  NSError+Extensions.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/9/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "NSError+Extensions.h"

@implementation NSError (Extensions)

+ (id)errorWithException:(NSException *)exception
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if(exception.name)
    {
        [userInfo setValue:exception.name forKey:@"name"];
    }
    if(exception.reason)
    {
        [userInfo setValue:exception.reason forKey:@"reason"];
    }
    if(exception.userInfo)
    {
        [userInfo setValue:exception.userInfo forKey:@"userInfo"];
    }
    if(exception.callStackReturnAddresses)
    {
        [userInfo setValue:exception.callStackReturnAddresses forKey:@"callStackReturnAddresses"];
    }
    if(exception.callStackSymbols)
    {
        [userInfo setValue:exception.callStackSymbols forKey:@"callStackSymbols"];
    }
    
    return [[NSError alloc] initWithDomain:@"ExceptionDomain" code:0 userInfo:userInfo];
}

- (BOOL)isSSLError
{
    if([self.domain caseInsensitiveCompare:NSURLErrorDomain] == NSOrderedSame
       && (self.code == NSURLErrorSecureConnectionFailed
           || self.code == NSURLErrorServerCertificateHasBadDate
           || self.code == NSURLErrorServerCertificateUntrusted
           || self.code == NSURLErrorServerCertificateHasUnknownRoot
           || self.code == NSURLErrorServerCertificateNotYetValid
           || self.code == NSURLErrorClientCertificateRejected
           || self.code == NSURLErrorClientCertificateRequired))
    {
        return YES;
    }
    
    return NO;
}

@end
