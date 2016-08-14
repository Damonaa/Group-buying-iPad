//
//  XYMainDealsController.h
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYEmptyView;

@interface XYMainDealsController : UICollectionViewController
/**
 *  存放查询到的团购数据
 */
@property (nonatomic, strong) NSMutableArray *deals;
/**
 *  未查询到数据，显示无数据图片
 */
@property (nonatomic, weak) XYEmptyView *emptyView;

@end
