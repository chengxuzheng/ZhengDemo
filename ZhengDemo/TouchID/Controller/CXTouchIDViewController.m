//
//  CXTouchIDViewController.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/27.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXTouchIDViewController.h"
#import "CXTouchIDManager.h"

@interface CXTouchIDViewController ()

@end

@implementation CXTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self touchID];
}

- (void)touchID {
    
    BOOL isCan = [CXTouchIDManager validationSupportBiometricsTouchID];
    if (isCan) {
        NSLog(@"TouchID 可以使用");
    } else {
        NSLog(@"TouchID 不可以使用");
    }
    
    [CXTouchIDManager openTouchIDWithLocalizedReason:@"启动" withFallBackTitle:@"确定" withSuccess:^{
        NSLog(@"验证成功");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } withFailure:^{
        NSLog(@"验证失败");
        [self touchID];
        
    } withFallBack:^{
        NSLog(@"点击了输入密码");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
