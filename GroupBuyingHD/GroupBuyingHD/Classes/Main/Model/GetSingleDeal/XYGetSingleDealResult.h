//
//  XYGetSingleDealResult.h
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//// 获取一个指定的团购的返回结果

#import <Foundation/Foundation.h>

@interface XYGetSingleDealResult : NSObject

/** 本次API访问所获取的单页团购数量 */
@property (assign, nonatomic) int count;
/** 所有的团购 */
@property (strong, nonatomic) NSArray *deals;

@end
