//
//  PollParticipantLocationsOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/7/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"

@protocol PollParticipantLocationServiceDelegate <NSObject>

- (void)pollParticipantLocationDidSucceed;
- (void)pollParticipantLocationDidFailWithError:(NSError *)error;

@end


@interface PollParticipantLocationsOperation : RetreatAppServiceConnectionOperation <RetreatServiceTaskDelegate>

- (id)initPollParticipantOperation;

@property (nonatomic, weak) id<PollParticipantLocationServiceDelegate> pollParticipantDelegate;

@end
