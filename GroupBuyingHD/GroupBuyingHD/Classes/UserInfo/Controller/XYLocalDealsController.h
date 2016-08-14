//
//  XYLocalDealsController.h
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
// 本地的团购信息的父控制器

#import "XYMainDealsController.h"

@interface XYLocalDealsController : XYMainDealsController

//删除选中
- (void)deleteItemClick;
/**
 *  将要被移除的团购
 */
- (NSArray *)willCancelDeals;

@end
