### WebViewProgress
    一款UIWebView的加载进度条，基于CAShapeLayer，有两种显示风格：纯颜色显示和渐变色显示。

### 效果图
![image](https://github.com/jindk/WebViewProgress/blob/master/Images/Untitled1.gif)
![image](https://github.com/jindk/WebViewProgress/blob/master/Images/Untitled2.gif)

### 用法简介
    DKProgressLayer *layer = [DKProgressLayer new];
    //设置进度条显示的颜色，默认白色
    layer.progressColor = [UIColor greenColor];
    //设置进度条的显示风格，默认纯色显示
    layer.progressStyle = DKProgressStyle;
    layer.frame = CGRectMake(0, 40, DEVICE_WIDTH, 2);
    //根据需求，可以添加到NavigationController或者WebView
    [self.navigationController.navigationBar.layer addSublayer:layer];
