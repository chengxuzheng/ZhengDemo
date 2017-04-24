//
//  CXTimeActionView.h
//  ZhengDemo
//
//  Created by Zheng on 2017/4/22.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXTimeActionView : UIView

@property (nonatomic, assign) NSInteger timeSpacing; //程序终止间隔时间
@property (nonatomic, assign) CGFloat volume; //音量


/** 控制是否有音乐 **/
- (void)musicSettingsWithState:(BOOL)isHave;

@end
