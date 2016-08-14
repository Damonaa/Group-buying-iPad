//
//  XYDealLocalTool.h
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYDeal;

@interface XYDealLocalTool : NSObject
/**
 *  保存用户浏览的记录，存到数组，保存到沙盒
 */
@property (nonatomic, strong, readonly) NSMutableArray *historyDeals;
/**
 *  保存历史团购到沙盒
 */
- (void)saveHistoryDeal:(XYDeal *)deal;
/**
 *  移除历史团购
 */
- (void)cancelHistoryDeal:(XYDeal *)deal;
/**
 *  移除历史团购数组
 */
- (void)cancelHistoryDeals:(NSArray *)deals;


/**
 *  保存用户浏览的记录，存到数组，保存到沙盒
 */
@property (nonatomic, strong, readonly) NSMutableArray *collectDeals;
/**
 *  保存收藏团购到沙盒
 */
- (void)saveCollectDeal:(XYDeal *)deal;
/**
 *  移除收藏团购
 */
- (void)cancelCollectDeal:(XYDeal *)deal;
/**
 *  移除收藏团购数组
 */
- (void)cancelCollectDeals:(NSArray *)deals;

/**
 *  单例模式
 */
+ (instancetype)shareDealLocalTool;
@end
