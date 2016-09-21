//
//  ProfileViewController.m
//  pro
//
//  Created by Shashank Patel on 12/09/16.
//  Copyright © 2016 iOS. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+Teamwork.h"
#import "ActivityCell.h"
#import "ProfileHeaderView.h"
#import "AppDelegate.h"
#import "Activity.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kHeaderHeight           300
#define kInterSectionMargin     10
#define kCellPerRow             1
#define kRowLogout              self.activities.count


@interface HomeViewController (){
    CGFloat             cellLength, cellPadding;
    BackgroundView      *bkView;
}

@property (nonatomic, strong)   IBOutlet    UICollectionView    *collectionView;
@property (nonatomic, strong)               NSArray             *activities;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self calculateCellSize];
    [self initializeCollectionView];
    [self loadActivities];
}

- (void)loadActivities{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Activity fetchActivitiesInBackgroundWithBlock:^(NSArray<Activity *> * _Nullable activities, NSError * _Nullable error) {
        self.activities = activities;
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)calculateCellSize{
    int possiblePadding = kCellPerRow == 2 ? 20 : 5;
    CGFloat possibleLength = 0.5;
    while (round(possibleLength) != possibleLength) {
        possiblePadding++;
        possibleLength = (VIEW_WIDTH - (possiblePadding * (kCellPerRow + 1))) / kCellPerRow;
        continue;
    }
    cellLength = possibleLength - possiblePadding;
    cellPadding = possiblePadding;
}

- (void)initializeCollectionView{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    bkView = [[BackgroundView alloc] initWithFrame:self.view.bounds];
    [self.collectionView insertSubview:bkView atIndex:0];
    
    UIView *upperView = [[UIView alloc] initWithFrame:CGRectMake(0, -VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT)];
    upperView.backgroundColor = [UIColor teamwork_DarkBlue];
    [self.collectionView insertSubview:upperView atIndex:0];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView setBounces:YES];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(loadActivities) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.activities.count + 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        bkView.amplitudeFactor = -scrollView.contentOffset.y + 10;
        [bkView setNeedsDisplay];
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == kRowLogout) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
    }
    
    ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell" forIndexPath:indexPath];
    [cell setActivity:self.activities[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:  (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kRowLogout) {
        return CGSizeMake(VIEW_WIDTH - cellPadding * 2, 60);
    }else{
        Activity *anActivity = self.activities[indexPath.row];
        return CGSizeMake(cellLength + cellPadding, [anActivity cellHeightForWidth:VIEW_WIDTH]);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(cellPadding, cellPadding, cellPadding, cellPadding);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return cellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return cellPadding;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ProfileHeaderView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileHeader" forIndexPath:indexPath];
        header.user = self.user;
        reusableview = header;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == kRowLogout){
        [User logOut];
        [AppDelegate setController];
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
