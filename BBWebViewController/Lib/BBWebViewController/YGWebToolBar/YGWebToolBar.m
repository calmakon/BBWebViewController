//
//  YGWebToolBar.m
//  WkWebView
//
//  Created by HYG on 2018/2/2.
//  Copyright © 2018年 hu yagang. All rights reserved.
//

#import "YGWebToolBar.h"

#define kBundleName @ "YGWebView.bundle"

#define kImageBundle [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: kBundleName]]

#define ToolImage(name) [UIImage imageWithContentsOfFile:[[kImageBundle resourcePath] stringByAppendingPathComponent:name]]

#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXBottomHeight 34
#define ToolBarHeight (isiPhoneX?78:44)
#define ItemWidth 44
#define APP_NAVIGATIONBAR_H (isiPhoneX?88:64)


@interface YGWebToolBar ()

@property (nonatomic,strong) UIButton * backButton;
@property (nonatomic,strong) UIButton * forwardButton;
@property (nonatomic,strong) UIButton * refreshButton;

@end

@implementation YGWebToolBar

- (instancetype)init {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ToolBarHeight);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        [self layout];
    }
    return self;
}

- (void)layout {

    self.backButton.frame = CGRectMake(0, 0, ItemWidth, ItemWidth);
    self.forwardButton.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame)+ 5, 0, ItemWidth, ItemWidth);
    self.refreshButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - ItemWidth, 0, ItemWidth, ItemWidth);
}

- (void)webViewToolBarAction:(ToolAction)action {

    self.toolActionBlock = action;
}

- (void)webViewGoBack {
    if (self.toolActionBlock) {
        self.toolActionBlock(self.backButton,ToolActionTypeBack);
    }
}

- (void)webViewGoForward {
    if (self.toolActionBlock) {
        self.toolActionBlock(self.forwardButton,ToolActionTypeForward);
    }
}

- (void)webViewRefresh {
    if (self.toolActionBlock) {
        self.toolActionBlock(self.refreshButton,ToolActionTypeRefresh);
    }
}

- (void)canGoBack:(BOOL)isCan {

    if (isCan) {

        [self.backButton setImage:ToolImage(@"toolbar_goback_normal") forState:UIControlStateNormal];
    }else {
        [self.backButton setImage:ToolImage(@"toolbar_goback_highlighted.png@2x") forState:UIControlStateNormal];
    }
}

- (void)canGoForward:(BOOL)isCan {

    if (isCan) {
        [self.forwardButton setImage:ToolImage(@"toolbar_goforward_normal") forState:UIControlStateNormal];
    }else {
        [self.forwardButton setImage:ToolImage(@"video_download_more") forState:UIControlStateNormal];
    }
}

- (void)refresh:(BOOL)complete {

    if (complete) {
        [self.refreshButton setImage:ToolImage(@"toolbar_refresh_normal") forState:UIControlStateNormal];
    }else {
        [self.refreshButton setImage:ToolImage(@"toolbar_refresh_normal") forState:UIControlStateNormal];
    }
}

- (UIButton *)backButton {

    if (!_backButton) {
        _backButton = [self configButton:@"toolbar_goback_highlighted.png@2x" selector:@selector(webViewGoBack)];
    }
    return _backButton;
}

- (UIButton *)forwardButton {

    if (!_forwardButton) {
        _forwardButton = [self configButton:@"video_download_more@2x" selector:@selector(webViewGoForward)];
    }
    return _forwardButton;
}

- (UIButton *)refreshButton {

    if (!_refreshButton) {
        _refreshButton = [self configButton:@"toolbar_refresh_normal@2x" selector:@selector(webViewRefresh)];
    }
    return _refreshButton;
}

- (UIButton *)configButton:(NSString *)imageName selector:(SEL)selector {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:ToolImage(imageName) forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

    return button;
}

@end

