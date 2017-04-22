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
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubviewInView];
    
//    __block NSInteger time = 1500;
//    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        time--;
//        
//        NSInteger minuteTime = time/60;
//        NSInteger secondTime = time%60;
//        
//        if (time > 0) {
//            kCX_LOG(@"%@", [NSString stringWithFormat:@"%ld:%ld",minuteTime,secondTime]);
//        } else {
//            
//        }
//    }];
//
//    NSTimer *myTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerFired:)userInfo:nil repeats:NO];
//    
//    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}



#pragma mark - Subviews
- (void)addSubviewInView {
    [self.view addSubview:self.maskView];
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

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
