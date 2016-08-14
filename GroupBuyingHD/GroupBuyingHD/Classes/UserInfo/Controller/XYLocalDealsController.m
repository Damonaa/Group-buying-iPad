//
//  XYLocalDealsController.m
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYLocalDealsController.h"
#import "UIBarButtonItem+Extension.h"
#import "XYDeal.h"
#import "XYDealCell.h"
#import "XYDealLocalTool.h"

@interface XYLocalDealsController ()<XYDealCellDelegate>
/**
 *  返回item
 */
@property (nonatomic, strong) UIBarButtonItem *backItem;
/**
 *  编辑item
 */
@property (nonatomic, strong) UIBarButtonItem *editItem;
/**
 *  选中全部item
 */
@property (nonatomic, strong) UIBarButtonItem *selectedAllItem;
/**
 *  取消选中Item
 */
@property (nonatomic, strong) UIBarButtonItem *cancelAllItem;
/**
 *  删除Item
 */
@property (nonatomic, strong) UIBarButtonItem *deleteItem;

@end

@implementation XYLocalDealsController

#pragma mark - 懒加载


- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithImageName:@"icon_back" highImageName:@"icon_back_highlighted" target:self action:@selector(backItemClick)];
    }
    return _backItem;
}
- (UIBarButtonItem *)editItem{
    if (!_editItem) {
        _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editItemClick)];
    }
    return _editItem;
}

- (UIBarButtonItem *)selectedAllItem{
    if (!_selectedAllItem) {
        _selectedAllItem = [[UIBarButtonItem alloc] initWithTitle:@"  全选  " style:UIBarButtonItemStyleDone target:self action:@selector(selectedAllItemClick)];
    }
    return _selectedAllItem;
}

- (UIBarButtonItem *)cancelAllItem{
    if (!_cancelAllItem) {
        _cancelAllItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消  " style:UIBarButtonItemStyleDone target:self action:@selector(cancelAllItemClick)];
    }
    return _cancelAllItem;
}

- (UIBarButtonItem *)deleteItem{
    if (!_deleteItem) {
        _deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"  删除  " style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemClick)];
        _deleteItem.enabled = NO;
    }
    return _deleteItem;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左边的导航栏按钮
    self.navigationItem.leftBarButtonItems = @[self.backItem];

    //右边的导航栏按钮
    self.navigationItem.rightBarButtonItem = self.editItem;
    
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //清空cell被选中和编辑的状态
    for (XYDeal *deal in self.deals) {
        deal.editing = NO;
        deal.selected = NO;
    }
}
#pragma mark - 处理导航栏按钮的点击事件
//返回
- (void)backItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
//编辑
- (void)editItemClick{
    NSString *title = self.editItem.title;
    
    if ([title isEqualToString:@"编辑"]) {//编辑状态
        self.editItem.title = @"完成";
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectedAllItem, self.cancelAllItem, self.deleteItem];
        for (XYDeal *deal in self.deals) {
            deal.editing = YES;
        }
        [self.collectionView reloadData];
        
    }else{//完成状态
        self.editItem.title = @"编辑";
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        for (XYDeal *deal in self.deals) {
            deal.editing = NO;
            deal.selected = NO;
        }
        [self.collectionView reloadData];
    }
}
//全选
- (void)selectedAllItemClick{
    for (XYDeal *deal in self.deals) {
        deal.selected = YES;
    }
    [self dealCellDidSelected:nil];
    [self.collectionView reloadData];
    
}
//取消选中
- (void)cancelAllItemClick{
    for (XYDeal *deal in self.deals) {
        deal.selected = NO;
    }
    [self dealCellDidSelected:nil];
    [self.collectionView reloadData];
}
//删除选中
- (void)deleteItemClick{
    self.deleteItem.enabled = NO;
    if (self.deals.count == 0) {
        self.editItem.title = @"编辑";
        self.editItem.enabled = NO;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}
//将要被移除的团购
- (NSArray *)willCancelDeals{
    NSMutableArray *selectedDeals = [NSMutableArray array];
    
    for (XYDeal *deal in self.deals) {
        if (deal.isSelected) {
            [selectedDeals addObject:deal];
        }
    }
    
    [self.deals removeObjectsInArray:selectedDeals];
    [self.collectionView reloadData];
    //更新删除按钮上的数字
    [self dealCellDidSelected:nil];
    
    return selectedDeals;
}


#pragma mark - XYDealCellDelegate
//点击cell上遮盖曾按钮响应的代理
- (void)dealCellDidSelected:(XYDealCell *)dealCell{
    NSInteger selectedCount = 0;
    for (XYDeal *deal in self.deals) {
        if (deal.isSelected) {
            selectedCount ++;
        }
    }
    
    if (selectedCount > 0) {
        self.deleteItem.enabled = YES;
        self.deleteItem.title = [NSString stringWithFormat:@"  删除(%ld)  ", selectedCount];
    }else{
        self.deleteItem.enabled = NO;
        self.deleteItem.title = @"  删除  ";
    }
}
@end
