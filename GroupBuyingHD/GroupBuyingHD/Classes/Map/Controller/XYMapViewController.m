//
//  XYMapViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/13.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIBarButtonItem+Extension.h"
#import "XYDealTool.h"
#import "XYSearchDealParam.h"
#import "XYSearchDealResult.h"
#import "XYDeal.h"
#import "XYBusiness.h"
#import "XYAnnotationButton.h"
#import "XYDealAnnotation.h"
#import "XYDetailViewController.h"
#import "XYCategoryViewController.h"
#import "XYDealsTopMenu.h"
#import "XYCategory.h"
#import "MBProgressHUD+CZ.h"
#import "XYMetaDataTool.h"

@interface XYMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/**
 *  返回item
 */
@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLGeocoder *geocoder;
/**
 *  当前城市
 */
@property (nonatomic, copy) NSString *locationCity;
/**
 *  是否正在处理搜索团购
 */
@property (nonatomic, assign, getter=isDealingDeal) BOOL dealingDeal;

/****popover控制器****/
@property (nonatomic, strong) UIPopoverController *categoryPopover;
/**
 *  分类菜单
 */
@property (nonatomic, strong) XYDealsTopMenu *categoryMenu;

/** 当前选中的分类 */
@property (strong, nonatomic) XYCategory *selectedCategory;
/** 当前选中的子分类名称 */
@property (copy, nonatomic) NSString *selectedSubCategoryName;

@end

@implementation XYMapViewController

#pragma mark - 懒加载

- (UIPopoverController *)categoryPopover{
    if (!_categoryPopover) {
        
        XYCategoryViewController *cvc = [[XYCategoryViewController alloc] init];
        _categoryPopover = [[UIPopoverController alloc] initWithContentViewController:cvc];
    }
    return _categoryPopover;
}
- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(backItemClick)];
    }
    return _backItem;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedCategory = [XYMetaDataTool shareMateData].categories[0];
    
    //导航栏
    self.title = @"地图";
    //分类
    self.categoryMenu = [XYDealsTopMenu dealsTopMenu];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:_categoryMenu];
    _categoryMenu.imageBtn.image = _selectedCategory.icon;
    _categoryMenu.imageBtn.highlightedImage = _selectedCategory.highlighted_icon;
    _categoryMenu.titleLabel.text = _selectedCategory.title;
    _categoryMenu.subtitleLabel.text = _selectedCategory.subcategory;
    [_categoryMenu addTarget:self action:@selector(cartgoryMenuClick)];
    self.navigationItem.leftBarButtonItems = @[self.backItem, categoryItem];

    //地图
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self mapView:self.mapView regionDidChangeAnimated:YES];
}
#pragma mark - 监听通知
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //类别切换
    [XYNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:XYCategoryDidChangeNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [XYNotificationCenter removeObserver:self];
}

