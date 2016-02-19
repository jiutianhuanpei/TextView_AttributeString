//
//  RootViewController.m
//  TextView
//
//  Created by 沈红榜 on 16/2/18.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Post" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendPost:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

- (void)sendPost:(id)sender {
    ViewController *VC = [[ViewController alloc] init];
    [self.navigationController pushViewController:VC animated:true];
}

@end
