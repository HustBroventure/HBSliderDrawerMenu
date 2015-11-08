//
//  HBSliderDrawerMenuController.h
//  HBSliderDrawerMenu
//
//  Created by wangfeng on 15/11/8.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSliderDrawerMenuController : UIViewController
@property (nonatomic, assign) UIStatusBarStyle preferredMenuStatusBarStyle;
    //左侧菜单VC
@property (nonatomic, strong) UIViewController* leftViewController;
@property (nonatomic, strong) UIViewController* rightViewController;

    //主界面VC
@property (nonatomic, strong) UIViewController* mainViewController;


    //初始化
-(instancetype)initWithLeftViewController:(UIViewController*)leftViewController rightViewController:(UIViewController*) rightViewController mainViewController:(UIViewController*)mainViewController;

    //显示左侧菜单
- (void)showLeftMenu;
    //显示主界面
- (void)showCenterContent;
-(void)showRightMenu;

    //移除滑动手势
-(void)removePanGesture;
    //添加滑动手势
-(void)addPanGesture;

@end
