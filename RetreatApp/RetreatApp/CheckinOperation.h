//
//  CheckinOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/7/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"

@protocol CheckinOperationDelegate <NSObject>

- (void)checkinOperationDidSucceed;
- (void)checkinOperationDidFailWithError:(NSError *)error;

@end

@interface CheckinOperation : RetreatAppServiceConnectionOperation <RetreatServiceTaskDelegate>

- (id)initCheckinOperationWithLocationForUser:(NSNumber *)userId withLocation:(NSNumber *)locationId;

@property (nonatomic, weak) id<CheckinOperationDelegate> checkinOperationDelegate;
@property (nonatomic, strong) NSNumber *locationId;

@end
