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

@property (nonatomic, strong) UIImageView *bgImgView; //背景图
@property (nonatomic, strong) CXTimeActionView *bTimeView; //底部时间视图
@property (nonatomic, strong) UIButton *voiceBtn; //音量
@property (nonatomic, strong) UIButton *guideBtn;
@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation CXCuckooHomeViewController

#pragma mark - Button Action
#pragma mark 声音
- (void)voiceBtnAction:(UIButton *)sender {
    [_bTimeView musicSettingsWithState:sender.selected];
    sender.selected = !sender.selected;
}

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _recordBtn.hidden = NO;
    _guideBtn.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _recordBtn.hidden = YES;
    _guideBtn.hidden = YES;
}

#pragma mark - Subviews
- (void)addSuviewsInView {
    [self.view addSubview:self.bTimeView];
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.voiceBtn];
    
    [self.navigationController.view addSubview:self.recordBtn];
    [self.navigationController.view addSubview:self.guideBtn];
    
    [self layoutSubviewsInView];
}

- (void)layoutSubviewsInView {
    [_bTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kCX_Scale(190));
    }];
    
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(_bTimeView.mas_top);
    }];
    
    [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCX_Scale(20));
        make.width.height.mas_equalTo(kCX_Scale(34));
        make.right.mas_equalTo(-kCX_Scale(25));
    }];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kCX_Scale(20));
        make.top.mas_equalTo(kCX_Scale(26));
        make.width.height.mas_equalTo(kCX_Scale(32));
    }];
    
    [_guideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_recordBtn.mas_left).offset(-kCX_Scale(20));
        make.top.width.height.equalTo(_recordBtn);
    }];
}

- (UIButton *)guideBtn {
    if (!_guideBtn) {
        _guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_guideBtn setImage:kIMAGE(@"tip") forState:UIControlStateNormal];
    }
    return _guideBtn;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:kIMAGE(@"archive_mini") forState:UIControlStateNormal];
    }
    return _recordBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:kIMAGE(@"soundEnabled") forState:UIControlStateNormal];
        [_voiceBtn setImage:kIMAGE(@"soundMute") forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:kIMAGE(@"timg")];
    }
    return _bgImgView;
}

- (CXTimeActionView *)bTimeView {
    if (!_bTimeView) {
        _bTimeView = [[CXTimeActionView alloc] init];
        NSDate *terminateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"kTerminateDate"];
        _bTimeView.timeSpacing = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSinceDate:terminateDate]].integerValue;
        _bTimeView.volume = _voiceBtn.selected? 0.0f: 0.5f;
    }
    return _bTimeView;
}

#pragma mark - 点击事件
- (void)backBarButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
