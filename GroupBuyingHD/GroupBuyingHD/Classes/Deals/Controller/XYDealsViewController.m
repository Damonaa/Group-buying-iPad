//
//  XYDealsViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/1.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDealsViewController.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "UIBarButtonItem+Extension.h"
#import "XYDealsTopMenu.h"
#import "XYCategoryViewController.h"
#import "XYRegionViewController.h"
#import "XYSortViewController.h"
#import "XYCitiesViewController.h"
#import "XYSort.h"
#import "XYCategory.h"
#import "XYCity.h"
#import "XYRegion.h"
#import "XYDealTool.h"
#import "XYSearchDealParam.h"
#import "XYSearchDealResult.h"
#import "MBProgressHUD+CZ.h"
#import "MJRefresh.h"
#import "XYHistoryDealsController.h"
#import "XYMainNavigationController.h"
#import "XYEmptyView.h"
#import "XYCollectDealsController.h"
#import "XYSearchViewController.h"
#import "XYMapViewController.h"

@interface XYDealsViewController ()<AwesomeMenuDelegate>
/**
 *  动态的用户菜单
 */
@property (nonatomic, weak) AwesomeMenu *menu;

/******顶部菜单***/
/**
 *  分类菜单
 */
@property (nonatomic, strong) XYDealsTopMenu *categoryMenu;
/**
 *  区域菜单
 */
@property (nonatomic, strong) XYDealsTopMenu *regionMenu;
/**
 *  排序菜单
 */
@property (nonatomic, strong) XYDealsTopMenu *sortMenu;

/****popover控制器****/
@property (nonatomic, strong) UIPopoverController *categoryPopover;
@property (nonatomic, strong) UIPopoverController *regionPopover;
@property (nonatomic, strong) UIPopoverController *sortPopover;

/** 选中的状态 */
@property (nonatomic, strong) XYCity *selectedCity;
/** 当前选中的区域 */
@property (strong, nonatomic) XYRegion *selectedRegion;
/** 当前选中的子区域名称 */
@property (copy, nonatomic) NSString *selectedSubRegionName;
/** 当前选中的排序 */
@property (strong, nonatomic) XYSort *selectedSort;
/** 当前选中的分类 */
@property (strong, nonatomic) XYCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;
/**
 *  上一个请求参数
 */
@property (nonatomic, strong) XYSearchDealParam *lastParam;
/**
 *  存储请求结果的总数
 */
@property (nonatomic, assign) int totalNumber;

@end

@implementation XYDealsViewController


#pragma mark - 懒加载

