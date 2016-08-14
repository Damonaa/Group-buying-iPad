//
//  XYEmptyView.m
//  团购HD
//
//  Created by 李小亚 on 16/8/7.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYEmptyView.h"

@implementation XYEmptyView

+ (instancetype)emptyView{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

//填充父控件
- (void)didMoveToSuperview{
    if (self.superview) {
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    
}
@end
