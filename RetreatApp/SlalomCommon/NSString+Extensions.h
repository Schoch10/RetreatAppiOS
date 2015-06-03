//
//  NSString+Extensions.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** These categories extend NSString with commonly used functionality.  */
@interface NSString (Extensions)

/** Checks the passed string value to determie if it is the null or empty string
 
 @param value The string to check.
 */
+ (BOOL)isNullOrEmpty:(NSString *)value;

/** Checks the passed in string for null or empty.  If so, return defaultValue
 @param value  The String to check.
 @param defaultValue The String to return if null or empty
 **/
+(NSString*) value:(NSString*)value orDefault:(NSString*)defaultValue;

/** Removes any whitespace from the begining and end of this string. */
- (NSString *)trim;

/** Properly encodes this string for inclusion in a URL */
- (NSString *)urlEncodedString;

/**Properly encodes this string for inclusion in HTML post*/
-(NSString*)htmlEncodedString;

/** Properly url decodes this string */
- (NSString *)urlDecodedString;

/**Properly html decodes */
-(NSString*)htmlDecodedString;

/** Returns a string containing the numberic characters in this string instance */
- (NSString *)stringOfNumericCharacters;

/** Pads a string to the left of the index with the padString provided*/
- (NSString *)stringByPaddingTheLeftToLength:(NSUInteger)newLength withString:(NSString *)padString startingAtIndex:(NSUInteger)padIndex;

/** Returns true if this string starts with the provided value, otherwise false. */
- (BOOL)startsWith:(NSString *)aString options:(NSStringCompareOptions)mask;


- (BOOL) containsString:(NSString *) string;
- (BOOL) containsString:(NSString *) string options:(NSStringCompareOptions) options;

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)characterSet;

@end


