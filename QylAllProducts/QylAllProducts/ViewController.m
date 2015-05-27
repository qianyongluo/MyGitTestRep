//
//  ViewController.m
//  QylAllProducts
//
//  Created by lqy on 15/5/22.
//  Copyright (c) 2015年 lqy. All rights reserved.
//

#import "ViewController.h"
#import "LBSViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 60)];
    [btn addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn setBackgroundColor:[UIColor purpleColor]];
}

- (void)mapClick:(id)sender{
    LBSViewController *vc = [[LBSViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
