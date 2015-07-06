//
//  SCInfiniteCollectionView.h
//  CharterTV
//
//  Created by Cameron Mallory on 4/3/13.
//  Copyright (c) 2013 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInfiniteScrollMultiplier 9

@interface SCInfiniteCollectionView : UICollectionView

@property (assign, nonatomic) BOOL infinityEnabled;
@property (assign, nonatomic) NSInteger minCellsForScroll;
@property (assign, nonatomic) CGFloat zoomItemSizeOffset;

- (void)resetContentOffsetIfNeeded;

@end
