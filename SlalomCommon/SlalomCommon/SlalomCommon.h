//
//  SlalomCommon.h
//  SlalomCommon
//
//  Created by Greg Martin on 7/2/08.
//  Copyright 2008 Slalom, LLC. All rights reserved.
//

#import "SCConfigurationUtil.h"
#import "SCKeychain.h"
#import "NSData+Base64.h"
#import "NSOperationQueue+SharedQueue.h"
#import "NSString+Extensions.h"
#import "UIAlertView+Extensions.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"
#import "NSError+Extensions.h"
#import "NSURL+StaticData.h"
#import "Reachability+SharedReachability.h"
#import "UIColor+Extensions.h"
#import "UIView+Position.h"

/** Number of seconds in 1 minute. */
#define kSecondsInMinute 60.0

/** Number of minutes in 1 hour. */
#define kMinutesInHour 60.0

/** Number of seconds in 1 hour. */
#define kSecondsInHour 3600

/** Number of seconds in 1 day. */
#define kSecondsInDay 86400.0

/** Number of seconds in 1 week. */
#define kSecondsInWeek 604800.0

/** Average Number of seconds in 1 month. */
#define kSecondsInMonth 2628000.0

/** Number of seconds in 1 year. */
#define kSecondsInYear 31536000.0

/** Default animation duration. */
#define kDefaultAnimationDuration 0.3

/** Default HUD Dismisal delay duration. */
#define kHUDErrorDelay 1.7

/** A wrapper for `NSLocalizedString` to simply retreive localized strings from the Localizable.strings file. */
#define SCLocStr(key) NSLocalizedString((key),@"")

/** Convert Degrees to Radians */
#define DegreesToRadians(angle) ((angle) / 180.0 * M_PI)

#define kBytesInGiabyte 1073741824.0
#define kBytesInMegabyte 1048816.0
#define kBytesInKilobyte 1024.0
#define kKiloBytesInMegabyte 1024.0

// Device Type
#define kIsIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIsIphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define ifPadElse(t,f) ( kIsIpad ? t : f )
#define ifPhoneElse(t,f) ( kIsIphone ? t : f )

NSInteger logLevel;

#define kLogLevelDebug 1
#define kLogLevelInfo 2
#define kLogLevelWarn 3
#define kLogLevelError 4

#define SCLogMessage(LEVEL, format, ...)    \
if (LEVEL>=logLevel) {\
if ( LEVEL == kLogLevelError) NSLog(@"ERROR: %s[ln %d] " format,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__); \
else if( LEVEL == kLogLevelWarn) NSLog(@"WARN: %s[ln %d] " format,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);        \
else if(LEVEL == kLogLevelInfo) NSLog(@"INFO: %s[ln %d] " format,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);        \
else if(LEVEL == kLogLevelDebug) NSLog(@"DEBUG: %s[ln %d] " format,__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#define SCLogIf(LEVEL, obj) if(obj != nil) { SCLogMessageWithNoClassInfo(LEVEL, @"%@", obj); }

/** A wrapper for NSLog that honors the logLevel set in the Info.plist. */
#define SCLogMessageWithNoClassInfo(LEVEL, format, ...)    \
if (LEVEL>=logLevel) {\
if ( LEVEL == kLogLevelError) NSLog(@"ERROR:" format,##__VA_ARGS__); \
else if( LEVEL == kLogLevelWarn) NSLog(@"WARN:" format,##__VA_ARGS__); \
else if(LEVEL == kLogLevelInfo) NSLog(@"INFO:" format,##__VA_ARGS__); \
else if(LEVEL == kLogLevelDebug) NSLog(@"DEBUG:" format,##__VA_ARGS__);}

#if !DEBUG

#define NSLog(...) /* suppress NSLog when in release mode */

#endif

/** The common header file for macros and pre-processor directives. */
@interface SlalomCommon : NSObject{}
@end