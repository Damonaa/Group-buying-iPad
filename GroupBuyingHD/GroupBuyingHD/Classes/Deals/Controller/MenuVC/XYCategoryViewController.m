//
//  XYCategoryViewController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCategoryViewController.h"
#import "XYDropdownMenu.h"
#import "XYCategory.h"

@interface XYCategoryViewController ()<XYDropdownMenuDelegate>
@property (nonatomic, strong) XYDropdownMenu *dropdownMenu;
@end

@implementation XYCategoryViewController

- (void)loadView{
    self.dropdownMenu = [XYDropdownMenu dropdownMenu];
    self.dropdownMenu.delegate = self;
    self.dropdownMenu.items = [XYMetaDataTool shareMateData].categories;
    self.view = _dropdownMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preferredContentSize = CGSizeMake(400, 480);
}

#pragma mark - XYDropdownMenuDelegate
/**
 *  点击主表格响应此代理方法
 *
 *  @param menu      菜单
 *  @param mainIndex 主cell的index
 */
- (void)dropdownMenu:(XYDropdownMenu *)menu didSelectedMainCell:(NSInteger)mainIndex{
    XYCategory *category = menu.items[mainIndex];
    if (category.subcategories.count == 0) {//没有子菜单，发出通知
        [XYNotificationCenter postNotificationName:XYCategoryDidChangeNotification object:self userInfo:@{XYSelectedCategory: category}];
    }
    //保存到沙盒
    category.subcategory = nil;
    [[XYMetaDataTool shareMateData] saveSelectedCategory:category];
}
/**
 *  点击子表格响应此代理方法
 *
 *  @param menu      菜单
 *  @param subIndex  子表格cell的index
 *  @param mainIndex 主表格cell的index
 */
- (void)dropdownMenu:(XYDropdownMenu *)menu didSelectedSubCell:(NSInteger)subIndex ofMianCell:(NSInteger)mainIndex{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    XYCategory *category = menu.items[mainIndex];
    dict[XYSelectedCategory] = category;
    NSString *subCategory = category.subcategories[subIndex];
    dict[XYSelectedSubCategory] = subCategory;
    [XYNotificationCenter postNotificationName:XYCategoryDidChangeNotification object:self userInfo:dict];
    
    //保存到沙盒
    category.subcategory = subCategory;
    [[XYMetaDataTool shareMateData] saveSelectedCategory:category];
    
}

#pragma mark - 设置用户之前点击的选中状态
- (void)setSelectedCategory:(XYCategory *)selectedCategory{
    _selectedCategory = selectedCategory;
    NSInteger mainIndex = [self.dropdownMenu.items indexOfObject:selectedCategory];
    //主表格选中
    [_dropdownMenu selectedMainCell:mainIndex];
}

- (void)setSelectedSubcategoryName:(NSString *)selectedSubcategoryName{
    _selectedSubcategoryName = selectedSubcategoryName;
    NSInteger subIndex = [_selectedCategory.subcategories indexOfObject:selectedSubcategoryName];
    //子表选中
    [_dropdownMenu selectedSubCell:subIndex];
}

@end
