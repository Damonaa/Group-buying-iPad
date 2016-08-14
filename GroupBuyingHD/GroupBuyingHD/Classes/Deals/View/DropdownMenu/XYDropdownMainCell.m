//
//  XYDropdownMainCell.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDropdownMainCell.h"

@interface XYDropdownMainCell ()

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation XYDropdownMainCell

#pragma mark - 懒加载
- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    }
    return _arrowImageView;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reusedID = @"mainCell";
    XYDropdownMainCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (!cell) {
        cell = [[XYDropdownMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        self.backgroundView = bgIV;
        
        UIImageView *selectedBgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        self.selectedBackgroundView = selectedBgIV;
    }
    return self;
}

//设置cell的内容
- (void)setItem:(id<XYDropdownMenuItem>)item{
    _item = item;
    //标题
    self.textLabel.text = [item title];
    
    //图标
    if ([item respondsToSelector:@selector(image)]) {
        self.imageView.image = [UIImage imageNamed:[item image]];
    }
    
    //高亮图标
    if ([item respondsToSelector:@selector(highlightImage)]) {
        self.imageView.highlightedImage = [UIImage imageNamed:[item highlightImage]];
    }
    //箭头
    if ([item subtitles].count > 0) {
        self.accessoryView = self.arrowImageView;
    }else{
        self.accessoryView = nil;
    }
}
@end
