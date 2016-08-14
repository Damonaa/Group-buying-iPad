//
//  XYCity.m
//  团购HD
//
//  Created by 李小亚 on 16/8/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCity.h"
#import "XYRegion.h"

@implementation XYCity

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"regions": [XYRegion class]};
}


- (NSString *)title{
    return self.name;
}

- (NSArray *)subtitles{
    return self.regions;
}
@end
