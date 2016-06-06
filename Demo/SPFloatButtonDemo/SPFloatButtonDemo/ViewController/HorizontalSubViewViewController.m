//
//  HorizontalSubViewViewController.m
//  Demo
//
//  Created by SMartP on 16/6/2.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import "HorizontalSubViewViewController.h"
#import "AppDelegate.h"

@interface HorizontalSubViewViewController ()

@end

@implementation HorizontalSubViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.normalView = [[NormalView alloc]initWithFrame:self.view.frame];
    self.view = self.normalView;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.floatButton.subButtonShowType = SubButtonShowTypeHorizontal;    //水平展开优先
    self.normalView.countLabel.text = [NSString stringWithFormat:@"%ld" , (long)[appDelegate.floatButton getSubFloatButtonCount]];
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
