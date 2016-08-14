//
//  XYCategory.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCategory.h"

@implementation XYCategory
MJExtensionCodingImplementation

- (NSString *)title{
    return self.name;
}

- (NSArray *)subtitles{
    return self.subcategories;
}

- (NSString *)image{
    return self.small_icon;
}

- (NSString *)highlightImage{
    return self.small_highlighted_icon;
}
@end
