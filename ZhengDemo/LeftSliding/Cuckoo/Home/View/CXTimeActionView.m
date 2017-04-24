//
//  CXTimeActionView.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/22.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXTimeActionView.h"

#import <AVFoundation/AVFoundation.h>

static const NSTimeInterval kMinTime = 10;
static const NSTimeInterval kMaxTime = 55;
static const NSTimeInterval kTimeInterval = 5;
static const NSTimeInterval kInitialTime = 25;

@interface CXTimeActionView ()

@property (nonatomic, strong) UILabel *leftInfoLbl;
@property (nonatomic, strong) UILabel *timeTitleLbl;
@property (nonatomic, strong) UILabel *timeShowLbl;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIButton *timeActionBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, assign) NSInteger tomatoTime; //番茄时间
@property (nonatomic, assign) NSInteger tomatoSeconds; //计时秒数
@property (nonatomic, assign) BOOL isFire; //定时器是否开启

@end

@implementation CXTimeActionView

#pragma mark - 点击事件
#pragma mark 加减时间
- (void)tomatoTimeIsChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        if (_tomatoTime == kMinTime) {
            [_segment setEnabled:NO forSegmentAtIndex:0];
        } else {
            if (_tomatoTime == kMaxTime+5) {
                [_segment setEnabled:YES forSegmentAtIndex:1];
            }
        }
        _tomatoTime -= kTimeInterval;
        _tomatoSeconds -= 300;
    } else {
        if (_tomatoTime == kMaxTime) {
            [_segment setEnabled:NO forSegmentAtIndex:1];
        } else {
            if (_tomatoTime == kMinTime-5) {
                [_segment setEnabled:YES forSegmentAtIndex:0];
            }
        }
        _tomatoTime += kTimeInterval;
        _tomatoSeconds += 300;
    }
    
    if (_isFire) {
        _timeShowLbl.text = [self getTimeSecondsStr];
    } else {
        _timeShowLbl.text = [NSString stringWithFormat:@"%ld分钟",_tomatoTime];
    }
    
    [UIView animateWithDuration:kANIMATION_DURATION/2 animations:^{
        _timeShowLbl.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kANIMATION_DURATION/2 animations:^{
            _timeShowLbl.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

#pragma mark 开始计时
- (void)timeActionBtnAction:(UIButton *)sender {
    _tomatoSeconds = _tomatoTime * 60;
    _isFire = YES;
    [self.player play];
    [self.timer fire];
}

#pragma mark 定时器
- (void)timerFired:(NSTimer *)t {
    if (_tomatoSeconds == 0) {
        [t invalidate];
        _timer = nil;
        _isFire = NO;
        _tomatoTime = 25;
        _tomatoSeconds = _tomatoTime * 60;
        [_player stop];
    } else {
        _tomatoSeconds--;
        _timeShowLbl.text = [self getTimeSecondsStr];
    }
}

- (NSString *)getTimeSecondsStr {
    NSString *timeStr = @"";
    if (_tomatoSeconds%60 < 10) {
        if (_tomatoSeconds/60 < 10) {
            timeStr = [NSString stringWithFormat:@"0%ld:0%ld",_tomatoSeconds/60,_tomatoSeconds%60];
        } else {
            timeStr = [NSString stringWithFormat:@"%ld:0%ld",_tomatoSeconds/60,_tomatoSeconds%60];
        }
    } else {
        if (_tomatoSeconds/60 < 10) {
            timeStr = [NSString stringWithFormat:@"0%ld:%ld",_tomatoSeconds/60,_tomatoSeconds%60];
        } else {
            timeStr = [NSString stringWithFormat:@"%ld:%ld",_tomatoSeconds/60,_tomatoSeconds%60];
        }
    }
    return timeStr;
}

#pragma mark - Init Method
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tomatoTime = kInitialTime;
        [self addSubviewsInView];
    }
    return self;
}

#pragma mark - Subviews
- (void)addSubviewsInView {
    
    [self addSubview:self.leftInfoLbl];
    [self addSubview:self.timeTitleLbl];
    [self addSubview:self.timeShowLbl];
    [self addSubview:self.segment];
    [self addSubview:self.timeActionBtn];
    
    [self layoutSubviewsInView];
}

- (AVAudioPlayer *)player {
    if (!_player) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"薛之谦 - 演员" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = -1;
        _player.volume = 0.5f;
        [_player prepareToPlay];
    }
    return _player;
}

