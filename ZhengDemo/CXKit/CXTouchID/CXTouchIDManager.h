//
//  CXTouchIDManager.h
//  ZhengDemo
//
//  Created by Zheng on 2017/4/27.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXTouchIDManager : NSObject


/** 验证TouchID是否可用 **/
+ (BOOL)validationSupportBiometricsTouchID;


/** 开启TouchID验证和密码验证 系统样式**/
+ (void)openTouchID;


/**
 开启TouchID验证
 
 @param reason 使用Touch的描述
 @param title fallback按钮的标题
 @param success 成功回调
 @param failure 失败回调
 @param fallBack fallback回调
 */
+ (void)openTouchIDWithLocalizedReason:(nonnull NSString *)reason
                     withFallBackTitle:(nonnull NSString *)title
                           withSuccess:(void(^_Nonnull)())success
                           withFailure:(void(^_Nonnull)())failure
                          withFallBack:(void(^_Nonnull)())fallBack;



@end