- (UIPopoverController *)categoryPopover{
    if (!_categoryPopover) {
        
        XYCategoryViewController *cvc = [[XYCategoryViewController alloc] init];
        _categoryPopover = [[UIPopoverController alloc] initWithContentViewController:cvc];
    }
    return _categoryPopover;
}
- (UIPopoverController *)regionPopover{
    if (!_regionPopover) {
        XYRegionViewController *rvc = [[XYRegionViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        //响应block
        rvc.changeCityBlock = ^{
            [weakSelf.regionPopover dismissPopoverAnimated:YES];
            
            //弹出城市列表
            XYCitiesViewController *cvc = [[XYCitiesViewController alloc] init];
            cvc.modalPresentationStyle = UIModalPresentationFormSheet;
            [weakSelf presentViewController:cvc animated:YES completion:nil];
        };
        _regionPopover = [[UIPopoverController alloc] initWithContentViewController:rvc];
    }
    return _regionPopover;
}
- (UIPopoverController *)sortPopover{
    if (!_sortPopover) {
        XYSortViewController *svc = [[XYSortViewController alloc] init];
        _sortPopover = [[UIPopoverController alloc] initWithContentViewController:svc];
    }
    return _sortPopover;
}

#pragma mark - 声明周期


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //用户上次的点击操作的获取
    self.selectedSort = [[XYMetaDataTool shareMateData] selectedSort];
    self.selectedCategory = [[XYMetaDataTool shareMateData] selectedCategory];
    self.selectedCity = [[XYMetaDataTool shareMateData] selectedCity];
    
    XYRegionViewController *regionVC = (XYRegionViewController *)self.regionPopover.contentViewController;
    regionVC.selectedRegions = self.selectedCity.regions;
    self.selectedRegion = [[XYMetaDataTool shareMateData] selectedRegion];
    //没有数据的时候，展示的提示图
    self.emptyView.image = [UIImage imageNamed:@"icon_deals_empty"];
    
    //设置collection参数
    [self setupCollectionView];
    //用户菜单
    [self setupAwesomeMenu];
    //导航栏控件
    [self setupNavLeft];
    [self setupNavRight];
    
    //监听通知
//    [self setupNotifiaction];
    
    [self.collectionView headerBeginRefreshing];
}
//设置collection参数
- (void)setupCollectionView{
    //加载数据
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}
#pragma mark - 监听通知
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //排序
    [XYNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:XYSortDidChangeNotification object:nil];
    //城市切换
    [XYNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:XYCityDidChangeNotification object:nil];
    
    //类别切换
    [XYNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:XYCategoryDidChangeNotification object:nil];
    //城市区域切换
    [XYNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:XYRegionDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XYNotificationCenter removeObserver:self];
}
//排序变化
- (void)sortDidChange:(NSNotification *)noti{
    self.selectedSort = noti.userInfo[XYSelectedSort];
    self.sortMenu.subtitleLabel.text = _selectedSort.label;
    //隐藏popover
    [_sortPopover dismissPopoverAnimated:YES];
    //加载数据
//    [self loadNewDeals];
    [self.collectionView headerBeginRefreshing];
    
    //保存用户点击的sort到沙盒
    [[XYMetaDataTool shareMateData] saveSelectedSort:_selectedSort];
}
//城市变化
- (void)cityDidChange:(NSNotification *)noti{
    self.selectedCity = noti.userInfo[XYSelectedCity];
    //设置菜单按钮的文字
    self.regionMenu.titleLabel.text = _selectedCity.name;
    self.regionMenu.subtitleLabel.text = @"全部";
    
    //更换显示区域的数据
    XYRegionViewController *regionVC = (XYRegionViewController *)self.regionPopover.contentViewController;
    regionVC.selectedRegions = _selectedCity.regions;
    //加载数据
    [self.collectionView headerBeginRefreshing];
    
    //保存选中的城市到沙盒
    [[XYMetaDataTool shareMateData] saveSelectedCityName:self.selectedCity.name];
}
//类别变化
- (void)categoryDidChange:(NSNotification *)noti{
    self.selectedCategory = noti.userInfo[XYSelectedCategory];
    self.selectedSubCategoryName = noti.userInfo[XYSelectedSubCategory];
    
    self.categoryMenu.titleLabel.text = _selectedCategory.name;
    self.categoryMenu.subtitleLabel.text = _selectedSubCategoryName;
    self.categoryMenu.imageBtn.image = _selectedCategory.icon;
    self.categoryMenu.imageBtn.highlightedImage = _selectedCategory.highlighted_icon;
    //隐藏popover
    [_categoryPopover dismissPopoverAnimated:YES];
    //加载数据
    [self.collectionView headerBeginRefreshing];
}
//区域变化
- (void)regionDidChange:(NSNotification *)noti{
    self.selectedRegion = noti.userInfo[XYSelectedRegion];
    self.selectedSubRegionName = noti.userInfo[XYSelectedSubRegion];
    
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", _selectedCity.name, _selectedRegion.name];
    self.regionMenu.subtitleLabel.text = _selectedSubRegionName;
    //隐藏popover
    [_regionPopover dismissPopoverAnimated:YES];
    //加载数据
    [self.collectionView headerBeginRefreshing];
    
    //保存选中的region到沙盒
    self.selectedRegion.subregion = self.selectedSubRegionName;
    [[XYMetaDataTool shareMateData] saveSelectedRegion:self.selectedRegion];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.footerHidden = self.deals.count == self.totalNumber;
    return [super collectionView:collectionView numberOfItemsInSection:section];
}
#pragma mark - 加载数据
//请求新数据
- (void)loadNewDeals{
    //请求参数
    XYSearchDealParam *param = [self setupDealParam];
    [XYDealTool searchDealWithParam:param success:^(XYSearchDealResult *result) {
        //请求过期，返回
        if (param != _lastParam) { return;}
        //保存总的团购个数
        self.totalNumber = result.total_count;
        
        [self.deals removeAllObjects];
        [self.deals addObjectsFromArray:result.deals];
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
    } failure:^(NSError *error) {
        //请求过期，返回
        if (param != _lastParam) { return;}
        [MBProgressHUD showError:@"加载失败，请稍后再试" toView:self.navigationController.view];
        [self.collectionView headerEndRefreshing];
    }];
    //保存此次请求
    self.lastParam = param;
}
//请求更多数据
- (void)loadMoreDeals{
    XYSearchDealParam *param = [self setupDealParam];
    param.page = @([_lastParam.page integerValue] + 1);
    [XYDealTool searchDealWithParam:param success:^(XYSearchDealResult *result) {
        //请求过期，返回
        if (param != _lastParam) { return;}
        
        [self.deals addObjectsFromArray:result.deals];
        [self.collectionView reloadData];
        [self.collectionView footerEndRefreshing];
    } failure:^(NSError *error) {
        //请求过期，返回
        if (param != _lastParam) { return;}
        [MBProgressHUD showError:@"加载失败，请稍后再试" toView:self.navigationController.view];
        [self.collectionView footerEndRefreshing];
    }];
    //保存此次请求
    self.lastParam = param;
}
//设置请求参数
- (XYSearchDealParam *)setupDealParam{
//    XYLog(@"%@ %@ %@",  _selectedSubCategoryName, _selectedSubRegionName, _selectedSort.label);
    
    XYSearchDealParam *param = [[XYSearchDealParam alloc] init];
    //城市名
    param.city = self.selectedCity.name;
    //排序
    if (self.selectedSort) {
        param.sort = @(self.selectedSort.value);
    }
    //类别
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"]) {
        if (self.selectedSubCategoryName && ![self.selectedSubCategoryName isEqualToString:@"全部"]) {
            param.category = self.selectedSubCategoryName;
        }else{
            param.category = self.selectedCategory.name;
        }
    }
    //区域
    if (self.selectedRegion && ![self.selectedRegion.name isEqualToString:@"全部"]) {
        if (self.selectedSubRegionName  && ![self.selectedSubRegionName isEqualToString:@"全部"]) {
            param.region = self.selectedSubRegionName;
        }else{
            param.region = self.selectedRegion.name;
        }
    }
    
    param.page = @(1);
    
    return param;
}

