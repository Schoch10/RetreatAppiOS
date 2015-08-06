//
//  TrendingViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendingModalViewController.h"
#import "CheckinViewController.h"
#import "PostModalViewController.h"
#import "SCInfiniteCollectionView.h"

@interface TrendingCarouselViewController : UIViewController <TrendingModalViewDelegate, CheckinModalViewControllerDelegate, PostModalViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) Class sendingClass;

@property (weak, nonatomic) IBOutlet SCInfiniteCollectionView *collectionView;
@property (assign, nonatomic)  BOOL hasLoadedData;

- (id)objectAtInfiniteIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)nonInfiniteItemPositionForIndexPath:(NSIndexPath *)indexPath;
- (void)reloadCollectionView;

@end
