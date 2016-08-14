//
//  XYCityGroup.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCityGroup : NSObject
/** 组标题 */
@property (copy, nonatomic) NSString *title;
/** 这组显示的城市 */
@property (strong, nonatomic) NSArray *cities;

@end