#pragma mark - 导航栏
//右边导航栏控件
- (void)setupNavRight{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImageName:@"icon_map" highImageName:@"icon_map_highlighted" target:self action:@selector(mapItemClick)];
    mapItem.customView.width = 40;
    mapItem.customView.height = 27;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImageName:@"icon_search" highImageName:@"icon_search_highlighted" target:self action:@selector(searchItemClcik)];
    searchItem.customView.width = mapItem.customView.width;
    searchItem.customView.height = mapItem.customView.height;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
    
}
//左边导航栏控件
- (void)setupNavLeft{
    //logo
    UIBarButtonItem *logoItem = [UIBarButtonItem itemWithImageName:@"icon_meituan_logo" highImageName:@"icon_meituan_logo" target:nil action:nil];
    logoItem.customView.userInteractionEnabled = NO;
    //分类
    self.categoryMenu = [XYDealsTopMenu dealsTopMenu];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:_categoryMenu];
    _categoryMenu.imageBtn.image = _selectedCategory.icon;
    _categoryMenu.imageBtn.highlightedImage = _selectedCategory.highlighted_icon;
    _categoryMenu.titleLabel.text = _selectedCategory.title;
    _categoryMenu.subtitleLabel.text = _selectedCategory.subcategory;
    [_categoryMenu addTarget:self action:@selector(cartgoryMenuClick)];
    //区域
    self.regionMenu = [XYDealsTopMenu dealsTopMenu];
    _regionMenu.imageBtn.highlightedImage = @"icon_district_highlighted";
    _regionMenu.imageBtn.image = @"icon_district";
    _regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", _selectedCity.name, _selectedRegion.name];
    _regionMenu.subtitleLabel.text = self.selectedRegion.subregion;
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:_regionMenu];
    [_regionMenu addTarget:self action:@selector(regionMenuClick)];
    //排序
    self.sortMenu = [XYDealsTopMenu dealsTopMenu];
    _sortMenu.titleLabel.text = @"排序";
    _sortMenu.subtitleLabel.text = self.selectedSort.label;
    _sortMenu.imageBtn.image = @"icon_sort";
    _sortMenu.imageBtn.highlightedImage = @"icon_sort_highlighted";
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:_sortMenu];
    [_sortMenu addTarget:self action:@selector(sortMenuClick)];
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];
}
//分类菜单点击
- (void)cartgoryMenuClick{
    //设置用户之前的选中cell
    XYCategoryViewController *categoryVC = (XYCategoryViewController *)self.categoryPopover.contentViewController;
    categoryVC.selectedCategory = self.selectedCategory;
    categoryVC.selectedSubcategoryName = self.selectedSubCategoryName;
    
    [self.categoryPopover presentPopoverFromRect:_categoryMenu.bounds inView:_categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
//区域菜单点击
- (void)regionMenuClick{
    //设置用户之前的选中cell
    XYRegionViewController *regionVC = (XYRegionViewController *)self.regionPopover.contentViewController;
    regionVC.selectedRegion = self.selectedRegion;
    regionVC.selectedSubregionName = self.selectedSubRegionName;
    [self.regionPopover presentPopoverFromRect:_regionMenu.bounds inView:_regionMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
//排序菜单点击
- (void)sortMenuClick{
    //设置用户之前的选中cell
    XYSortViewController *sortVC = (XYSortViewController *)self.sortPopover.contentViewController;
    sortVC.selectedSort = self.selectedSort;
    [self.sortPopover presentPopoverFromRect:_sortMenu.bounds inView:_sortMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
//处理地图点击事件
- (void)mapItemClick{
    XYMapViewController *histroyVC = [[XYMapViewController alloc] init];
    XYMainNavigationController *mainNav = [[XYMainNavigationController alloc] initWithRootViewController:histroyVC];
    [self presentViewController:mainNav animated:YES completion:nil];
}
//处理搜索点击事件
- (void)searchItemClcik{
    
    XYSearchViewController *histroyVC = [[XYSearchViewController alloc] init];
    XYMainNavigationController *mainNav = [[XYMainNavigationController alloc] initWithRootViewController:histroyVC];
    histroyVC.selectedCity = self.selectedCity;
    [self presentViewController:mainNav animated:YES completion:nil];
    
}
#pragma mark - 用户菜单
- (void)setupAwesomeMenu{
    //周边的item
    AwesomeMenuItem *mineItem = [self itemWithImageContent:@"icon_pathMenu_mine_normal" highlightedImageContent:@"icon_pathMenu_mine_highlighted"];
    AwesomeMenuItem *collectItem = [self itemWithImageContent:@"icon_pathMenu_collect_normal" highlightedImageContent:@"icon_pathMenu_collect_highlighted"];
    AwesomeMenuItem *scanItem = [self itemWithImageContent:@"icon_pathMenu_scan_normal" highlightedImageContent:@"icon_pathMenu_scan_highlighted"];
    AwesomeMenuItem *moreItem = [self itemWithImageContent:@"icon_pathMenu_more_normal" highlightedImageContent:@"icon_pathMenu_more_highlighted"];
    NSArray *menuItems = @[mineItem, collectItem, scanItem, moreItem];
    //中间的item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"]
                                                       highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"]
                                                           ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:menuItems];
    [self.view addSubview:menu];
    self.menu = menu;
    //菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    menu.rotateAddButton = NO;
    menu.delegate = self;
    menu.alpha = 0.15;
    //约束menu的位置
    CGFloat menuH = 200;
    [menu autoSetDimensionsToSize:CGSizeMake(200, menuH)];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    //开始按钮添加一个背景
    UIImageView *menuBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background"]];
    [menu insertSubview:menuBg atIndex:0];
    //约束
    [menuBg autoSetDimensionsToSize:menuBg.image.size];
    [menuBg autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menuBg autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    menu.startPoint = CGPointMake(menuBg.image.size.width * 0.5, menuH - menuBg.image.size.height * 0.5);
    
}
//创建一个menuItem
- (AwesomeMenuItem *)itemWithImageContent:(NSString *)content highlightedImageContent:(NSString *)highlightedImageContent{
    
    UIImage *image = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    return [[AwesomeMenuItem alloc] initWithImage:image highlightedImage:nil ContentImage:[UIImage imageNamed:content] highlightedContentImage:[UIImage imageNamed:highlightedImageContent]];
}

#pragma mark - AwesomeMenuDelegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    XYLog(@"didSelectIndex - %ld", idx);
    [self awesomeMenuWillAnimateClose:menu];
    
    if (idx == 1) {
        XYCollectDealsController *histroyVC = [[XYCollectDealsController alloc] init];
        XYMainNavigationController *mainNav = [[XYMainNavigationController alloc] initWithRootViewController:histroyVC];
        [self presentViewController:mainNav animated:YES completion:nil];
    }else if (idx == 2) {
        XYHistoryDealsController *histroyVC = [[XYHistoryDealsController alloc] init];
        XYMainNavigationController *mainNav = [[XYMainNavigationController alloc] initWithRootViewController:histroyVC];
        [self presentViewController:mainNav animated:YES completion:nil];
    }
    
}
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    // 显示xx图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    
    [UIView animateWithDuration:0.3 animations:^{
        menu.alpha = 1.0;
    }];
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    // 恢复图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    [UIView animateWithDuration:0.3 animations:^{
        menu.alpha = 0.15;
    }];
}



@end
