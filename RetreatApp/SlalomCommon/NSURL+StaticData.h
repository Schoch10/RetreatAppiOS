//
//  NSURL+StaticData.h
//  SlalomCommon
//
//  Created by James Irvine on 1/30/12.
//  Copyright (c) 2012 Slalom, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (StaticData)
-(BOOL)isStaticDataURL;
-(NSURL*)URLForStaticData;
@end
