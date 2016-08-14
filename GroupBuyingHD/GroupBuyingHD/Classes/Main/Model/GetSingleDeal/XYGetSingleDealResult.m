//
//  XYGetSingleDealResult.m
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYGetSingleDealResult.h"
#import "XYDeal.h"

@implementation XYGetSingleDealResult

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"deals": [XYDeal class]};
}

@end
