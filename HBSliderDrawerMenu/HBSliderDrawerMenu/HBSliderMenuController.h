//
//  HBSliderMenuController.h
//  HBSliderMenuDemo
//
//  Created by wangfeng on 15/8/5.
//  Copyright (c) 2015年 HustBroventure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSliderMenuController : UIViewController

@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, assign) UIStatusBarStyle preferredMenuStatusBarStyle;
    //左侧菜单VC
@property (nonatomic, strong) UIViewController* leftViewController;
    //主界面VC
@property (nonatomic, strong) UIViewController* mainVc;


    //初始化
-(instancetype)initWithLeftViewController:(UIViewController*)leftViewController mainViewController:(UIViewController*)mainViewController;

    //显示左侧菜单
- (void)showLeft;
    //显示主界面
- (void)showHome;

    //移除滑动手势
-(void)removePanGesture;
    //添加滑动手势
-(void)addPanGesture;


@end
