//
//  XYSearchViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/13.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSearchViewController.h"
#import "XYEmptyView.h"
#import "UIView+AutoLayout.h"
#import "XYDealTool.h"
#import "XYSearchDealParam.h"
#import "XYSearchDealResult.h"
#import "XYCity.h"
#import "MBProgressHUD+CZ.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+Extension.h"

@interface XYSearchViewController ()<UISearchBarDelegate>
/**
 *  最后一个请求参数
 */
@property (nonatomic, strong) XYSearchDealParam *lastParam;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;
/**
 *  总的团购数
 */
@property (nonatomic, assign) int totalCount;
/**
 *  返回item
 */
@property (nonatomic, strong) UIBarButtonItem *backItem;

@end

@implementation XYSearchViewController
#pragma mark - 懒加载
- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(backItemClick)];
    }
    return _backItem;
}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XYGlobalBG;
    self.emptyView.image = [UIImage imageNamed:@"icon_deals_empty"];
    //设置导航栏搜索框
    [self setupNav];
    //设置刷新
    [self setupRrfresh];
    

}
//设置刷新
- (void)setupRrfresh{
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeal)];
}

//设置导航栏搜索框
- (void)setupNav{
    //左边的导航栏按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    UIView *searchBGView = [[UIView alloc] init];
    searchBGView.size = CGSizeMake(300, 35);
    self.navigationItem.titleView = searchBGView;
    
    self.searchBar = [[UISearchBar alloc] init];
    [searchBGView addSubview:self.searchBar];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    [self.searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.searchBar.delegate = self;
}

#pragma mark - 刷新数据
- (void)loadMoreDeal{
    self.searchBar.userInteractionEnabled = NO;
    //发送请求
    XYSearchDealParam *param = [[XYSearchDealParam alloc] init];
    param.city = self.selectedCity.name;
    param.keyword = self.searchBar.text;
    param.page = @([self.lastParam.page intValue] + 1);
    
    [XYDealTool searchDealWithParam:param success:^(XYSearchDealResult *result) {
        //请求过期，返回
        if (param != _lastParam) { return;}
        
        if (result.deals.count > 0) {//取得数据
            [self.deals addObjectsFromArray:result.deals];
            [self.collectionView reloadData];
        }
        [self.collectionView footerEndRefreshing];
        self.searchBar.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        //请求过期，返回
        if (param != _lastParam) { return;}
        [self.collectionView footerEndRefreshing];
        self.searchBar.userInteractionEnabled = YES;
    }];

    
    //最后一个请求参数赋值
    self.lastParam = param;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
    [MBProgressHUD showMessage:@"正在搜索..." toView:self.navigationController.view];
    //发送请求
    XYSearchDealParam *param = [[XYSearchDealParam alloc] init];
    param.city = self.selectedCity.name;
    param.keyword = searchBar.text;
    param.page = @(1);
    
    [XYDealTool searchDealWithParam:param success:^(XYSearchDealResult *result) {
        self.totalCount = result.total_count;
        if (result.deals.count > 0) {//取得数据
            [self.deals removeAllObjects];
            [self.deals addObjectsFromArray:result.deals];
            [self.collectionView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view];
        }else{
            [MBProgressHUD hideHUDForView:self.navigationController.view];
            [MBProgressHUD showError:@"没有你想要的团购" toView:self.navigationController.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showError:@"没有你想要的团购" toView:self.navigationController.view];
    }];
    
    //最后一个请求参数赋值
    self.lastParam = param;
    
}
#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //是否允许上拉刷新
    self.collectionView.footerHidden = self.deals.count == self.totalCount;
    
    return [super collectionView:collectionView numberOfItemsInSection:section];
}

#pragma mark - 处理导航栏按钮的点击事件
//返回
- (void)backItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
