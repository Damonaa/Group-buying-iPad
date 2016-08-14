//
//  XYDealLocalTool.m
//  团购HD
//
//  Created by 李小亚 on 16/8/10.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDealLocalTool.h"
#import "XYDeal.h"

#define XYHistoryDeals @"historyDeals.archive"
#define XYCollectDeals @"collectDeals.archive"


@interface XYDealLocalTool ()
{
    NSMutableArray *_historyDeals;
    
    NSMutableArray *_collectDeals;
}
@end

@implementation XYDealLocalTool

#pragma mark - 懒加载
- (NSMutableArray *)historyDeals{
    if (!_historyDeals) {//先从沙盒中获取
        _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathWithFileName:XYHistoryDeals]];
        if (!_historyDeals) {//沙盒为空，创建
            _historyDeals = [NSMutableArray array];
        }
    }
    return _historyDeals;
}

- (NSMutableArray *)collectDeals{
    if (!_collectDeals) {
        _collectDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathWithFileName:XYCollectDeals]];
        if (!_collectDeals) {
            _collectDeals = [NSMutableArray array];
        }
    }
    return _collectDeals;
}

#pragma mark -处理历史记录
- (void)saveHistoryDeal:(XYDeal *)deal{
    if (deal == nil) { return; }
    
    [self.historyDeals removeObject:deal];
    [self.historyDeals insertObject:deal atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:[self cachePathWithFileName:XYHistoryDeals]];
}
- (void)cancelHistoryDeal:(XYDeal *)deal{
    if (deal == nil) { return; }
    
    [self.historyDeals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:[self cachePathWithFileName:XYHistoryDeals]];
}
- (void)cancelHistoryDeals:(NSArray *)deals{
    
    [self.historyDeals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:self.historyDeals toFile:[self cachePathWithFileName:XYHistoryDeals]];
}


#pragma mark -处理收藏记录
/**
 *  保存收藏团购到沙盒
 */
- (void)saveCollectDeal:(XYDeal *)deal{
    if (deal == nil) { return; }
    
    [self.collectDeals removeObject:deal];
    [self.collectDeals insertObject:deal atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:[self cachePathWithFileName:XYCollectDeals]];
}
/**
 *  移除收藏团购
 */
- (void)cancelCollectDeal:(XYDeal *)deal{
    if (deal == nil) { return; }
    
    [self.collectDeals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:[self cachePathWithFileName:XYCollectDeals]];
}
/**
 *  移除收藏团购数组
 */
- (void)cancelCollectDeals:(NSArray *)deals{
    [self.collectDeals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:self.collectDeals toFile:[self cachePathWithFileName:XYCollectDeals]];
}

#pragma mark - 单例模式
static id _instance = nil;
+ (instancetype)shareDealLocalTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}



/**
 *  获取沙盒缓存文件夹的路径
 *
 *  @param name 保存的文件名字
 */
- (NSString *)cachePathWithFileName:(NSString *)name{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return [dir stringByAppendingPathComponent:name];
}

@end
