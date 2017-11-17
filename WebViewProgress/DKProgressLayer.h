//
//  DKProgressLayer.h
//  WebViewProgress
//
//  Created by DK on 17/3/16.
//  Copyright © 2017年 DK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define DK_DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

/** 进度条风格 */
typedef NS_ENUM(NSUInteger, DKProgressStyle) {
    /** 默认风格 */
    DKProgressStyle_Noraml = 1 << 0,
    /** 渐变风格 */
    DKProgressStyle_Gradual = 1<< 1,
};

@interface DKProgressLayer : CAShapeLayer

/** 进度条显示风格 */
@property (nonatomic, assign) DKProgressStyle progressStyle;
/** 进度条颜色，默认白色 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 初始化进度条

 @param height 初始高度
 @return 进度条
 */
- (instancetype)initWithHeight:(CGFloat)height;

- (instancetype)initWithFrame:(CGRect)frame;

/**
 进度条开始加载
 */
- (void)progressAnimationStart;

/**
 进度条加载完成
 */
- (void)progressAnimationCompletion;

@end
