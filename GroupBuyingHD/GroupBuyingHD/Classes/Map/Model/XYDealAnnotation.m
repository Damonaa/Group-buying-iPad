//
//  XYDealAnnotation.m
//  团购HD
//
//  Created by 李小亚 on 16/8/13.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDealAnnotation.h"

@implementation XYDealAnnotation


- (BOOL)isEqual:(XYDealAnnotation *)object{
    return self.coordinate.latitude == object.coordinate.latitude && self.coordinate.longitude == object.coordinate.longitude;
}
@end
