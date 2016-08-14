//
//  XYCategoryViewController.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYCategory;

@interface XYCategoryViewController : UIViewController
/**
 *  选中的类别
 */
@property (nonatomic, strong) XYCategory *selectedCategory;

/**
 *  选中的子类别的名字
 */
@property (nonatomic, copy) NSString *selectedSubcategoryName;

@end
