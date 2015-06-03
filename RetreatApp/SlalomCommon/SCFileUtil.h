//
//  SCFileUtil.h
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFileUtil : NSObject{}

+ (NSString *)documentsDirectory;
+ (NSString *)documentPath:(NSString*)filename;
+ (NSURL *)documentUrlForFile:(NSString*)filename;
+ (BOOL)addSkipBackupAttributeToDocumentFile:(NSString *)filename;

+ (NSString *)cacheDirectory;
+ (NSString *)cachePath:(NSString *)filename;
+ (NSURL*)cacheUrlForFile:(NSString*)filename;
+ (BOOL)addSkipBackupAttributeToCacheFile:(NSString *)filename;
+ (BOOL)deleteCacheFile:(NSString*)filename;

+ (NSString *)resourceDirectory;
+ (NSString *)resourcePath: (NSString*)filename;
+ (NSURL*)resourceUrlForFile:(NSString*)filename;
+ (BOOL)addSkipBackupAttributeToResourceFile:(NSString *)filename;

+ (NSString *) tempDirectory;
+ (NSString *)temporaryFilePath;
+ (NSString *)tempPath: (NSString*)filename;
+ (NSURL*)tempUrlForFile:(NSString*)filename;
+ (BOOL)addSkipBackupAttributeToTempFile:(NSString *)filename;



+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (BOOL)createDocument:(NSString*)documentFile withContentsOfString:(NSString*)string updateDate:(NSDate*)date;
+ (BOOL)documentExists:(NSString*)documentName;

+ (BOOL)deleteDocument:(NSString*)documentName;
@end
