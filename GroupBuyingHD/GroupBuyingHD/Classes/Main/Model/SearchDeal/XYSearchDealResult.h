//
//  XYSearchDealResult.h
//  团购HD
//
//  Created by 李小亚 on 16/8/1.
//  Copyright © 2016年 李小亚. All rights reserved.
// 搜索团购的返回结果

#import "XYGetSingleDealResult.h"

@interface XYSearchDealResult : XYGetSingleDealResult

/** 所有页面团购总数 */
@property (assign, nonatomic) int total_count;

@end
