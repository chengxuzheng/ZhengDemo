//
//  CXTouchIDManager.h
//  ZhengDemo
//
//  Created by Zheng on 2017/4/27.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXTouchIDManager : NSObject

/** 开启指纹验证和密码验证 系统样式**/
+ (void)openTouchID;



/**
 <#Description#>

 @param reason <#reason description#>
 @param title <#title description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)openTouchIDWithLocalizedReason:(nonnull NSString *)reason
                     withFallBackTitle:(nonnull NSString *)title
                           withSuccess:(void(^_Nonnull)())success
                           withFailure:(void(^_Nonnull)())failure
                          withFallBack:(void(^_Nonnull)())fallBack;

@end
