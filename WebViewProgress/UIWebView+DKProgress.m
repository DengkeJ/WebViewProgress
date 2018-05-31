//
//  UIWebView+DKProgress.m
//  WebViewProgress
//
//  Created by DK on 2018/5/9.
//  Copyright © 2018年 DK. All rights reserved.
//

#import "UIWebView+DKProgress.h"
#import <objc/runtime.h>
#import "DKProgressLayer.h"

static inline void dk_swizzleSelector(Class clazz, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(clazz, swizzledSelector);
    BOOL success = class_addMethod(clazz, originalSelector,method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@interface UIWebView ()

@property (nonatomic, strong) id dk_delegate;

@end

@implementation UIWebView (DKProgress)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        dk_swizzleSelector(class, @selector(initWithFrame:), @selector(dk_initWithFrame:));
        dk_swizzleSelector(class, @selector(initWithCoder:), @selector(dk_initWithCoder:));
        dk_swizzleSelector(class, @selector(setDelegate:), @selector(dk_setDelegate:));
        dk_swizzleSelector(class, NSSelectorFromString(@"dealloc"), @selector(dk_dealloc));
    });
}

- (DKProgressLayer *)dk_progressLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDk_progressLayer:(DKProgressLayer *)dk_progressLayer {
    if (dk_progressLayer && self.dk_progressLayer) {
        [self.dk_progressLayer removeFromSuperlayer];
        self.dk_progressLayer = nil;
    }
    objc_setAssociatedObject(self, @selector(dk_progressLayer), dk_progressLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dk_delegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDk_delegate:(id)dk_delegate {
    objc_setAssociatedObject(self, @selector(dk_delegate), dk_delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIWebViewDelegate>)dk_targetProxy {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDk_targetProxy:(id<UIWebViewDelegate>)dk_targetProxy {
    objc_setAssociatedObject(self, @selector(dk_targetProxy), dk_targetProxy, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)dk_showProgressLayer {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDk_showProgressLayer:(BOOL)dk_showProgressLayer {
    objc_setAssociatedObject(self, @selector(dk_showProgressLayer), @(dk_showProgressLayer), OBJC_ASSOCIATION_ASSIGN);
    if (dk_showProgressLayer) {
        [self setDelegate:self.dk_targetProxy];
    }
}

#pragma mark - method swizzling

- (instancetype)dk_initWithFrame:(CGRect)frame {
    UIWebView *webView = [self dk_initWithFrame:frame];
    /** 默认显示加载进度条 */
    webView.dk_showProgressLayer = YES;
    return webView;
}

- (instancetype)dk_initWithCoder:(NSCoder *)aDecoder {
    UIWebView *webView = [self dk_initWithCoder:aDecoder];
    /** 默认显示加载进度条 */
    webView.dk_showProgressLayer = YES;
    return webView;
}

- (void)dk_setDelegate:(id <UIWebViewDelegate>)delegate {
    self.dk_targetProxy = delegate;
    if (!self.dk_showProgressLayer) {
        [self dk_setDelegate:delegate];
        return;
    }
    /** 动态创建progressDelegate */
    Class clazz = [self dk_allocPorgressDelegate];

    if (!clazz) {
        [self dk_setDelegate:delegate];
        return;
    }

    id dk_delegate = [[clazz alloc] init];
    self.dk_delegate = dk_delegate;
    [self dk_setDelegate:dk_delegate];
}

- (void)dk_dealloc {
    if (self.dk_progressLayer) {
        [self.dk_progressLayer setHidden:YES];
        [self.dk_progressLayer removeFromSuperlayer];
    }
    self.dk_delegate = nil;
    [self dk_dealloc];
}

#pragma mark - private method

- (Class)dk_allocPorgressDelegate {
    const char * className;
    className = [@"DKProgressDelegate" UTF8String];
    Class clazz = objc_getClass(className);
    /** 判断此类是否已经存在，如果存在则返回，不存在就创建 */
    if (!clazz) {
        Class superClass = [NSObject class];
        clazz = objc_allocateClassPair(superClass, className, 0);
    }

    /** 为类添加成员变量\方法 */
    class_addMethod(clazz, @selector(webViewDidStartLoad:), (IMP)dk_webViewDidStartLoad, "V@:");
    class_addMethod(clazz, @selector(webViewDidFinishLoad:), (IMP)dk_webViewDidFinishLoad, "V@:");
    class_addMethod(clazz, @selector(webView:didFailLoadWithError:), (IMP)dk_webViewDidFailLoadWithError, "V@:");
    class_addMethod(clazz, @selector(webView:shouldStartLoadWithRequest:navigationType:), (IMP)dk_webViewShouldStartLoadWithRequestNavigationType, "V@:");

    /** 注册这个类到runtime系统 */
    objc_registerClassPair(clazz);
    return clazz;
}

#pragma mark - method custom implementation

static void dk_webViewDidStartLoad (id self, SEL _cmd, UIWebView *webView) {
    [webView.dk_progressLayer progressAnimationStart];
    if (webView.dk_targetProxy && [webView.dk_targetProxy respondsToSelector:_cmd]) {
        [webView.dk_targetProxy webViewDidStartLoad:webView];
    }
}

static inline void dk_webViewDidFinishLoad (id self, SEL _cmd, UIWebView *webView) {
    [webView.dk_progressLayer progressAnimationCompletion];
    if (webView.dk_targetProxy && [webView.dk_targetProxy respondsToSelector:_cmd]) {
        [webView.dk_targetProxy webViewDidFinishLoad:webView];
    }
}

static inline void dk_webViewDidFailLoadWithError (id self, SEL _cmd, UIWebView *webView, NSError *error) {
    [webView.dk_progressLayer progressAnimationCompletion];
    if (webView.dk_targetProxy && [webView.dk_targetProxy respondsToSelector:_cmd]) {
        [webView.dk_targetProxy webView:webView didFailLoadWithError:error];
    }
}

static inline BOOL dk_webViewShouldStartLoadWithRequestNavigationType (id self, SEL _cmd, UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType) {
    if (webView.dk_targetProxy && [webView.dk_targetProxy respondsToSelector:_cmd]) {
        return [webView.dk_targetProxy webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

@end
