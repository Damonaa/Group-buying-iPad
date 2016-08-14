//
//  XYCategory.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
// 团购的类别

#import <Foundation/Foundation.h>
#import "XYDropdownMenu.h"

@interface XYCategory : NSObject<XYDropdownMenuItem>

/** 类别名称 */
@property (copy, nonatomic) NSString *name;
/** 大图标 */
@property (copy, nonatomic) NSString *icon;
/** 大图标(高亮) */
@property (copy, nonatomic) NSString *highlighted_icon;
/** 小图标 */
@property (copy, nonatomic) NSString *small_icon;
/** 小图标(高亮) */
@property (copy, nonatomic) NSString *small_highlighted_icon;
/** 子类别数组 */
@property (strong, nonatomic) NSArray *subcategories;
/**
 *  选中的子类
 */
@property (nonatomic, copy) NSString *subcategory;
/**
 *  显示到地图上的图片
 */
@property (nonatomic, copy) NSString *map_icon;

@end
