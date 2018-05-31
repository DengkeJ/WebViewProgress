//
//  UIWebView+DKProgress.h
//  WebViewProgress
//
//  Created by DK on 2018/5/9.
//  Copyright © 2018年 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKProgressLayer;

@interface UIWebView (Progress)

@property (nonatomic, strong) DKProgressLayer *dk_progressLayer;
/** 是否显示加载进度条, 默认YES */
@property (nonatomic, assign) BOOL dk_showProgressLayer;

- (void)dk_showCustomProgressView;

@end
