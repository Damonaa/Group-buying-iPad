//
//  XYLineLabel.m
//  团购HD
//
//  Created by 李小亚 on 16/8/7.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYLineLabel.h"

@implementation XYLineLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setText:(NSString *)text{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:dict];
    self.attributedText = attr;
}


@end
