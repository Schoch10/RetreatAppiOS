//
//  DoPostForLocation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/10/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"

@protocol DoPostForLocationDelegate <NSObject>

- (void)doPostForLocationDidSucceed;
- (void)doPostForLocationDidFailWithError:(NSError *)error;

@end

@interface DoPostForLocation : RetreatAppServiceConnectionOperation <RetreatServiceTaskDelegate>

- (id)initDoPostForUser:(NSNumber *)userId forLocation:(NSNumber *)locationId withText:(NSString *)postText;

@property (nonatomic, weak) id<DoPostForLocationDelegate> doPostForLocationDelegate;

@end
