//
//  XYRegion.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYRegion.h"

@implementation XYRegion
MJExtensionCodingImplementation

- (NSString *)title{
    return self.name;
}

- (NSArray *)subtitles{
    return self.subregions;
}

@end
