//
//  XYMainNavigationController.m
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMainNavigationController.h"

@implementation XYMainNavigationController

+ (void)initialize{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    //按钮正常状态
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [barItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    //按钮禁用状态
    NSMutableDictionary *disAttr = [NSMutableDictionary dictionary];
    disAttr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [barItem setTitleTextAttributes:disAttr forState:UIControlStateDisabled];

}

@end
