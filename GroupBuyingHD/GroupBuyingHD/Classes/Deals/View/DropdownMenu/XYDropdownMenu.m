//
//  XYDropdownMenu.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDropdownMenu.h"
#import "XYDropdownMainCell.h"
#import "XYDropdownSubCell.h"

@interface XYDropdownMenu ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@end

@implementation XYDropdownMenu

#pragma mark - 初始化
+ (instancetype)dropdownMenu{
    return [[[NSBundle mainBundle] loadNibNamed:@"XYDropdownMenu" owner:nil options:nil] lastObject];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    _mainTableView.backgroundColor = [UIColor lightTextColor];
    _subTableView.backgroundColor = [UIColor lightTextColor];
}

#pragma mark - 更新cell
- (void)setItems:(NSArray *)items{
    _items = items;
    [_mainTableView reloadData];
    [_subTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _mainTableView) {
        return _items.count;
    }else{
        //main中选中的一行
        NSInteger index = [_mainTableView indexPathForSelectedRow].row;
        id<XYDropdownMenuItem> item = _items[index];
        return [item subtitles].count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _mainTableView) {//左边main cell
        XYDropdownMainCell *mainCell = [XYDropdownMainCell cellWithTableView:tableView];
        mainCell.item = self.items[indexPath.row];
        return mainCell;
    }else{//右边 子cell
        XYDropdownSubCell *subCell = [XYDropdownSubCell cellWithTableView:tableView];
        //main中选中的一行
        NSInteger index = [_mainTableView indexPathForSelectedRow].row;
        id<XYDropdownMenuItem> item = _items[index];
        
        subCell.textLabel.text = [item subtitles][indexPath.row];
        return subCell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击左边的主cell，刷新子表格
    if (tableView == _mainTableView) {
        [_subTableView reloadData];
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectedMainCell:)]) {
            [self.delegate dropdownMenu:self didSelectedMainCell:indexPath.row];
        }
    }else{//点击子表格
        if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectedSubCell:ofMianCell:)]) {
            NSInteger mainIndex = [self.mainTableView indexPathForSelectedRow].row;
            [self.delegate dropdownMenu:self didSelectedSubCell:indexPath.row ofMianCell:mainIndex];
        }
        
    }
}

#pragma mark - 设置表格的选中
/**
 *  设置主表格的选中的cell
 *
 *  @param mainIndex 主表格的index
 */
- (void)selectedMainCell:(NSInteger)mainIndex{
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mainIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.subTableView reloadData];
}
/**
 *  设置子表格的选中的cell
 *
 *  @param subIndex 子表格的index
 */
- (void)selectedSubCell:(NSInteger)subIndex{
    [self.subTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:subIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [self.subTableView reloadData];
}

@end
