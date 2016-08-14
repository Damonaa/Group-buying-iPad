//
//  XYDealsTopMenu.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYDealsTopMenu : UIView


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;

/**
 *  加载xib,创建菜单
 */
+ (instancetype)dealsTopMenu;

- (void)addTarget:(id)target action:(nonnull SEL)action;
@end
