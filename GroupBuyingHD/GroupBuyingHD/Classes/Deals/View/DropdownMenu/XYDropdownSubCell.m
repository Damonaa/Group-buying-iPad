//
//  XYDropdownSubCell.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDropdownSubCell.h"

@implementation XYDropdownSubCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reusedID = @"subCell";
    XYDropdownSubCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (!cell) {
        cell = [[XYDropdownSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        self.backgroundView = bgIV;
        
        UIImageView *selectedBgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
        self.selectedBackgroundView = selectedBgIV;
    }
    return self;
}

@end
