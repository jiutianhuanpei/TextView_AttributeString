//
//  RootViewController.m
//  TextView
//
//  Created by 沈红榜 on 16/2/18.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "SHBPostViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBtn:@"TempBtn" action:@selector(sendPost:) y:100];
    
    [self createBtn:@"发帖" action:@selector(goinPost) y:150];

}

- (UIButton *)createBtn:(NSString *)title action:(SEL)action y:(CGFloat)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2., y);
    [self.view addSubview:btn];
    return btn;
}

- (void)sendPost:(id)sender {
    ViewController *VC = [[ViewController alloc] init];
    [self.navigationController pushViewController:VC animated:true];
}

- (void)goinPost {
    SHBPostViewController *post = [[SHBPostViewController alloc] init];
    [self.navigationController pushViewController:post animated:true];
}

@end
