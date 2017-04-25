//
//  CXNetRequest.h
//  ZhengDemo
//
//  Created by Zheng on 2017/4/25.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CXNetRequestInterfaceStyle) {
    CXNetRequestInterfaceStyleDebug,
    CXNetRequestInterfaceStyleRelease
};

@interface CXNetRequest : NSObject

/**
 POST 请求

 @param interface 接口
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postWithInterfaceStyle:(CXNetRequestInterfaceStyle)style
                 withInterface:(nonnull NSString *)interface
                withParam:(nullable NSDictionary *)param
         withSuccessBlock:(void(^_Nonnull)(NSDictionary *_Nullable response))success
           withErrorBlock:(void(^_Nonnull)(NSError * _Nonnull error))failure;



@end
