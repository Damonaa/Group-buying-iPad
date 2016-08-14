//
//  XYDealTool.h
//  团购HD
//
//  Created by 李小亚 on 16/8/1.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYSearchDealParam, XYSearchDealResult, XYGetSingleDealParam, XYGetSingleDealResult;

@interface XYDealTool : NSObject

/**
 *  搜索团购请求
 *
 *  @param param   请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)searchDealWithParam:(XYSearchDealParam *)param success:(void (^)(XYSearchDealResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  搜索指定团购请求
 *
 *  @param param   请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 */
+ (void)getSingleDealWithParam:(XYGetSingleDealParam *)param success:(void (^)(XYGetSingleDealResult *result))success failure:(void (^)(NSError *error))failure;

@end
