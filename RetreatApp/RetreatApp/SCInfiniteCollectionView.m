//
//  SCInfiniteCollectionView.m
//  CharterTV
//
//  Created by Cameron Mallory on 4/3/13.
//  Copyright (c) 2013 Slalom Consulting. All rights reserved.
//

#import "SCInfiniteCollectionView.h"

@implementation SCInfiniteCollectionView

- (void)resetContentOffsetIfNeeded
{
    if (self.infinityEnabled)
    {
        NSInteger totalVisibleCells = self.visibleCells.count;
        if (totalVisibleCells < self.minCellsForScroll)
        {
            return; // We don't have enough content to generate scroll
        }
        CGPoint contentOffset = self.contentOffset;
        
        // Check the start condition
        if (contentOffset.x <= (self.zoomItemSizeOffset * 3))
        {
            contentOffset.x = self.contentSize.width / 3.f + (self.zoomItemSizeOffset * 2);
        }
        // Check the end condition
        else if (contentOffset.x >= (self.contentSize.width - self.bounds.size.width - (self.zoomItemSizeOffset * 3)))
        {
            contentOffset.x = self.contentSize.width / 3.f - self.bounds.size.width - self.zoomItemSizeOffset;
        }

        [self setContentOffset:contentOffset];
    }
}

@end
