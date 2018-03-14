//
//  YGWebToolBar.h
//  WkWebView
//
//  Created by HYG on 2018/2/2.
//  Copyright © 2018年 hu yagang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ToolActionType) {
    ToolActionTypeBack = 0,
    ToolActionTypeForward,
    ToolActionTypeRefresh
};

typedef void(^ToolAction)(UIButton *button,ToolActionType type);
@interface YGWebToolBar : UIView
- (void)canGoBack:(BOOL)isCan;
- (void)canGoForward:(BOOL)isCan;
- (void)refresh:(BOOL)complete;
@property (nonatomic,copy) ToolAction toolActionBlock;
- (void)webViewToolBarAction:(ToolAction)action;
@end
