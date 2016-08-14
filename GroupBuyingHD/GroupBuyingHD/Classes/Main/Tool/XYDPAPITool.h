//
//  XYDPAPITool.h
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYDPAPITool : NSObject

+ (instancetype)shareDPAPI;

/**
 *  请求获取数据
 *
 *  @param url     请求的URL
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
