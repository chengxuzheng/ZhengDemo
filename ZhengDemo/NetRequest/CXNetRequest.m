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

+ (void)uploadWithData:(NSData *)data
          withMineType:(NSString *)mineType
    withInterfaceStyle:(CXNetRequestInterfaceStyle)style
         withInterface:(NSString *)interface
             withParam:(NSDictionary *)param
      withSuccessBlock:(void (^)(NSDictionary * _Nullable))success
        withErrorBlock:(void (^)(NSError * _Nonnull))failure {
    
    [CXNetRequest currentNetState:^(NSString *netStyle) {//netStyle WWAN或WIFI
        
        [CXNetRequest alertMessageWithNetStyle:netStyle withUseWWANNetUpload:^{
            [CXNetRequest showNetWorking];
            
            NSString *fullUrlStr = [CXNetRequest getFullUrlStrWithInterfaceStyle:style withInterface:interface];
            
            [_manager POST:fullUrlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDateFormatter *formatter = [NSDateFormatter new];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mineType];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
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
    }];
}


#pragma mark - 返回网络类型
+ (void)currentNetState:(void(^)(NSString *))netStyle {
    
    [_reachabilityManager startMonitoring];
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [CXNetRequest alertMessageWithNotReachable];
        } else {
            NSString *statusNameStr = (status == AFNetworkReachabilityStatusReachableViaWWAN)? @"WWAN": @"WIFI";
            netStyle(statusNameStr);
        }
    }];
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

#pragma mark - 弹窗提醒
#pragma mark 无网络
+ (void)alertMessageWithNotReachable {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kNetErrorTitle message:kNetErrorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:act];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark 是否在移动网络下载
+ (void)alertMessageWithNetStyle:(NSString *)style withUseWWANNetUpload:(void(^)())block {
    if ([style isEqualToString:@"WWAN"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"正在使用移动网络" message:@"是否使用移动网络进行上传" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:act1];
        UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block();
        }];
        [alert addAction:act2];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        block();
    }
}


@end
