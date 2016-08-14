//
//  XYCity.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
// 支持团购的城市

#import <Foundation/Foundation.h>
#import "XYDropdownMenu.h"

@interface XYCity : NSObject<XYDropdownMenuItem>
/** 城市名称 */
@property (copy, nonatomic) NSString *name;
/** 区域 */
@property (strong, nonatomic) NSArray *regions;
/** 拼音 beijing */
@property (copy, nonatomic) NSString *pinYin;
/** 拼音首字母 bj */
@property (copy, nonatomic) NSString *pinYinHead;

@end
