//
//  SCFileUtil.m
//  SlalomCommon
//
//  Created by Greg Martin on 1/2/11.
//  Copyright 2011 Slalom, LLC. All rights reserved.
//

#import "SCFileUtil.h"
#include <sys/xattr.h>

@implementation SCFileUtil


#pragma  mark - Documents Methods

+ (NSString *)documentsDirectory
{
    static NSString *DocumentsDirectory = nil;
    
    if(!DocumentsDirectory)
    {
        DocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    
    return DocumentsDirectory;
}

+ (NSString *)documentPath:(NSString*)filename {
	return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

+ (NSURL*)documentUrlForFile:(NSString*)filename {
	NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:filename];
	return [NSURL fileURLWithPath:path];
}

+ (BOOL)addSkipBackupAttributeToDocumentFile:(NSString *)fname
{
    return [self addSkipBackupAttributeToItemAtURL:[self documentUrlForFile:fname] ];
}

#pragma mark - Cache Methods
+ (NSString *)cacheDirectory
{
    static NSString *CacheDirectory = nil;
    
    if(!CacheDirectory)
    {
        CacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    
    return CacheDirectory;
}

+ (NSString *)cachePath:(NSString *)filename
{
    return [[self cacheDirectory] stringByAppendingPathComponent:filename];
}


+ (NSURL*)cacheUrlForFile:(NSString*)filename {
    NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:filename];
    return [NSURL fileURLWithPath:path];
}


+ (BOOL)addSkipBackupAttributeToCacheFile:(NSString *)fname
{
    return [self addSkipBackupAttributeToItemAtURL:[self cacheUrlForFile:fname] ];
}

+ (BOOL)deleteCacheFile:(NSString*)filename
{
    if([NSString isNullOrEmpty:filename])
    {
        SCLogMessage(kLogLevelDebug, @"filename was nil or empty: '%@'", filename);
        return NO;
    }
    
    NSError *error;
    BOOL isDir;
    NSString *cacheFilePath = [SCFileUtil cachePath:filename];
    if([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath isDirectory:&isDir])
    {
        //Only delete FILES
        if(!isDir)
        {
            SCLogMessage(kLogLevelDebug, @"deleteCacheFile: %@", cacheFilePath);
            NSURL *fileUrl = [NSURL fileURLWithPath:cacheFilePath];
            if(![[NSFileManager defaultManager] removeItemAtURL:fileUrl error:&error])
            {
                SCLogMessage(kLogLevelInfo, @"There was an error deleting the file %@ from the disk: %@", cacheFilePath, [error localizedDescription]);
                return NO;
            }
        }
    }
    
    return YES;
}


#pragma mark - Temp Methods

+ (NSString *) tempDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString *)temporaryFilePath
{
    NSString *tempFileTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:@"sctempfile.XXXXXX"];
    const char *tempFileTemplateCString = [tempFileTemplate fileSystemRepresentation];
    char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
    strcpy(tempFileNameCString, tempFileTemplateCString);
    int fileDescriptor = mkstemp(tempFileNameCString);
    
    if (fileDescriptor == -1)
    {
        // handle file creation failure
        free(tempFileNameCString);
        
        return nil;
    }
    
    // This is the file name if you need to access the file by name, otherwise you can remove
    // this line.
    NSString *tempFileName = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:tempFileNameCString length:strlen(tempFileNameCString)];
    
    free(tempFileNameCString);
    
    return tempFileName;
}

+ (NSString *)tempPath:(NSString *)filename
{
    return [[self tempDirectory] stringByAppendingPathComponent:filename];
}


+ (NSURL*)tempUrlForFile:(NSString*)filename {
	NSString *path = [[self tempDirectory] stringByAppendingPathComponent:filename];
	return [NSURL fileURLWithPath:path];
}

+ (BOOL)addSkipBackupAttributeToTempFile:(NSString *)fname
{
    return [self addSkipBackupAttributeToItemAtURL:[self tempUrlForFile:fname] ];
}


#pragma mark - Resource Methods
+ (NSString *)resourceDirectory
{
	return [[NSBundle mainBundle] resourcePath];
}


+ (NSString *)resourcePath: (NSString*)filename {
    return [[self resourceDirectory] stringByAppendingPathComponent:filename];
}

+ (NSURL*)resourceUrlForFile:(NSString*)filename {
	return [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
}

+ (BOOL)addSkipBackupAttributeToResourceFile:(NSString *)fname
{
    return [self addSkipBackupAttributeToItemAtURL:[self resourceUrlForFile:fname] ];
}



#pragma mark - Other

+ (BOOL)createDocument:(NSString*)documentFile withContentsOfString:(NSString*)string updateDate:(NSDate*)date {
	NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:documentFile];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *attributes = @{NSFileModificationDate: date};
	return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:attributes];
}


+ (BOOL)documentExists:(NSString*)documentName {
	return [[NSFileManager defaultManager] fileExistsAtPath:[self documentPath:documentName]];
}

+ (BOOL)deleteDocument:(NSString*)documentName
{
    if([NSString isNullOrEmpty:documentName])
    {
        SCLogMessage(kLogLevelDebug, @"documentName was nil or empty: '%@'", documentName);
        return NO;
    }
    
    NSError *error;
    BOOL isDir;
    NSString *documentPath = [SCFileUtil documentPath:documentName];
    if([[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir])
    {
        //Only delete FILES
        if(!isDir)
        {
            SCLogMessage(kLogLevelDebug, @"deleteDocument File: %@", documentPath);
            NSURL *fileUrl = [NSURL fileURLWithPath:documentPath];
            if(![[NSFileManager defaultManager] removeItemAtURL:fileUrl error:&error])
            {
                SCLogMessage(kLogLevelError, @"There was an error deleting the file %@ from the disk: %@", documentPath, [error localizedDescription]);
                return NO;
            }
        }
    }
    
    return YES;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    /*if (&NSURLIsExcludedFromBackupKey == nil)
    {
        // iOS 5.0.1 and lower
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else
    { */
        //iOS 5.1 and higher
        // First try and remove the extended attribute if it is present
        long result = getxattr(filePath, attrName, NULL, sizeof(long), 0, 0);
        if (result != -1) {
            // The attribute exists, we need to remove it
            int removeResult = removexattr(filePath, attrName, 0);
            if (removeResult == 0) {
                SCLogMessage(kLogLevelDebug, @"Removed extended attribute on file %@", URL);
            }
        }
        
        // Set the new key
        return [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    //}
}

@end
