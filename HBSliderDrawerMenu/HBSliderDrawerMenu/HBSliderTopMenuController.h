//
//  HBSliderTopMenuController.h
//  hqd
//
//  Created by wangfeng on 15/10/30.
//  Copyright (c) 2015年 Mucfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBSliderTopMenuController : UIViewController

@property (nonatomic, assign) UIStatusBarStyle preferredMenuStatusBarStyle;
    //左侧菜单VC
@property (nonatomic, strong) UIViewController* leftMenuViewController;
@property (nonatomic, strong) UIViewController* rightMenuViewController;
@property (nonatomic, strong) UIViewController* currentCenterViewController;

@property (nonatomic, strong) NSArray* contentViewControllersForLeft;
@property (nonatomic, strong) NSArray* contentViewControllersForRight;



    //初始化
-(instancetype)initWithLeftViewController:(UIViewController*)leftViewController rightViewController:(UIViewController*) rightViewController mainViewController:(UIViewController*)mainViewController;

    //显示左侧菜单
- (void)showLeftMenu;
- (void)showRightMenu;

    //显示主界面
- (void)showCenter;

    //移除滑动手势
-(void)removePanGesture;
    //添加滑动手势
-(void)addPanGesture;


@end
