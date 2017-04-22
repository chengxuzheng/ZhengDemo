//
//  CXCuckooHomeViewController.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/22.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXCuckooHomeViewController.h"

#import "CXTimeActionView.h"

@interface CXCuckooHomeViewController ()

@property (nonatomic, strong) CXTimeActionView *bTimeView; //底部时间视图

@end

@implementation CXCuckooHomeViewController

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.title = @"番茄计时";
    NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                    NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributesDic];
    self.navigationController.navigationBar.translucent = NO;
    [self showBackButtonWithImage:@"square-menu"];
    
    [self addSuviewsInView];
}

#pragma mark - Subviews
- (void)addSuviewsInView {
    [self.view addSubview:self.bTimeView];
    
    [self layoutSubviewsInView];
}

- (void)layoutSubviewsInView {
    [_bTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kCX_Scale(190));
    }];
}

- (CXTimeActionView *)bTimeView {
    if (!_bTimeView) {
        _bTimeView = [[CXTimeActionView alloc] init];
    }
    return _bTimeView;
}

#pragma mark - 点击事件
- (void)backBarButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
