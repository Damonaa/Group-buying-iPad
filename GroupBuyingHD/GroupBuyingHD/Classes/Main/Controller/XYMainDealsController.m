//
//  XYMainDealsController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMainDealsController.h"
#import "XYDealCell.h"
#import "XYEmptyView.h"
#import "XYDetailViewController.h"

@interface XYMainDealsController ()<XYDealCellDelegate>

@end

@implementation XYMainDealsController

- (XYEmptyView *)emptyView{
    if (!_emptyView) {
        XYEmptyView *empty = [XYEmptyView emptyView];
        
        [self.view insertSubview:empty belowSubview:self.collectionView];
        _emptyView = empty;
    }
    return _emptyView;
}

- (NSMutableArray *)deals{
    if (!_deals) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}


#pragma mark - 初始化
- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(305, 305);
    
    return [super initWithCollectionViewLayout:layout];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置collection参数
    self.view.backgroundColor = XYGlobalBG;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XYDealCell" bundle:nil] forCellWithReuseIdentifier:@"dealCell"];
    
    id<UIViewControllerTransitionCoordinator> coordinator;
    [self viewWillTransitionToSize:self.view.size withTransitionCoordinator:coordinator];
}



#pragma mark - 屏幕旋转的layout适配
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

//iOS9之前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //即将旋转，宽是高
    [self setupLayoutWithWidth:self.view.height interfaceOrientation:toInterfaceOrientation];
}
//iOS9
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    XYLog(@"%@ -- %@", NSStringFromCGSize(size), coordinator);
    UIDeviceOrientation orien = [UIDevice currentDevice].orientation;
    int column = 0;
    if (orien == 1 || orien == 2) {//竖屏
        column = 2;
    }else{
        column = 3;
    }
    
    [self setupLayoutWithWidth:size.width column:column];
}

/**
 *  设置cell的布局， iOS9
 *
 *  @param width                屏幕的宽
 *  @param column               列数
 */
- (void)setupLayoutWithWidth:(CGFloat)width column:(int)column{

    CGFloat lineSapcing = 15;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat interitemSpacing = (width - layout.itemSize.width * column) / (column + 1);
    //每一行的最小间距
    layout.minimumLineSpacing = lineSapcing;
    //每一列的最小间距
//    layout.minimumInteritemSpacing = interitemSpacing;
    
    layout.sectionInset = UIEdgeInsetsMake(lineSapcing, interitemSpacing, lineSapcing, interitemSpacing);
}

/**
 *  设置cell的布局 iOS9以前
 *
 *  @param width                屏幕的宽
 *  @param interfaceOrientation 屏幕的方向
 */
- (void)setupLayoutWithWidth:(CGFloat)width interfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    int column = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? 2 : 3;
    CGFloat lineSapcing = 25;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat interitemSpacing = (width - layout.itemSize.width * column) / (column + 1);
    //每一行的最小间距
    layout.minimumLineSpacing = lineSapcing;
    //每一列的最小间距
//    layout.minimumInteritemSpacing = interitemSpacing;
    
    layout.sectionInset = UIEdgeInsetsMake(lineSapcing, interitemSpacing, lineSapcing, interitemSpacing);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    self.emptyView.hidden = (self.deals.count > 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XYDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XYDetailViewController *detailVC = [[XYDetailViewController alloc] init];
    detailVC.deal = self.deals[indexPath.item];
    [self presentViewController:detailVC animated:YES completion:nil];
}


@end
