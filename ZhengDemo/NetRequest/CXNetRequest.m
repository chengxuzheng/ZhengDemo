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

static RequestSuccessBlock _success;
static RequestErrorBlock _failure;
static NSString *const kNetErrorTitle = @"网络出错";
static NSString *const kNetErrorMessage = @"请检查您的网络是否可用";

@interface CXNetRequest ()

@end

@implementation CXNetRequest

+ (void)postWithInterface:(NSString *)interface
                withParam:(NSDictionary *)param
         withSuccessBlock:(void (^)(NSDictionary * _Nullable))success
           withErrorBlock:(void (^)(NSError * _Nonnull))failure {
    
    _success = success;
    _failure = failure;
    
    [CXNetRequest currentNetState:^(NSString *state) {
        if ([state isEqualToString:@"WWAN"]) {
            NSLog(@"蜂窝网络");
        } else if ([state isEqualToString:@"WIFI"]) {
            NSLog(@"WIFI");
        }
    }];
}

#pragma mark - 返回网络类型
+ (void)currentNetState:(void(^)(NSString *))state {
    
    [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    __block NSString *netStatus;
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                netStatus = @"WWAN";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netStatus = @"WIFI";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netStatus = @"NotReachable";
                break;
            default:
                break;
        }
        
        if ([netStatus isEqualToString:@"NotReachable"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:kNetErrorTitle message:kNetErrorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:act];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        } else {
            state(netStatus);
        }
        
    }];
    
    [reachabilityManager startMonitoring];
}




@end
