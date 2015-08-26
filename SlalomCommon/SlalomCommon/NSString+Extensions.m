//
//  NSStringExtensions.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "NSString+Extensions.h"


@implementation NSString (Extensions)


+(NSString*) value:(NSString*)value orDefault:(NSString*)defaultValue;
{
    return ([NSString isNullOrEmpty: value] ? defaultValue : value );
}



+ (BOOL)isNullOrEmpty:(NSString *)value
{
	if(value == nil
       || value.length == 0)
	{
		return YES;
	}
	
	return NO;
}

- (NSString *)trim 
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)urlEncodedString
{
    return [self encodeWithEscapeChars: @[@";" , @"/" , @"?" , @":" ,
                                         @"@" , @"&" , @"=" , @"+" ,
                                         @"$" , @"," , @"[" , @"]",
                                         @"#", @"!", @"'", @"(",
                                         @")", @"*", @" "]
                          replaceChars: @[@"%3B" , @"%2F" , @"%3F" ,
                                         @"%3A" , @"%40" , @"%26" ,
                                         @"%3D" , @"%2B" , @"%24" ,
                                         @"%2C" , @"%5B" , @"%5D", 
                                         @"%23", @"%21", @"%27",
                                         @"%28", @"%29", @"%2A", @"%20"]
            ];
}

- (NSString *)urlDecodedString
{
    return [self encodeWithEscapeChars: @[@"%3B" , @"%2F" , @"%3F" ,
                                          @"%3A" , @"%40" , @"%26" ,
                                          @"%3D" , @"%2B" , @"%24" ,
                                          @"%2C" , @"%5B" , @"%5D",
                                          @"%23", @"%21", @"%27",
                                          @"%28", @"%29", @"%2A", @"%20"]
                          replaceChars: @[@";" , @"/" , @"?" , @":" ,
                                         @"@" , @"&" , @"=" , @"+" ,
                                         @"$" , @"," , @"[" , @"]",
                                         @"#", @"!", @"'", @"(",
                                         @")", @"*", @" "]
            ];
}

-(NSString*)htmlEncodedString
{
    return [self encodeWithEscapeChars: @[@"&", @"\"", @"\\",@"\'", @">", @"<"]
                          replaceChars: @[@"&amp;",@"&quot;",@"&#92;",@"&#39;",@"&gt;", @"&lt;"]
            ];
}

-(NSString*)htmlDecodedString
{
    return [self encodeWithEscapeChars: @[@"&amp;",@"&quot;",@"&#92;",@"&#39;",@"&gt;", @"&lt;"]
                          replaceChars: @[@"&", @"\"", @"\\",@"\'", @">", @"<"]
            ];
}


//-(NSString*) encode:(NSString*)str escapeChars:(NSArray*)escapeChars replaceChars:(NSArray*)replaceChars;
-(NSString*) encodeWithEscapeChars:(NSArray*)escapeChars replaceChars:(NSArray*)replaceChars
{
    NSInteger len = [escapeChars count];
	
    NSMutableString *temp = [self mutableCopy];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString: escapeChars[i]
							  withString:replaceChars[i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    return temp;
}


- (NSString *)stringOfNumericCharacters
{
	NSMutableString *digits = [NSMutableString string];
	
	if(self.length > 0)
	{
		NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
		
		// keep out only numeric values
		for(int i = 0; i < self.length; i++)
		{
			unichar c = [self characterAtIndex:i];
			
			if([numbers characterIsMember:c])
			{
				[digits appendString:[NSString stringWithCharacters:&c length:1]];
			}
		}
	}
	
	return digits;
}

- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger)newLength withString:(NSString *)padString startingAtIndex:(NSUInteger)padIndex
{
    if ([self length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [self length] withString:padString startingAtIndex:padIndex] stringByAppendingString:self];
    else
        return [self copy];
}

- (BOOL)startsWith:(NSString *)aString options:(NSStringCompareOptions)mask
{
    return ([self rangeOfString:aString options:mask].location == 0);
}



- (BOOL) containsString:(NSString *) string options:(NSStringCompareOptions) options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL) containsString:(NSString *) string {
    return [self containsString:string options:0];
}

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)characterSet
{
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
}

@end