- (void)layoutSubviewsInView {
    [_leftInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kCX_Scale(20));
        make.bottom.mas_equalTo(-kCX_Scale(20));
        make.width.mas_equalTo(kCX_Scale(90));
    }];
    
    [_timeTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftInfoLbl.mas_right).offset(kCX_Scale(15));
        make.width.mas_equalTo(kCX_Scale(65));
        make.height.mas_equalTo(kCX_Scale(24));
        make.top.equalTo(_leftInfoLbl).offset(kCX_Scale(3));
    }];
    
    [_timeShowLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.equalTo(_timeTitleLbl);
        make.top.equalTo(_timeTitleLbl.mas_bottom);
    }];
    
    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCX_Scale(90));
        make.height.mas_equalTo(kCX_Scale(27));
        make.centerY.equalTo(_timeTitleLbl.mas_bottom).offset(-kCX_Scale(3));
        make.right.mas_equalTo(-kCX_Scale(15));
    }];
    
    [_timeActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kCX_Scale(20));
        make.centerX.equalTo(self).multipliedBy(1.33);
        make.width.height.mas_equalTo(kCX_Scale(88));
    }];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:)userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (UIButton *)timeActionBtn {
    if (!_timeActionBtn) {
        _timeActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeActionBtn setImage:kIMAGE(@"play_handwrite") forState:UIControlStateNormal];
        [_timeActionBtn addTarget:self action:@selector(timeActionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeActionBtn;
}

- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"－",@"＋"]];
        _segment.tintColor = [UIColor lightGrayColor];
        _segment.momentary = YES;
        [_segment setTitleTextAttributes:@{NSFontAttributeName:kCX_FONT(21)} forState:UIControlStateNormal];
        [_segment addTarget:self action:@selector(tomatoTimeIsChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UILabel *)timeShowLbl {
    if (!_timeShowLbl) {
        _timeShowLbl = [[UILabel alloc] init];
        _timeShowLbl.text = [NSString stringWithFormat:@"%ld分钟",_tomatoTime];
        _timeShowLbl.font = kCX_FONT(13);
        _timeShowLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _timeShowLbl;
}

- (UILabel *)timeTitleLbl {
    if (!_timeTitleLbl) {
        _timeTitleLbl = [[UILabel alloc] init];
        _timeTitleLbl.text = @"番茄时间";
        _timeTitleLbl.font = kCX_FONT(12);
        _timeTitleLbl.textColor = [UIColor whiteColor];
        _timeTitleLbl.textAlignment = NSTextAlignmentCenter;
        _timeTitleLbl.backgroundColor = [UIColor blackColor];
    }
    return _timeTitleLbl;
}

- (UILabel *)leftInfoLbl {
    if (!_leftInfoLbl) {
        _leftInfoLbl = [[UILabel alloc] init];
        _leftInfoLbl.numberOfLines = 0;
        _leftInfoLbl.font = kCX_FONT(17);
        _leftInfoLbl.layer.borderColor = [[UIColor blackColor] CGColor];
        _leftInfoLbl.layer.borderWidth = 1;
        _leftInfoLbl.textAlignment = NSTextAlignmentCenter;
        
        _leftInfoLbl.attributedText = [self getTitleStr:@"TODAY\n0 mins\nPOMOS\nx 0\nDAY\nNo.1"];
    }
    return _leftInfoLbl;
}

#pragma mark - 获取左边信息栏字符串
- (NSMutableAttributedString *)getTitleStr:(NSString *)str {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentCenter;
    style1.lineSpacing = 7;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange([@"TODAY\n5 mins\nPOMOS\n" length], [@"x 1\n" length])];
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    style2.alignment = NSTextAlignmentCenter;
    style2.lineSpacing = 7;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange([@"TODAY\n" length], [@"5 mins\n" length])];
    return attStr;
}


@end
