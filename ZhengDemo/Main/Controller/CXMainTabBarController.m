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


@property (nonatomic, strong) UILabel *label;

@end

@implementation CXMainTabBarController

#pragma mark - 设置遮罩层隐藏状态
- (void)changeMaskViewHiddenStateWithState:(PKRevealControllerState)state withFinishBlock:(void (^)())block {
    
    _maskHiddenBlock = block;
    
    [UIView animateWithDuration:kMASK_Duration animations:^{
        if (state == PKRevealControllerShowsLeftViewController) {
            _maskView.hidden = NO;
            _maskView.alpha = kTRANSLUCENT_ALPHA;
        } else if (PKRevealControllerShowsFrontViewController) {
            _maskView.alpha = kZERO_ALPHA;
        }
    } completion:^(BOOL finished) {
        if (state == PKRevealControllerShowsFrontViewController) {
            _maskView.hidden = !_maskView.hidden;
        }
        
        if (_maskHiddenBlock != nil && _maskHiddenBlock != NULL) {
            _maskHiddenBlock();
        }
    }];
}


#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];

    [self addSubviewInView];
}


#pragma mark - Subviews
- (void)addSubviewInView {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.label];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor lightGrayColor];
        _maskView.alpha = kZERO_ALPHA;
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 375, 30)];
        _label.text = @"右滑出现侧边栏";
    }
    return _label;
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
