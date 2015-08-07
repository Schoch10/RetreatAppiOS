//
//  GetSectionsOperation.h
//  mindtap
//
//  Created by Rod Smith on 2014/10/14.
//  Copyright (c) 2014 Slalom, LLC. All rights reserved.
//

#import "RetreatAppServiceConnectionOperation.h"

@protocol GetSectionsOperationDelegate <NSObject>

- (void)getSectionsOperationDidGetSectionIds:(NSArray*)sectionIds fromCache:(BOOL)fromCache finished:(BOOL)finished;
- (void)getSectionsOperationDidFailWithError:(NSError *)error;

@end

@interface GetSectionsOperation : RetreatAppServiceConnectionOperation

@property (nonatomic, weak) NSObject<GetSectionsOperationDelegate> *getSectionsOperationDelegate;

-(instancetype)initForUserId:(NSNumber*)userId;

@end
