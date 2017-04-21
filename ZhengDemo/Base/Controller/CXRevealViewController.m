//
//  CXRevealViewController.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXRevealViewController.h"
#import "CXMainTabBarController.h"
#import "CXLeftSlidingViewController.h"

static CXMainTabBarController *_mainVC;
static CXLeftSlidingViewController *_leftSlidingVC;

@interface CXRevealViewController () <PKRevealing>

@property (nonatomic, assign) BOOL isStatusHidden;

@end

@implementation CXRevealViewController

+ (void)initialize {
    _mainVC = [[CXMainTabBarController alloc] init];
    _leftSlidingVC = [[CXLeftSlidingViewController alloc] init];
}

+ (instancetype)revealControllerWithFrontViewController:(UIViewController *)frontViewController leftViewController:(UIViewController *)leftViewController {
    return [super revealControllerWithFrontViewController:_mainVC leftViewController:_leftSlidingVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.animationDuration = kAnimation_Duration;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isStatusHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark PKRevealing代理方法
- (void)revealController:(PKRevealController *)revealController didChangeToState:(PKRevealControllerState)state{
    
    _isStatusHidden = (state == PKRevealControllerShowsFrontViewController)? NO: YES;
    
    [_mainVC changeMaskViewHiddenStateWithState:state withFinishBlock:^{
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation )preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden {
    return _isStatusHidden;
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
