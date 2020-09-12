//
//  ViewController.m
//  LightWebCoreExample
//
//  Created by 宋航 on 2020/8/28.
//  Copyright © 2020 宋航. All rights reserved.
//

#import "ViewController.h"
#import <LightWebCore/LightWebCoreController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnEvent{
    LightWebCoreController *app = [[LightWebCoreController alloc] initWithURL:@"http://192.168.50.222:3000/app.zip?vfwe" isDev:YES withMaxRouter:5];
    [self presentViewController:app animated:YES completion:nil];
}
@end
