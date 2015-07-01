//
//  SCKeychain.m
//  SlalomCommon
//
//  Created by Greg Martin on 5/3/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "SCKeychain.h"


@implementation SCKeychain

+ (BOOL)setString:(NSString *)string forKey:(NSString *)account {
    if (account == nil) {
        return NO;
    }
    
    // First check if it already exists, by creating a search dictionary and requesting that
    // nothing be returned, and performing the search anyway.
    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    existsQueryDictionary[(id)kSecClass] = (id)kSecClassGenericPassword;
    
    // Add the keys to the search dict
    existsQueryDictionary[(id)kSecAttrService] = @"service";
    existsQueryDictionary[(id)kSecAttrAccount] = account;
    
    OSStatus res = SecItemCopyMatching((CFDictionaryRef)existsQueryDictionary, NULL);
    if (res == errSecItemNotFound)
    {
        if (string != nil) 
        {
            NSMutableDictionary *addDict = existsQueryDictionary;
            addDict[(id)kSecValueData] = data;
            
            res = SecItemAdd((CFDictionaryRef)addDict, NULL);
            NSAssert1(res == errSecSuccess, @"Recieved %ld from SecItemAdd!", (long)res);
        }
    }
    else if (res == errSecSuccess)
    {
        if(data != nil)
        {
            // Modify an existing one
            // Actually pull it now of the keychain at this point.
            NSDictionary *attributeDict = @{(id)kSecValueData: data};
            
            res = SecItemUpdate((CFDictionaryRef)existsQueryDictionary, (CFDictionaryRef)attributeDict);
            NSAssert1(res == errSecSuccess, @"SecItemUpdated returned %ld!", (long)res);
        }
        else
        {
            res = SecItemDelete((CFDictionaryRef)existsQueryDictionary);
            NSAssert1(res == errSecSuccess, @"SecItemDelete returned %ld!", (long)res);
        }
    } 
    else 
    {
        NSAssert1(NO, @"Received %ld from SecItemCopyMatching!", (long)res);
    }
    
    return YES;
}

+ (NSString *)stringForKey:(NSString *)account {
    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
    
    existsQueryDictionary[(id)kSecClass] = (id)kSecClassGenericPassword;
    
    // Add the keys to the search dict
    existsQueryDictionary[(id)kSecAttrService] = @"service";
    existsQueryDictionary[(id)kSecAttrAccount] = account;
    
    // We want the data back
    NSData *data = nil;
    
    existsQueryDictionary[(id)kSecReturnData] = (id)kCFBooleanTrue;
    
    OSStatus res = SecItemCopyMatching((CFDictionaryRef)existsQueryDictionary, (CFTypeRef *)&data);
    [data autorelease];
    if (res == errSecSuccess) {
        NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        return string;
    } else {
        NSAssert1(res == errSecItemNotFound, @"SecItemCopyMatching returned %ld!", (long)res);
    }
    
    return nil;
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key
{
    if (key == nil) {
        return NO;
    }
    
    // First check if it already exists, by creating a search dictionary and requesting that
    // nothing be returned, and performing the search anyway.
    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
    
    existsQueryDictionary[(id)kSecClass] = (id)kSecClassGenericPassword;
    
    // Add the keys to the search dict
    existsQueryDictionary[(id)kSecAttrService] = @"service";
    existsQueryDictionary[(id)kSecAttrAccount] = key;
    
    OSStatus res = SecItemCopyMatching((CFDictionaryRef)existsQueryDictionary, NULL);
    if (res == errSecItemNotFound)
    {
        if (data != nil)
        {
            NSMutableDictionary *addDict = existsQueryDictionary;
            addDict[(id)kSecValueData] = data;
            
            res = SecItemAdd((CFDictionaryRef)addDict, NULL);
            NSAssert1(res == errSecSuccess, @"Recieved %ld from SecItemAdd!", (long)res);
        }
    }
    else if (res == errSecSuccess)
    {
        if(data != nil)
        {
            // Modify an existing one
            // Actually pull it now of the keychain at this point.
            NSDictionary *attributeDict = @{(id)kSecValueData: data};
            
            res = SecItemUpdate((CFDictionaryRef)existsQueryDictionary, (CFDictionaryRef)attributeDict);
            NSAssert1(res == errSecSuccess, @"SecItemUpdated returned %ld!", (long)res);
        }
        else
        {
            res = SecItemDelete((CFDictionaryRef)existsQueryDictionary);
            NSAssert1(res == errSecSuccess, @"SecItemDelete returned %ld!", (long)res);
        }
    }
    else
    {
        NSAssert1(NO, @"Received %ld from SecItemCopyMatching!", (long)res);
    }
    
    return YES;
}

+ (NSData *)dataForKey:(NSString *)key
{
    NSMutableDictionary *existsQueryDictionary = [NSMutableDictionary dictionary];
    
    existsQueryDictionary[(id)kSecClass] = (id)kSecClassGenericPassword;
    
    // Add the keys to the search dict
    existsQueryDictionary[(id)kSecAttrService] = @"service";
    existsQueryDictionary[(id)kSecAttrAccount] = key;
    
    // We want the data back
    NSData *data = nil;
    
    existsQueryDictionary[(id)kSecReturnData] = (id)kCFBooleanTrue;
    
    OSStatus res = SecItemCopyMatching((CFDictionaryRef)existsQueryDictionary, (CFTypeRef *)&data);
    [data autorelease];
    
    if (res != errSecSuccess) {
        NSAssert1(res == errSecItemNotFound, @"SecItemCopyMatching returned %ld!", (long)res);
    }
    
    return data;
}

@end
