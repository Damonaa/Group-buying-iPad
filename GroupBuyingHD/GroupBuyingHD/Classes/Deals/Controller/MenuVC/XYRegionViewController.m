//
//  XYRegionViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYRegionViewController.h"
#import "XYDropdownMenu.h"
#import "XYCity.h"
#import "XYRegion.h"

@interface XYRegionViewController ()<XYDropdownMenuDelegate>

@property (nonatomic, strong) XYDropdownMenu *menu;

- (IBAction)changeCity;

@end

@implementation XYRegionViewController

- (XYDropdownMenu *)menu{
    if (!_menu) {
        UIView *topTool = self.view.subviews.firstObject;
        _menu = [XYDropdownMenu dropdownMenu];
        [self.view addSubview:_menu];
        _menu.delegate = self;
        
        [_menu autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topTool];
        [_menu autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    }
    return  _menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.preferredContentSize = CGSizeMake(400, 480);
    
}

//设置区域
- (void)setSelectedRegions:(NSArray *)selectedRegions{
    _selectedRegions = selectedRegions;
    self.menu.items = selectedRegions;
}

- (IBAction)changeCity {
    //调用block
    if (_changeCityBlock) {
        _changeCityBlock();
    }
  
}

#pragma mark - XYDropdownMenuDelegate
/**
 *  点击主表格响应此代理方法
 *
 *  @param menu      菜单
 *  @param mainIndex 主cell的index
 */
- (void)dropdownMenu:(XYDropdownMenu *)menu didSelectedMainCell:(NSInteger)mainIndex{
    XYRegion *region = menu.items[mainIndex];
    if (region.subregions.count == 0) {//区域没有子区域，发出通知
        [XYNotificationCenter postNotificationName:XYRegionDidChangeNotification object:self userInfo:@{XYSelectedRegion: region}];
    }
    
    
}
/**
 *  点击子表格响应此代理方法
 *
 *  @param menu      菜单
 *  @param subIndex  子表格cell的index
 *  @param mainIndex 主表格cell的index
 */
- (void)dropdownMenu:(XYDropdownMenu *)menu didSelectedSubCell:(NSInteger)subIndex ofMianCell:(NSInteger)mainIndex{
    //点击子表格的cell，发出通知
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    XYRegion *region = menu.items[mainIndex];
    dict[XYSelectedRegion] = region;
    dict[XYSelectedSubRegion] = region.subregions[subIndex];
    
    [XYNotificationCenter postNotificationName:XYRegionDidChangeNotification object:self userInfo:dict];
    
}

#pragma mark - 设置用户上次点击的表格的选中
//主表格选中
- (void)setSelectedRegion:(XYRegion *)selectedRegion{
    _selectedRegion = selectedRegion;
    
    NSInteger mainIndex = [self.menu.items indexOfObject:selectedRegion];
    
    [_menu selectedMainCell:mainIndex];
}

- (void)setSelectedSubregionName:(NSString *)selectedSubregionName{
    _selectedSubregionName = [selectedSubregionName copy];
    
    NSInteger subIndex = [self.selectedRegion.subregions indexOfObject:selectedSubregionName];
    [_menu selectedSubCell:subIndex];
}
@end
