//
//  WebViewController.h
//  WebViewProgress
//
//  Created by DK on 17/3/16.
//  Copyright © 2017年 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKProgressLayer.h"

@interface WebViewController : UIViewController

@property(nonatomic, assign) DKProgressStyle style;

/* 需要加载的URL地址 */
@property (nonatomic, strong) NSString *urlString;

@end
