//
//  CXTouchIDManager.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/27.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXTouchIDManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

typedef void(^TouchBlock)();

static LAContext *_context;
static NSString *_reason = @"通过Home键验证已有手机指纹";
static BOOL _isBiometrics;
static BOOL _isLockout;
static TouchBlock _success;
static TouchBlock _failure;
static TouchBlock _fallBack;



/**
 LAErrorSystemCancel            锁屏或切换到其他APP
 LAErrorUserCancel              取消验证
 LAErrorUserFallback            输入密码
 LAErrorPasscodeNotSet          未设置系统密码
 LAErrorAuthenticationFailed    验证失败
 LAErrorTouchIDNotEnrolled      TouchID不可用
 LAErrorTouchIDLockout          验证次数过多指纹验证被锁定
 */

@interface CXTouchIDManager ()


@end

@implementation CXTouchIDManager

+ (void)initialize {
    [CXTouchIDManager defaultManager];
    _context = [LAContext new];
    _isBiometrics = NO;
    _isLockout = NO;
}

+ (instancetype)defaultManager {
    static CXTouchIDManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CXTouchIDManager alloc] init];
    });
    return instance;
}

#pragma mark - 调用指纹验证
+ (void)openTouchID {
    
    LAPolicy policy = _isBiometrics? LAPolicyDeviceOwnerAuthenticationWithBiometrics:LAPolicyDeviceOwnerAuthentication;
    
    [_context evaluatePolicy:policy localizedReason:_reason reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            if (_isLockout) {
                _isBiometrics = YES;
            }
            _success();
            
        } else {
            switch (error.code) {
//                case LAErrorSystemCancel: {
//                    //锁屏或切换到其他APP
//                    
//                }
//                    break;
//                case LAErrorUserCancel: {
//                    //取消验证
//
//                }
//                    break;
                
                //系统样式下列无效 直接弹出密码验证
                    
                case LAErrorUserFallback: {
                    kDISPATCH_MAIN_THREAD(^{
                        _fallBack();
                    });
                }
                    break;
                case LAErrorAuthenticationFailed: {
                    kDISPATCH_MAIN_THREAD(^{
                        _failure();
                    });
                }
                    break;
                    
                case LAErrorTouchIDLockout: {
                    _isBiometrics = NO;
                    _isLockout = YES;
                    [CXTouchIDManager openTouchID];
                }
                    break;

                default: {
                    //其他
                }
                    break;
            }
        }
    }];
}

+ (void)openTouchIDWithLocalizedReason:(NSString *)reason
                     withFallBackTitle:(NSString *)title
                           withSuccess:(void (^)())success
                           withFailure:(void (^)())failure
                          withFallBack:(void (^ _Nonnull)())fallBack {
    _success = success;
    _failure = failure;
    _fallBack = fallBack;
    _context.localizedFallbackTitle = title;
    _reason = reason;
    _isBiometrics = YES;
    [CXTouchIDManager openTouchID];
}


#pragma mark - 验证设备是否支持TouchID
+ (BOOL)validationSupportBiometricsTouchID {
    NSError *error = nil;
    BOOL isCan = [_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    return isCan;
}



@end
