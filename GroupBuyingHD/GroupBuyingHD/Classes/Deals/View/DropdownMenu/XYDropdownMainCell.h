//
//  XYDropdownMainCell.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDropdownMenu.h"

@interface XYDropdownMainCell : UITableViewCell

@property (nonatomic, strong) id<XYDropdownMenuItem> item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
