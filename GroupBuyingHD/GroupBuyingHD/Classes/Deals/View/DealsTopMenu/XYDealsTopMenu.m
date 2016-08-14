//
//  XYDealsTopMenu.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDealsTopMenu.h"

@interface XYDealsTopMenu ()


@end

@implementation XYDealsTopMenu

+ (instancetype)dealsTopMenu{
    return [[[NSBundle mainBundle] loadNibNamed:@"XYDealsTopMenu" owner:nil options:nil] lastObject];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //禁止默认的拉伸
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)addTarget:(id)target action:(nonnull SEL)action{
    [self.imageBtn addTarget:target action:action];
}
@end
