//
//  XYDealAnnotation.h
//  团购HD
//
//  Created by 李小亚 on 16/8/13.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class XYDeal;

@interface XYDealAnnotation : NSObject<MKAnnotation>

/**
 *  坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  团购模型
 */
@property (nonatomic, strong) XYDeal *deal;
@end
