//
//  CXTimeActionView.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/22.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXTimeActionView.h"

@interface CXTimeActionView ()

@property (nonatomic, strong) UILabel *leftInfoLbl;
@property (nonatomic, strong) UILabel *timeTitleLbl;
@property (nonatomic, strong) UILabel *timeShowLbl;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIButton *timeActionBtn;

@property (nonatomic, assign) NSInteger tomatoTime; //番茄时间

@end

@implementation CXTimeActionView

#pragma mark - 点击事件
#pragma mark 加减时间
- (void)tomatoTimeIsChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        if (_tomatoTime == 5) {
            [_segment setEnabled:NO forSegmentAtIndex:0];
        } else {
            if (_tomatoTime == 60) {
                [_segment setEnabled:YES forSegmentAtIndex:1];
            }
            _tomatoTime -= 5;
        }
    } else {
        if (_tomatoTime == 60) {
            [_segment setEnabled:NO forSegmentAtIndex:1];
        } else {
            if (_tomatoTime == 5) {
                [_segment setEnabled:YES forSegmentAtIndex:0];
            }
            _tomatoTime += 5;
        }
    }
    _timeShowLbl.text = [NSString stringWithFormat:@"%ld分钟",_tomatoTime];
}

#pragma mark - Init Method
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tomatoTime = 25;
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
        make.height.mas_equalTo(kCX_Scale(25));
        make.centerY.equalTo(_timeTitleLbl.mas_bottom).offset(-kCX_Scale(3));
        make.right.mas_equalTo(-kCX_Scale(15));
    }];
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

        NSString *titleStr = @"TODAY\n0 mins\nPOMOS\nx 0\nDAY\nNo.1";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
        style1.alignment = NSTextAlignmentCenter;
        style1.lineSpacing = 7;
        [attStr addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange([@"TODAY\n5 mins\nPOMOS\n" length], [@"x 1\n" length])];
        NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
        style2.alignment = NSTextAlignmentCenter;
        style2.lineSpacing = 7;
        [attStr addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange([@"TODAY\n" length], [@"5 mins\n" length])];
        
        _leftInfoLbl.attributedText = attStr;
        
    }
    return _leftInfoLbl;
}


@end
