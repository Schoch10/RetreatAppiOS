//
//  DownloadImageOperation.h
//  RetreatApp
//
//  Created by Quinn MacKenzie on 8/25/15.
//  Copyright (c) 2013 Slalom Consulting. All rights reserved.
//

#import "SCNetworkOperation.h"

#define kImagePathKey @"kImagePathKey"

@class DownloadImageOperation;

@protocol DownloadImageOperationDelegate <NSObject>

- (void)downloadImageOperationDidSucceedWithUserInfo:(NSDictionary *)userInfo;
- (void)setDownloadImageOperation:(DownloadImageOperation *)value;

@optional
- (void)downloadImageOperationDidFailWithError:(NSError *)error;

@end

@interface DownloadImageOperation : SCNetworkOperation

@property (strong, nonatomic) NSString *imageUri;
@property (strong, nonatomic) NSString *filename;

+ (id)queueOperation:(DownloadImageOperation *)operation;
+ (id)queueWithDelegate:(id<DownloadImageOperationDelegate>)delegate imageUri:(NSString *)imageUri;
+ (id)queueWithDelegate:(id<DownloadImageOperationDelegate>)delegate imageUri:(NSString *)imageUri filename:(NSString *)filename;

+ (void)asyncImageUri:(NSString *)uri delegate:(id<DownloadImageOperationDelegate>)delegate completion:(void (^)(UIImage *image))completion;
+ (void)asyncImageUri:(NSString *)uri filename:(NSString *)filename delegate:(id<DownloadImageOperationDelegate>)delegate completion:(void (^)(UIImage *image))completion;

@end
