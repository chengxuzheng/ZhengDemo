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

/** 网络类型 WIFI或WWAN **/
static NSString *_Nonnull const kNetStyleKey = @"netStyle";

@interface CXNetRequest : NSObject

/**
 POST 请求

 @param style 域名类型
 @param interface 接口Url
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)postWithInterfaceStyle:(CXNetRequestInterfaceStyle)style
                 withInterface:(nonnull NSString *)interface
                withParam:(nullable NSDictionary *)param
         withSuccessBlock:(void(^_Nonnull)(NSDictionary *_Nullable response))success
           withErrorBlock:(void(^_Nonnull)(NSError * _Nonnull error))failure;


/**
 Get 请求

 @param style 域名类型
 @param interface 接口Url
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getWithInterfaceStyle:(CXNetRequestInterfaceStyle)style
                withInterface:(nonnull NSString *)interface
                    withParam:(nullable NSDictionary *)param
             withSuccessBlock:(void(^_Nonnull)(NSDictionary *_Nullable response))success
               withErrorBlock:(void(^_Nonnull)(NSError * _Nonnull error))failure;


/**
 上传文件

 @param data 二进制数据
 @param style 域名类型
 @param interface 接口Url
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)uploadWithInterfaceStyle:(CXNetRequestInterfaceStyle)style
                    withMineType:(nonnull NSString *)mineType
                        withData:(nonnull NSData *)data
                   withInterface:(nonnull NSString *)interface
                       withParam:(nullable NSDictionary *)param
                withSuccessBlock:(void(^_Nonnull)(NSDictionary *_Nullable response))success
                  withErrorBlock:(void(^_Nonnull)(NSError * _Nonnull error))failure;



@end
