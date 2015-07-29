//
//  NSError+RetreatApp.m
//  RetreatApp
//
//  Created by Brendan Schoch on 7/27/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "NSError+RetreatApp.h"
#import "RetreatAppServicesClient.h"

@implementation NSError (RetreatApp)

- (NSString *)presentableMessage
{
    NSString *userFriendlyMessage = [self userFriendlyMessage];
#if DEBUG || PRE_RELEASE
    return [NSString stringWithFormat:@"%@ [debug info:%@]", userFriendlyMessage, self.userInfo];
#else
    return userFriendlyMessage
#endif
}

- (NSString *)userFriendlyMessage
{
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        switch (self.code) {
            case kCFURLErrorBadURL:
                return @"error";
            case kCFURLErrorTimedOut:
                return @"error";
            case kCFURLErrorNetworkConnectionLost:
                return @"error";
            case kCFURLErrorNotConnectedToInternet:
                return @"error";
            case ErrorCodeDataTaskFailed:
                return @"error";
            default:
                return @"error";
        }
    } else if ([self.domain isEqualToString:kServiceErrorDomain]) {
        switch (self.code) {
            case ErrorCodeCannotFindHost:
                return @"error";
            case ErrorCodeInvalidResponseJSON:
                return @"error";
            case ErrorCodeUnauthorized:
                return @"error";
            case ErrorCodeTimedOut:
                return @"error";
            case ErrorCodeNoData:
                return @"error";
            case ErrorCodeConnectionFailed:
                return @"error";
            default:
                return @"error";
        }
    } else if ([self.domain isEqualToString:kMindtapErrorDomain]) {
        switch (self.code) {
            case ErrorCodeHideFlashcardFailed:
                return @"error";
            case ErrorCodeGenerateQuizFailed:
                return @"error";
            case ErrorCodeNoSuchQuiz:
                return @"error";
            case ErrorCodeCoreDataFailedSave:
                return @"error";
            case ErrorCodeNoData:
                return @"error";
            case ErrorCodeFailedToRegisterForPushNotifications:
                return @"error";
        }
    }
    return @"error";
}

@end
