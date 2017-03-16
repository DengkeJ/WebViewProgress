//
//  ViewController.m
//  WebViewProgress
//
//  Created by DK on 17/3/16.
//  Copyright © 2017年 DK. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    WebViewController * destinationVC = segue.destinationViewController;
    destinationVC.urlString = @"https://www.baidu.com";
    if ([sender.currentTitle isEqualToString:@"纯色加载条"]) {
        destinationVC.style = DKProgressStyle_Noraml;
    } else {
        destinationVC.style = DKProgressStyle_Gradual;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
