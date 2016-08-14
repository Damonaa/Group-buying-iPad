//
//  XYRegion.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDropdownMenu.h"

@interface XYRegion : NSObject<XYDropdownMenuItem>

/** 区域名称 */
@property (copy, nonatomic) NSString *name;
/** 子区域数组 */
@property (strong, nonatomic) NSArray *subregions;
/**
 *  选中的子区域
 */
@property (nonatomic, copy) NSString *subregion;
@end
