//
//  SaveImageLocalOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/24/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SCOperation.h"

@interface SaveImageLocalOperation : SCOperation

- (instancetype)initWithPostId:(NSNumber *)postId withImage:(NSData *)imageData;
@property (nonatomic, strong) NSNumber *postId;
@property (nonatomic, strong) NSData *imageData;

@end