//分类菜单点击，展示分类控制器
- (void)cartgoryMenuClick{
    //设置用户之前的选中cell
    XYCategoryViewController *categoryVC = (XYCategoryViewController *)self.categoryPopover.contentViewController;
    categoryVC.selectedCategory = self.selectedCategory;
    categoryVC.selectedSubcategoryName = self.selectedSubCategoryName;
    
    [self.categoryPopover presentPopoverFromRect:_categoryMenu.bounds inView:_categoryMenu permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//类别变化
- (void)categoryDidChange:(NSNotification *)noti{
    //接收通知的参数
    self.selectedCategory = noti.userInfo[XYSelectedCategory];
    self.selectedSubCategoryName = noti.userInfo[XYSelectedSubCategory];
    
    //为自定义的按钮赋值
    self.categoryMenu.titleLabel.text = _selectedCategory.name;
    self.categoryMenu.subtitleLabel.text = _selectedSubCategoryName;
    self.categoryMenu.imageBtn.image = _selectedCategory.icon;
    self.categoryMenu.imageBtn.highlightedImage = _selectedCategory.highlighted_icon;
    
    //先移除大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    //重新查询数据
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    //隐藏popover
    [_categoryPopover dismissPopoverAnimated:YES];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(XYDealAnnotation *)annotation{
    //若果是当前位置的点，保持不变
    if (![annotation isKindOfClass:[XYDealAnnotation class]]) {
        return nil;
    }
    
    static NSString *reuseID = @"annotionDeal";
    
    MKAnnotationView *dealAnnotation = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    
    XYAnnotationButton *btn = nil;
    if (!dealAnnotation) {
        dealAnnotation = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:reuseID];
        dealAnnotation.canShowCallout = YES;
        
        btn = [XYAnnotationButton buttonWithType:UIButtonTypeDetailDisclosure];
        [btn addTarget:self action:@selector(rightBtnClick:)];
        dealAnnotation.rightCalloutAccessoryView = btn;
    }else{//从缓存池中取出
        btn = (XYAnnotationButton *)dealAnnotation.rightCalloutAccessoryView;
    }
    btn.deal = annotation.deal;
    
    
    //设置大头针的图标、
    if ([self.selectedCategory.name isEqualToString:@"全部分类"]) {
        NSString *categoryStr = annotation.deal.categories[0];
        NSString *mapIcon = [[XYMetaDataTool shareMateData] categoryWithName:categoryStr].map_icon;
        dealAnnotation.image = [UIImage imageNamed:mapIcon];
        
    }else{//点击某个分类，则地图显示的图标全是那个类的
        dealAnnotation.image = [UIImage imageNamed:self.selectedCategory.map_icon];
    }
    
    //覆盖模型数据
    dealAnnotation.annotation = annotation;
    
    
    return dealAnnotation;
}
//获取到用户的位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //创建区域
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    //显示区域位置
    [mapView setRegion:region];
    //反地理编码，获取所在城市
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0) {
            return;
        }
        
        CLPlacemark *placemark = placemarks[0];
        NSString *city;
        if (placemark.locality) {
            city = placemark.locality;
        }else{
            city = placemark.addressDictionary[@"State"];
        }
        self.locationCity = [city substringToIndex:city.length - 1];
        
    }];
}

- (void)rightBtnClick:(XYAnnotationButton *)btn{
    XYDetailViewController *detailVC = [[XYDetailViewController alloc] init];
    detailVC.deal = btn.deal;
    [self presentViewController:detailVC animated:YES completion:nil];
}
//地图拖动，区域发生变化
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.locationCity == nil || self.isDealingDeal) {
        return;
    }
    self.dealingDeal = YES;
    //发送请求
    XYSearchDealParam *param = [[XYSearchDealParam alloc] init];
    param.city = self.locationCity;
    
    CLLocationCoordinate2D coordinate = mapView.region.center;
    param.latitude = @(coordinate.latitude);
    param.longitude = @(coordinate.longitude);
    param.radius = @5000;
    
    //类别， 排除特殊类别
    if (self.selectedCategory && ![self.selectedCategory.name isEqualToString:@"全部分类"]) {
        if (self.selectedSubCategoryName && ![self.selectedSubCategoryName isEqualToString:@"全部"]) {
            param.category = self.selectedSubCategoryName;
        }else{
            param.category = self.selectedCategory.name;
        }
    }
    
    [XYDealTool searchDealWithParam:param success:^(XYSearchDealResult *result) {
        if (result.deals.count == 0) {
            [MBProgressHUD showError:@"没有找到相应的团购" toView:self.navigationController.view];
            self.dealingDeal = NO;
            return;
        }
        //将查询到的团购添加到地图上
        [self setupAnnotionWithDeals:result.deals];
        
    } failure:^(NSError *error) {
        self.dealingDeal = NO;
        [MBProgressHUD showError:@"加载团购失败，请稍后再试" toView:self.navigationController.view];
    }];
    
}
//将查询到的团购添加到地图上
- (void)setupAnnotionWithDeals:(NSArray *)deals{
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (XYDeal *deal in deals) {
            
//            XYLog(@"%@ -- %@", deal.title, deal.businesses);
            
            for (XYBusiness *business in deal.businesses) {
                //创建自定义大头针模型
                XYDealAnnotation *annotation = [[XYDealAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
                annotation.title = deal.title;
                annotation.subtitle = business.name;
                //大头针上存储团购模型
                annotation.deal = deal;
                //已经存在，不再添加
                if ([self.mapView.annotations containsObject:annotation]) {
                    return;
                }
                //主线程添加大头针
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:annotation];
                });
            }
        }
        
        self.dealingDeal = NO;
    });
    
    
}

#pragma mark - 处理导航栏按钮的点击事件
//返回
- (void)backItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)backToUserLocation:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}
@end
