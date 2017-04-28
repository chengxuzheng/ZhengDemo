//
//  CXForceTouchManager.m
//  ZhengDemo
//
//  Created by Zheng on 2017/4/28.
//  Copyright © 2017年 Zheng. All rights reserved.
//

#import "CXForceTouchManager.h"

@interface CXForceTouchManager ()

@property (nonatomic, strong) NSMutableArray *shortcutCache; //缓存池

@end

@implementation CXForceTouchManager

+ (instancetype)defaultManager {
    static CXForceTouchManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CXForceTouchManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shortcutCache = [NSMutableArray new];
    }
    return self;
}

+ (BOOL)checkForceTouchCapabilityAvailable {
    if ([UIApplication sharedApplication].delegate.window.rootViewController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        return YES;
    }
    return NO;
}

+ (void)makeShortcutItems:(void (^)(CXForceTouchManager * _Nonnull))block {
    block([CXForceTouchManager defaultManager]);
}

- (CXForceTouchManager * _Nonnull (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nullable, NSString * _Nonnull))addItem {
    return ^(NSString *type,NSString *title,NSString *subtitle,NSString *imageName) {
        [self generateShortcutItemWithType:type withTitle:title withSubtitle:subtitle withImageName:imageName];
        return self;
    };
}

- (CXForceTouchManager * _Nonnull (^)())finished {
    return ^() {
        [self appAddShortcutItems];
        return self;
    };
}

- (void)generateShortcutItemWithType:(NSString *)type
                           withTitle:(NSString *)title
                        withSubtitle:(NSString *)subtitle
                       withImageName:(NSString *)imageName {
    
    if (_shortcutCache.count > 0) {
        for (UIApplicationShortcutItem *item in _shortcutCache) {
            if ([item.type isEqualToString:type]) {
                return;
            }
            if ([item.localizedTitle isEqualToString:title]) {
                return;
            }
            if ([item.localizedSubtitle isEqualToString:subtitle]) {
                return;
            }
        }
    }
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:imageName];
    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:type localizedTitle:title localizedSubtitle:subtitle icon:icon userInfo:nil];
    [_shortcutCache addObject:item];
    
}

- (void)appAddShortcutItems {
    [UIApplication sharedApplication].shortcutItems = [_shortcutCache copy];
}

+ (void)didSelectItemWithType:(NSString *)type {
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:type userInfo:@{@"type":type}];
}



@end
