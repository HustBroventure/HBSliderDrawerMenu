//
//  HBCenterViewController.m
//  HBSliderDrawerMenu
//
//  Created by wangfeng on 15/11/8.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import "HBCenterViewController.h"
#import "HBSliderTopMenuController.h"
@interface HBCenterViewController ()

@end

@implementation HBCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = item;
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = item2;
}

-(void)leftClick
{
   HBSliderTopMenuController* slider =  ((HBSliderTopMenuController*) self.navigationController.parentViewController);
    

    [slider showLeftMenu];
}
-(void)rightClick
{
    HBSliderTopMenuController* slider =  ((HBSliderTopMenuController*) self.navigationController.parentViewController);
    
    
    [slider showRightMenu];
}


@end
