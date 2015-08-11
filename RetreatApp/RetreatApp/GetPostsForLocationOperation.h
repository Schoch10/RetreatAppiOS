//
//  GetPostsForLocationOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/10/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"

@protocol GetPostsForLocationDelegate <NSObject>

- (void)getPostsForLocationDidSucceed;
- (void)getPostsForLocationDidFailWithError:(NSError *)error;

@end

@interface GetPostsForLocationOperation : RetreatAppServiceConnectionOperation <RetreatServiceTaskDelegate>

- (id)initGetPostsOperationForLocationId:(NSNumber *)locationId;

@property (nonatomic, weak) id<GetPostsForLocationDelegate> getPostsForLocationDelegate;

@end
