//
//  XYMetaDataTool.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYCity, XYSort, XYCategory, XYRegion;

@interface XYMetaDataTool : NSObject

/**
 *  团购种类
 */
@property (nonatomic, strong, readonly) NSArray *categories;
/**
 *  团购支持的城市
 */
@property (nonatomic, strong, readonly) NSArray *cities;
/**
 *  全国的城市组
 */
@property (nonatomic, strong, readonly) NSArray *cityGroups;
/**
 *  排序方式
 */
@property (nonatomic, strong, readonly) NSArray *sorts;
/**
 *  单例模式创建工具类
 */
+ (instancetype)shareMateData;

/**
 *  查询城市
 */
- (XYCity *)cityWithName:(NSString *)name;

/**
 *  存用户选中的sort
 */
- (void)saveSelectedSort:(XYSort *)sort;
/**
 *  取用户选中的sort
 */
- (XYSort *)selectedSort;
/**
 *  存用户选中的分类
 */
- (void)saveSelectedCategory:(XYCategory *)category;
/**
 *  取用户选中的分类
 */
- (XYCategory *)selectedCategory;
/**
 *  存城市名到沙盒中
 *
 *  @param name 城市名保存到沙盒的数组中
 */
- (void)saveSelectedCityName:(NSString *)name;
/**
 *  取城市
 */
- (XYCity *)selectedCity;
/**
 *  存region
 */
- (void)saveSelectedRegion:(XYRegion *)region;
/**
 *  取region
 */
- (XYRegion *)selectedRegion;
/**
 *  通过名称找类
 */
- (XYCategory *)categoryWithName:(NSString *)name;
@end
