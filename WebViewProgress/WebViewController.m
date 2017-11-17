//
//  WebViewController.m
//  WebViewProgress
//
//  Created by DK on 17/3/16.
//  Copyright © 2017年 DK. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) DKProgressLayer *layer;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [[NSURL alloc] initWithString:_urlString];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    _layer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 40, DK_DEVICE_WIDTH, 4)];
    _layer.progressColor = [UIColor greenColor];
    _layer.progressStyle = _style;
    
    [self.navigationController.navigationBar.layer addSublayer:_layer];
    [self showCustomBackButton];
}

/** 显示自定义返回按钮 */
- (void)showCustomBackButton {
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, 35, 35);
    [customButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [customButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [customButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
}

/** 显示自定义title */
- (void)setCustomTitle:(NSString *)title {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleView.font = [UIFont boldSystemFontOfSize:17.0];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = title;
    self.navigationItem.titleView = titleView;
}

- (void)backAction:(UIButton *)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [_layer removeFromSuperlayer];
}

#pragma mark - WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_layer progressAnimationStart];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_layer progressAnimationCompletion];
    [self setCustomTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_layer progressAnimationCompletion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
