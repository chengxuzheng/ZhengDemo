//
//  CXMainTabBarController.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/21.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXMainTabBarController.h"

typedef void(^MaskHiddenBlock)();

@interface CXMainTabBarController ()

@property (nonatomic, strong) UIView *maskView; //半透明遮挡视图
@property (nonatomic, copy) MaskHiddenBlock maskHiddenBlock; //遮罩动画完成回调

@end

@implementation CXMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.maskView];

}

#pragma mark - 设置遮罩层隐藏状态
- (void)changeMaskViewHiddenStateWithState:(PKRevealControllerState)state withFinishBlock:(void (^)())block {
    
    _maskHiddenBlock = block;
    
    [UIView animateWithDuration:kMASK_Duration animations:^{
        if (state == PKRevealControllerShowsLeftViewController) {
            _maskView.hidden = NO;
            _maskView.alpha = 0.25f;
        } else if (PKRevealControllerShowsFrontViewController) {
            _maskView.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        if (state == PKRevealControllerShowsFrontViewController) {
            _maskView.hidden = YES;
        }

        if (_maskHiddenBlock != nil && _maskHiddenBlock != NULL) {
            _maskHiddenBlock();
        }
    }];
}


#pragma mark - subviews
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor lightGrayColor];
        _maskView.alpha = 0.0f;
        _maskView.hidden = YES;
    }
    return _maskView;
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
