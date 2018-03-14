//
//  ViewController.m
//  BBWebViewController
//
//  Created by HYG on 2018/3/14.
//  Copyright © 2018年 calmakon. All rights reserved.
//

#import "ViewController.h"
#import "BBWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 50);
    [button setTitle:@"加载网页" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadWeb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;
}

- (void)loadWeb {
    BBWebViewController * web = [[BBWebViewController alloc] initWithUrlString:@"http://www.jianshu.com/"];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
