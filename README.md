### WebViewProgress
    一款UIWebView的加载进度条，基于CAShapeLayer，现在支持两种显示风格：纯颜色进度条和渐变色进度条。

### 效果图
![image](https://github.com/jindk/WebViewProgress/blob/master/Images/Untitled1.gif)
![image](https://github.com/jindk/WebViewProgress/blob/master/Images/Untitled2.gif)

### 用法简介
    DKProgressLayer *layer1 = [DKProgressLayer alloc] initWithFrame:CGRectMake(0, 40, DEVICE_WIDTH, 2)];
    //设置进度条纯颜色显示
    layer.progressColor = [UIColor greenColor];
    //设置进度条的显示风格，默认纯色显示
    layer.progressStyle = DKProgressStyle_Noraml;
    
    DKProgressLayer *layer2 = [DKProgressLayer alloc] initWithFrame:CGRectMake(0, 40, DEVICE_WIDTH, 2) color:[UIColor greenColor]];
    //设置进度条为渐变色显示
    layer.progressStyle = DKProgressStyle_Gradual;
    //根据需求，可以添加到NavigationController或者WebView
    [self.navigationController.navigationBar.layer addSublayer:layer];
    
[简书地址] http://www.jianshu.com/u/1fc1bd217dc5
