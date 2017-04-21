//
//  CXMainTabBarController.h
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXMainTabBarController : UITabBarController

- (void)changeMaskViewHiddenStateWithState:(PKRevealControllerState)state withFinishBlock:(void(^)())block;


@end
