//
//  CXTimeActionView.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/22.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXTimeActionView.h"

#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

static const NSTimeInterval kMinTime = 10;
static const NSTimeInterval kMaxTime = 55;
static const NSTimeInterval kTimeInterval = 5;
static const NSTimeInterval kInitialTime = 25;

@interface CXTimeActionView () {
    UNUserNotificationCenter *_center;
}

@property (nonatomic, strong) UILabel *leftInfoLbl;
@property (nonatomic, strong) UILabel *timeTitleLbl;
@property (nonatomic, strong) UILabel *timeShowLbl;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIButton *timeActionBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVAudioPlayer *player;

#ifdef IOS_VERSION_10
@property (nonatomic, strong) UNMutableNotificationContent *content;
@property (nonatomic, strong) UNTimeIntervalNotificationTrigger *trigger;
@property (nonatomic, strong) UNNotificationRequest *request;
#else
@property (nonatomic, strong) UILocalNotification *localNotification; //本地通知
#endif

@property (nonatomic, assign) NSInteger tomatoTime; //番茄时间
@property (nonatomic, assign) NSInteger tomatoSeconds; //计时秒数
@property (nonatomic, assign) BOOL isFire; //定时器是否开启
@property (nonatomic, assign) NSInteger repeatCount; //重复次数

@end

@implementation CXTimeActionView

#pragma mark - 点击事件
#pragma mark 是否打开音乐
- (void)musicSettingsWithState:(BOOL)isHave {
    _player.volume = isHave? 0.5f: 0.0f;
}

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
    //TODO:  (关闭加减号点击)  应该打开
    if (!sender.selected) {
        [_segment setEnabled:NO forSegmentAtIndex:0];
        [_segment setEnabled:NO forSegmentAtIndex:1];
    }
    
    if (_tomatoSeconds != 0) {
#ifdef IOS_VERSION_10
        
        _trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:_tomatoSeconds repeats:NO];
        _request = [UNNotificationRequest requestWithIdentifier:@"kFinishTomatoTime" content:self.content trigger:_trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:_request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
#else
        
        self.localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:_tomatoSeconds];
        [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
#endif
    }

    if (sender.selected) {
        [self scaleTransformAnimationWithButton:sender withScale:1.15 withLastCount:NO];
    } else {
        _tomatoSeconds = _tomatoTime * 60;
        _isFire = YES;
        [self.player play];
        [self.timer fire];
        [_timeActionBtn setImage:kIMAGE(@"newStopButton") forState:UIControlStateNormal];
        sender.selected = !sender.selected;
    }
}

- (void)scaleTransformAnimationWithButton:(UIButton *)sender withScale:(CGFloat)scale withLastCount:(BOOL)isLastCount {
    
    _repeatCount ++;
    
    __block CGFloat newScale = scale;
    
    if (!isLastCount) {
        [UIView animateWithDuration:0.075 animations:^{
            sender.transform = CGAffineTransformMakeScale(newScale, newScale);
        } completion:^(BOOL finished) {
            
            if (newScale == 1) {
                newScale = 1.15;
            } else {
                newScale = 1;
            }
            
            BOOL isLastCount = (_repeatCount == 4)? YES: NO;
            
            [self scaleTransformAnimationWithButton:sender withScale:newScale withLastCount:isLastCount];
        }];
    } else {
        _repeatCount = 0;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"中断番茄" message:@"您确定要中断这个番茄吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_timeActionBtn setImage:kIMAGE(@"play_handwrite") forState:UIControlStateNormal];
            sender.selected = !sender.selected;
            [_timer invalidate];
            _timer = nil;
            _isFire = NO;
            _tomatoTime = 25;
            _tomatoSeconds = _tomatoTime * 60;
            _timeShowLbl.text = [NSString stringWithFormat:@"%ld分钟",_tomatoTime];
            [_player stop];
            [_segment setEnabled:YES forSegmentAtIndex:0];
            [_segment setEnabled:YES forSegmentAtIndex:1];
            
#pragma mark 删除本地通知
#ifdef IOS_VERSION_10
            [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
#else
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
#endif
        }];
        
        UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:act1];
        [alert addAction:act2];
        
        [self.viewController presentViewController:alert animated:YES completion:nil];
        
    }
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

#pragma mark - 接口值
- (void)setTimeSpacing:(NSInteger)timeSpacing {
    _timeSpacing = timeSpacing;
    if (_timeSpacing == 0) {
        _tomatoTime = kInitialTime;
        _tomatoSeconds = _tomatoTime * 60;
    } else {
        
    }
}

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    [self addSubviewsInView];
}

#pragma mark - Init Method
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _repeatCount = 0;
        _center = [UNUserNotificationCenter currentNotificationCenter];
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


#ifdef IOS_VERSION_10
- (UNMutableNotificationContent *)content {
    if (!_content) {
        _content = [[UNMutableNotificationContent alloc] init];
        _content.title = [NSString localizedUserNotificationStringForKey:@"番茄提示!" arguments:nil];
        _content.body = [NSString localizedUserNotificationStringForKey:@"完成了一个番茄钟" arguments:nil];
        _content.sound = [UNNotificationSound defaultSound];
    }
    return _content;
}

#else
- (UILocalNotification *)localNotification {
    if (!_localNotification) {
        _localNotification = [UILocalNotification new];
        _localNotification.alertTitle = @"番茄提示";
        _localNotification.alertBody = @"完成了一个番茄钟";
        _localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    return _localNotification;
}
#endif


- (AVAudioPlayer *)player {
    if (!_player) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"薛之谦 - 演员" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = -1;
        _player.volume = _volume;
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
        [_timeActionBtn setImage:kIMAGE(@"newStopButton") forState:UIControlStateSelected];
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
