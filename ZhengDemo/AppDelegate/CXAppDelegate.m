//
//  AppDelegate.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXAppDelegate.h"
#import "CXRevealViewController.h"

#import <UserNotifications/UserNotifications.h>

#import "CXCuckoNavigtionController.h"
#import "CXCuckooHomeViewController.h"

#import "CXNetRequestManager.h"
#import "CXTouchIDManager.h"

@interface CXAppDelegate ()  <UNUserNotificationCenterDelegate>


@end

@implementation CXAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.revealVC = [CXRevealViewController revealController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.revealVC;
    [self.window makeKeyAndVisible];
    
//    CXCuckooHomeViewController *chVC = [[CXCuckooHomeViewController alloc] init];
//    CXCuckoNavigtionController *cNavVC = [[CXCuckoNavigtionController alloc] initWithRootViewController:chVC];
//    self.window.rootViewController = cNavVC;
    
    //注册通知
    [self authorizationNotification];
        
//    [CXNetRequestManager uploadWithInterfaceStyle:CXNetRequestInterfaceStyleDebug withMineType:@"" withData:[NSData new] withInterface:@"" withParam:nil withSuccessBlock:^(NSDictionary * _Nullable response) {
//        
//    } withErrorBlock:^(NSError * _Nonnull error) {
//        
//    }];
    
    
    [CXTouchIDManager openTouchIDWithLocalizedReason:@"启动" withFallBackTitle:@"确定" withSuccess:^{
        NSLog(@"成功");
    } withFailure:^{
        NSLog(@"失败");
    } withFallBack:^{
        NSLog(@"点击了输入密码");
    }];


    
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
        
}

#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

#pragma mark - 授权推送
- (void)authorizationNotification {
    if (IOS_VERSION_10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert +
                                                 UNAuthorizationOptionSound +
                                                 UIUserNotificationTypeBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  
                              }];
        
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
}


@end
