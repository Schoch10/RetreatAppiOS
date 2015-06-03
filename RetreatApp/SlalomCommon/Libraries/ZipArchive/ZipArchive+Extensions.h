//
//  ZipArchive+Extensions.h
//  SlalomCommon
//
//  Created by Jon Allegre on 2/21/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import "ZipArchive.h"

@interface ZipArchive(Extensions)

+(NSString *)unPackedZipDirectory:(NSString*)zipFilename;
-(BOOL)unPackZip:(NSString*)zipFilename withPassword:(NSString*)password;

@end
