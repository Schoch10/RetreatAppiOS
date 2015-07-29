//
//  RetreatAppCommon.h
//  RetreatApp
//
//  Created by Brendan Schoch on 7/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SlalomCommon.h"

#define kUnknownErrorDomain @"UnknownError"
#define kServiceErrorDomain @"ServiceError"
#define kCoreDataErrorDomain @"CoreData"
#define kMindtapErrorDomain @"com.slalom.retreatapp"

// Device Type
/*#define kIsIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIsIphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define ifPadElse(t,f) ( kIsIpad ? t : f )
#define ifPhoneElse(t,f) ( kIsIphone ? t : f ) */

typedef NS_ENUM(NSInteger, ErrorCode) {
    ErrorCodeCoreDataFailedSave,
    ErrorCodeDataTaskFailed,
    ErrorCodeInvalidResponseJSON,
    ErrorCodeUnauthorized,
    ErrorCodeHideFlashcardFailed,
    ErrorCodeGenerateQuizFailed,
    ErrorCodeNoSuchQuiz,
    ErrorCodeCannotFindHost,
    ErrorCodeTimedOut,
    ErrorCodeNoData,
    ErrorCodeFailedToRegisterForPushNotifications,
    ErrorCodeConnectionFailed
};