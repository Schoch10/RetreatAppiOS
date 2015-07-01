//
//  ZipArchive+Extensions.m
//  SlalomCommon
//
//  Created by Jon Allegre on 2/21/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "ZipArchive+Extensions.h"
#import "SCFileUtil.h"

@implementation ZipArchive(Extensions)

+(NSString *)unPackedZipDirectory:(NSString*)zipFilename
{
    NSString *zipFolderName = [[zipFilename stringByDeletingPathExtension] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[SCFileUtil documentsDirectory] stringByAppendingPathComponent:zipFolderName];
}

-(BOOL)unPackZip:(NSString*)zipFilename withPassword:(NSString*)password
{
    BOOL ret = NO;
    NSString *zipFilePath = [[SCFileUtil documentsDirectory] stringByAppendingPathComponent:zipFilename];
    NSString *unZipPath = [ZipArchive unPackedZipDirectory:zipFilename];
    
	ZipArchive *za = [[ZipArchive alloc] init];
	if( password && password.length > 0 )
	{
		if ([za UnzipOpenFile:zipFilePath Password:password])
		{
            ret = [za UnzipFileTo:[SCFileUtil documentsDirectory] overWrite:YES];
			if (NO == ret)
            {
                SCLogMessage(kLogLevelError, "Error unzipping file %@ with password '%@' to directory %@", zipFilePath, password, unZipPath);
            }; 
            [za UnzipCloseFile];
		}
	}
	else
	{
		if ([za UnzipOpenFile:zipFilePath])
		{
            SCLogMessage(kLogLevelError, "Unzipping file to the directory: %@", unZipPath);
            ret = [za UnzipFileTo:[SCFileUtil documentsDirectory] overWrite:YES];
			if (NO == ret)
            {
                SCLogMessage(kLogLevelError, "Error unzipping file %@ to directory %@", zipFilePath, unZipPath);
            };
            [za UnzipCloseFile];
		}
	}

    return ret;
}

@end
