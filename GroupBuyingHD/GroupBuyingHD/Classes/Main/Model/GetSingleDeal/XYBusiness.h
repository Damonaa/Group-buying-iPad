//
//  XYBusiness.h
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
// 此条团购适用商家

#import <Foundation/Foundation.h>

@interface XYBusiness : NSObject
/** 商户名 */
@property (copy, nonatomic) NSString *name;
/** 商户ID */
@property (copy, nonatomic) NSString *ID;
/** 商户城市 */
@property (copy, nonatomic) NSString *city;

/** 纬度 */
@property (assign, nonatomic) float latitude;
/** 经度 */
@property (assign, nonatomic) float longitude;

/** 商户页面链接，适用于网页应用 */
@property (copy, nonatomic) NSString *url;
/** 商户HTML5页面链接，适用于移动应用和联网车载应用 */
@property (copy, nonatomic) NSString *h5_url;

/** 商户地址 */
@property (copy, nonatomic) NSString *address;

@end
