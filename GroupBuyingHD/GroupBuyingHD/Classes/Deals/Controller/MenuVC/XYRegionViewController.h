//
//  XYRegionViewController.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYRegion;

typedef void(^ChangeCityBlock)();

@interface XYRegionViewController : UIViewController

@property (nonatomic, copy) ChangeCityBlock changeCityBlock;

/**
 *  选中的城市区域
 */
@property (nonatomic, strong) NSArray *selectedRegions;
/**
 *  选好的区域
 */
@property (nonatomic, strong) XYRegion *selectedRegion;
/**
 *  选中的子区域的名字
 */
@property (nonatomic, copy) NSString *selectedSubregionName;

@end
