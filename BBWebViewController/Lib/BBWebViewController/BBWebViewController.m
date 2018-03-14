//
//  BBWebViewController.m
//  WkWebView
//
//  Created by 胡亚刚 on 2017/8/21.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import "BBWebViewController.h"
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>
#import "YGWebToolBar.h"

@interface BBWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) YGWebToolBar * toolBar;
@property (nonatomic,strong) NSURL * webUrl;
@property (nonatomic,assign) CGFloat offsetY;
@end

@implementation BBWebViewController

- (instancetype)initWithUrl:(NSURL *)webUrl {
    NSAssert(webUrl, @"=====地址为空=====");
    self = [super init];
    if (self) {
        _webUrl = webUrl;
        self.hasToolBar = YES;
        [self addObserver];
        [self loadRequest];
    }
    return self;
}

- (instancetype)initWithUrlString:(NSString *)webUrlString {
    BOOL isUrlNil = !webUrlString || webUrlString.length == 0;
    NSAssert(!isUrlNil, @"=====地址为空=====");
    self = [super init];
    if (self) {
        _webUrl = [NSURL URLWithString:webUrlString];
        self.hasToolBar = YES;
        [self addObserver];
        [self loadRequest];
    }
    return self;
}

- (void)loadRequest {
    [self.webView loadRequest:[NSURLRequest requestWithURL:_webUrl]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.hasToolBar) return;
    __weak typeof(self) weakSelf = self;
    [self.toolBar webViewToolBarAction:^(UIButton *button, ToolActionType type) {
        if (type == ToolActionTypeBack) {
            [weakSelf webViewGoBack];
        }
        if (type == ToolActionTypeForward) {
            [weakSelf webViewGoForward];
        }
        if (type == ToolActionTypeRefresh) {
            [weakSelf webViewRefresh];
        }
    }];
}

- (void)webViewGoBack {

    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)webViewGoForward {

    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)toolBarReset:(BOOL)canGoBack goForward:(BOOL)canGoForward {

    [self.toolBar canGoBack:canGoBack];
    [self.toolBar canGoForward:canGoForward];
}

- (void)webViewRefresh {

    [self.webView reload];
}

- (void)addObserver {

    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"loading"]) {
        //NSLog(@"loading");

    } else if ([keyPath isEqualToString:@"title"]) {

        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.webView.estimatedProgress == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                self.progressView.alpha = 0;
            }];
        }else {
            self.progressView.alpha = 1;
        }
    }

    if (!self.webView.loading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }else {
        self.progressView.alpha = 1;
    }
}

#pragma mark -scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.offsetY && scrollView.contentOffset.y > 0) {//向上滑动
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, self.toolBar.bounds.size.height);
        }];
    }else if (scrollView.contentOffset.y < self.offsetY ){//向下滑动
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    self.offsetY = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

#pragma mark -webViewDelegate
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {

    //NSLog(@"接收到服务器跳转请求之后调用");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {

    //NSLog(@"在收到响应后，决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self toolBarReset:webView.canGoBack goForward:webView.canGoForward];
    [self.toolBar refresh:NO];
    //NSLog(@"在发送请求之前，决定是否跳转");

//    NSString *url = navigationAction.request.URL.absoluteString;
//    NSLog(@"即将加载的网址：%@",url);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//警告框函数
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"调用alert提示框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    //NSLog(@"alert message:%@",message);
}
//确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:@"调用confirm提示框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];

    //NSLog(@"confirm message:%@", message);
}
//输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:@"调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];

    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {


}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self toolBarReset:webView.canGoBack goForward:webView.canGoForward];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self toolBarReset:webView.canGoBack goForward:webView.canGoForward];
    [self.toolBar refresh:YES];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self toolBarReset:webView.canGoBack goForward:webView.canGoForward];
    [self.toolBar refresh:YES];
}

#pragma mark -getter
- (WKWebView *)webView {

    if (!_webView) {

        WKWebViewConfiguration * config = [WKWebViewConfiguration new];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;

        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        [self.view addSubview:_webView];
        [self.view sendSubviewToBack:_webView];
    }
    return _webView;
}

- (YGWebToolBar *)toolBar {

    if (!_toolBar) {
        _toolBar = [YGWebToolBar new];
        [self.view addSubview:_toolBar];
        _toolBar.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - _toolBar.bounds.size.height / 2.0f);
    }
    return _toolBar;
}

- (UIProgressView *)progressView {

    if (!_progressView) {
        CGFloat y = 0;
        if (self.navigationController.navigationBar.isHidden == NO) {
            y = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
        }
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, 5)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor greenColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark -setter
- (void)setHasToolBar:(BOOL)hasToolBar {
    _hasToolBar = hasToolBar;
    if (!_toolBar) {
        _toolBar.hidden = !hasToolBar;
    }
}

- (void)dealloc {

    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    _webView.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
