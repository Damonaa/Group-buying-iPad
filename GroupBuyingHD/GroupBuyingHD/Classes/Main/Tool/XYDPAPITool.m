//
//  XYDPAPITool.m
//  团购HD
//
//  Created by 李小亚 on 16/7/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYDPAPITool.h"
#import "DPAPI.h"

@interface XYDPAPITool ()<DPRequestDelegate>

@property (nonatomic, strong) DPAPI *dpapi;

@end

@implementation XYDPAPITool

- (DPAPI *)dpapi{
    if (!_dpapi) {
        _dpapi = [[DPAPI alloc] init];
    }
    return _dpapi;
}

#pragma mark - 单例模式
static id _instance = nil;
+ (instancetype)shareDPAPI{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XYDPAPITool alloc] init];
    });
    
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

#pragma mark - 封装请求
/**
 *  NSMutableDictionary *params = [NSMutableDictionary dictionary];
 params[@"city"] = @"杭州";
 params[@"category"] = @"KTV";
 [self.dpapi requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
 */
- (void)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    DPRequest *request = [self.dpapi requestWithURL:url params:params delegate:self];
    request.success = success;
    request.failure = failure;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    if (request.failure) {
        request.failure(error);
//        NSLog(@"失败   %@", error);
    }
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    if (request.success) {
        request.success(result);
//        NSLog(@"成功  %@", result);
    }
    
}
@end
