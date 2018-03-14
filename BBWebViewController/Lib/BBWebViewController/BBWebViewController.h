//
//  BBWebViewController.h
//  WkWebView
//
//  Created by 胡亚刚 on 2017/8/21.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBWebViewController : UIViewController
- (instancetype)initWithUrl:(NSURL *)webUrl;
- (instancetype)initWithUrlString:(NSString *)webUrlString;
@property (nonatomic,assign) BOOL hasToolBar;
@end
