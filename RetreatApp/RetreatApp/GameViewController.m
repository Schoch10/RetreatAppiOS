
//
//  GameViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "GameViewController.h"
#import "GameCollectionViewCell.h"
#import "CoreDataManager.h"
#import "Game.h"
#import "Game+Extensions.h"
#import "GameInstructionsModalViewController.h"
#import "SettingsManager.h"

@interface GameViewController () <GameInstructionsModalDelegate>
@property (strong, nonatomic) NSArray *questionsArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) int answersCount;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Find Someone Who";
    [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"QuestionCell"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.headerReferenceSize = CGSizeZero;
    flowlayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 0);
    self.collectionView.collectionViewLayout = flowlayout;
    self.collectionView.scrollsToTop = YES;
    [self checkAnswers];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self retrieveData];
    SettingsManager *sharedSettings = [SettingsManager sharedManager];
    if (!sharedSettings.userReadGameInstructions) {
        [self showGameInstructions];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAnswerUpdatedNotification:)
                                                 name:@"AnswerUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollToTopNoficationReceived:)
                                                 name:@"ScrollForKeyboardNotification"
                                               object:nil];
}

- (void)retrieveData {
    NSManagedObjectContext *managedObjectContext = [CoreDataManager sharedManager].mainThreadManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Game"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"gameId" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    self.questionsArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)showGameInstructions {
    GameInstructionsModalViewController *gameInstructionsModalView = [[GameInstructionsModalViewController alloc]initWithNibName:@"GameInstructionsModalViewController" bundle:nil];
    gameInstructionsModalView.modalPresentationStyle = UIModalPresentationFullScreen;
    gameInstructionsModalView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    gameInstructionsModalView.delegate = self;
    [self presentViewController:gameInstructionsModalView animated:YES completion:nil];
}

#pragma mark Game Instructions Delegate

- (void)dismissGameInstructionsModalViewController {
    [self dismissViewControllerAnimated:YES completion:^(void){
        SettingsManager *sharedManager = [SettingsManager sharedManager];
        sharedManager.userReadGameInstructions = YES;
    }];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.questionsArray.count;

}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (void)scrollToTopNoficationReceived:(NSNotification *)notification  {
    NSIndexPath *indexForScroll = [notification.userInfo objectForKey:@"indexPath"];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexForScroll];
    [self.collectionView setContentOffset:CGPointMake(0, cell.frame.origin.y) animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 1, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"QuestionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCollectionViewCell *gameCell = (GameCollectionViewCell *)cell;
    Game *game = [self.questionsArray objectAtIndex:indexPath.item];
    gameCell.questionString = game.question;
    gameCell.cardId = indexPath.item;
    gameCell.cardIndex = indexPath;
    gameCell.gameAnswerTextField.text = game.answer;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4
    ; // This is the minimum inter item spacing, can be more
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)checkAnswers {
    CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *managedObjectContext = coreDataManager.mainThreadManagedObjectContext;
    NSFetchRequest *fetchAnswers = [[NSFetchRequest alloc]initWithEntityName:@"Game"];
    NSPredicate *answerPredicate = [NSPredicate predicateWithFormat:@"answer != nil AND answer != ''"];
    fetchAnswers.predicate = answerPredicate;
    NSError *error;
    NSArray *answerArray = [managedObjectContext executeFetchRequest:fetchAnswers error:&error];
    //createStatusBar
    if (answerArray.count == 12) {
        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    }
}

- (void)receiveAnswerUpdatedNotification:(NSNotification *)notification {
    [self checkAnswers];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 150);
}


@end
