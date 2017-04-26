//
//  CXNetRequest.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/25.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXNetRequest.h"

typedef void(^RequestSuccessBlock)(NSDictionary *_Nullable param);
typedef void(^RequestErrorBlock)(NSError *_Nonnull error);

static NSString *const kNetErrorTitle = @"网络出错";
static NSString *const kNetErrorMessage = @"请检查您的网络是否可用";
static NSString *const kReleaseInterface = @"";
static NSString *const kDebugInterface = @"";
static AFHTTPSessionManager *_manager;
static AFNetworkReachabilityManager *_reachabilityManager;
//static NSCache *_cache;

@interface CXNetRequest ()

@end

@implementation CXNetRequest

+ (void)initialize {
    _manager = [AFHTTPSessionManager manager];
    _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [CXNetRequest defaultManager];
//    _cache = [[NSCache alloc] init];
}

+ (instancetype)defaultManager {
    static CXNetRequest *manager = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        manager = [[CXNetRequest alloc] init];
    });
    return manager;
}

+ (void)postWithInterfaceStyle:(CXNetRequestInterfaceStyle)style
                 withInterface:(NSString *)interface
                     withParam:(NSDictionary *)param
              withSuccessBlock:(void (^)(NSDictionary * _Nullable))success
                withErrorBlock:(void (^)(NSError * _Nonnull))failure {
    
    [CXNetRequest currentNetState:^(NSString *netStyle) {//netStyle WWAN或WIFI
        [CXNetRequest showNetWorking];
        
        NSString *fullUrlStr = [CXNetRequest getFullUrlStrWithInterfaceStyle:style withInterface:interface];
        
        [_manager POST:fullUrlStr parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [CXNetRequest hideNetWorking];
            NSMutableDictionary *newParam = [responseObject mutableCopy];
            [newParam setObject:netStyle forKey:kNetStyleKey];
            success([newParam copy]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CXNetRequest hideNetWorking];
            failure(error);
        }];
    }];
}

+ (void)getWithInterfaceStyle:(CXNetRequestInterfaceStyle)style
                withInterface:(NSString *)interface
                    withParam:(NSDictionary *)param
             withSuccessBlock:(void (^)(NSDictionary * _Nullable))success
               withErrorBlock:(void (^)(NSError * _Nonnull))failure {
    
    [CXNetRequest currentNetState:^(NSString *netStyle) {//netStyle WWAN或WIFI
        [CXNetRequest showNetWorking];
        
        NSString *fullUrlStr = [CXNetRequest getFullUrlStrWithInterfaceStyle:style withInterface:interface];
        
        [_manager GET:fullUrlStr parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [CXNetRequest hideNetWorking];
            NSMutableDictionary *newParam = [responseObject mutableCopy];
            [newParam setObject:netStyle forKey:kNetStyleKey];
            success([newParam copy]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CXNetRequest hideNetWorking];
            failure(error);
        }];
    }];
}


#pragma mark - 返回网络类型
+ (void)currentNetState:(void(^)(NSString *))netStyle {
    
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [CXNetRequest alertMessageWithNotReachable];
        } else {
            NSString *statusNameStr = (status == AFNetworkReachabilityStatusReachableViaWWAN)? @"WIFI": @"WWAN";
            netStyle(statusNameStr);
        }
    }];
    
    [_reachabilityManager startMonitoring];
}

#pragma mark - 获取测试或发布的域名
+ (NSString *)getInterfaceWithStyle:(CXNetRequestInterfaceStyle)style {
    return (style == CXNetRequestInterfaceStyleDebug)? kDebugInterface: kReleaseInterface;
}

#pragma mark - 获取完成的请求地址
+ (NSString *)getFullUrlStrWithInterfaceStyle:(CXNetRequestInterfaceStyle)style withInterface:(NSString *)interface {
    return  [[CXNetRequest getInterfaceWithStyle:style] stringByAppendingString:interface];
}

#pragma mark - 显示和隐藏状态栏网络加载
+ (void)showNetWorking {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)hideNetWorking {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - 无网络弹窗提醒
+ (void)alertMessageWithNotReachable {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kNetErrorTitle message:kNetErrorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:act];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


@end
