//
//  XYDropdownMenu.h
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYDropdownMenu;

#pragma mark - 成为下拉菜单的对象所必须遵守的协议
@protocol XYDropdownMenuItem <NSObject>

@required
/**
 *  标题
 */
- (NSString *)title;
/**
 *  子标题数组
 */
- (NSArray *)subtitles;
@optional
/**
 *  图标
 */
- (NSString *)image;
/**
 *  高亮图标
 */
- (NSString *)highlightImage;
@end

#pragma mark - 点击下拉菜单响应的协议

@protocol XYDropdownMenuDelegate <NSObject>

@optional
/**
 *  点击主表格响应此代理方法
 *
 *  @param menu      菜单
 *  @param mainIndex 主cell的index
 */
- (void)dropdownMenu:(XYDropdownMenu *)menu didSelectedMainCell:(NSInteger)mainIndex;
/**
 *  点击子表格响应此代理方法
 *
 *  @param menu      菜单
 *  @param subIndex  子表格cell的index
 *  @param mainIndex 主表格cell的index
 */
- (void)dropdownMenu:(XYDropdownMenu *)menu didSelectedSubCell:(NSInteger)subIndex ofMianCell:(NSInteger)mainIndex;
@end


@interface XYDropdownMenu : UIView

/**
 *  显示的数据模型，里面的元素必须遵守XYDropdownMenuItem协议
 */
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<XYDropdownMenuDelegate> delegate;
/**
 *  初始化
 */
+ (instancetype)dropdownMenu;
/**
 *  设置主表格的选中的cell
 *
 *  @param mainIndex 主表格的index
 */
- (void)selectedMainCell:(NSInteger)mainIndex;
/**
 *  设置子表格的选中的cell
 *
 *  @param subIndex 子表格的index
 */
- (void)selectedSubCell:(NSInteger)subIndex;

@end
