//
//  XYDeal.m
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDeal.h"
#import "XYBusiness.h"

@implementation XYDeal
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"desc" : @"description"};
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"businesses": [XYBusiness class]};
}
/**
 *  重写比较方法，判断deal_id是否一致
 */
-(BOOL)isEqual:(XYDeal *)object{
    return [object.deal_id isEqualToString:self.deal_id];
}
@end
