//
//  XYDealTool.m
//  团购HD
//
//  Created by 李小亚 on 16/8/1.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDealTool.h"
#import "XYSearchDealParam.h"
#import "XYSearchDealResult.h"
#import "XYGetSingleDealParam.h"
#import "XYGetSingleDealResult.h"
#import "XYDPAPITool.h"


@implementation XYDealTool

/**
 *  搜索团购请求
 *
 *  @param param   请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)searchDealWithParam:(XYSearchDealParam *)param success:(void (^)(XYSearchDealResult *result))success failure:(void (^)(NSError *error))failure{
    [[XYDPAPITool shareDPAPI] requestWithURL:@"v1/deal/find_deals" params:param.mj_keyValues success:^(id json) {
        if (success) {
            XYSearchDealResult *result = [XYSearchDealResult mj_objectWithKeyValues:json];
            success(result);
        }
    } failure:failure];
}

/**
 *  搜索指定团购请求
 *
 *  @param param   请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)getSingleDealWithParam:(XYGetSingleDealParam *)param success:(void (^)(XYGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure{
    
    [[XYDPAPITool shareDPAPI] requestWithURL:@"v1/deal/get_single_deal" params:param.mj_keyValues success:^(id json) {
        if (success) {
            XYGetSingleDealResult *result = [XYGetSingleDealResult mj_objectWithKeyValues:json];
            success(result);
        }
    } failure:failure];
    
}

@end
