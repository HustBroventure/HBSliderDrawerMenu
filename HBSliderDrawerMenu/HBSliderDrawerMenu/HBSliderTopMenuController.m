//
//  HBSliderTopMenuController.m
//  hqd
//
//  Created by wangfeng on 15/10/30.
//  Copyright (c) 2015年 Mucfc. All rights reserved.
//

#import "HBSliderTopMenuController.h"
#define LEFT_OFFSET_FACTOR (0.8)
#define RIGHT_OFFSET_FACTOR (0.8)
#define ANIMIATION_TIME (0.5)


@interface HBSliderTopMenuController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UIView* leftView;
@property (nonatomic, strong) UIView* rightView;

@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;

@property (nonatomic, strong) UIView* coverView;
@end

@implementation HBSliderTopMenuController
{
    CGFloat _width;
    CGFloat _leftOffset;
    CGFloat _rightoffset;

}
#pragma mark - public methords
-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController mainViewController:(UIViewController *)mainViewController
{
    if (self = [super init]) {
        self.leftMenuViewController = leftViewController;
        self.rightMenuViewController = rightViewController;
        self.currentCenterViewController = mainViewController;

    }
    return self;
}
-(void)showLeftMenu
{
    [self.mainView addSubview:self.coverView];
    CGRect frame = self.mainView.frame;
    frame.origin.x = _width*LEFT_OFFSET_FACTOR;

    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame = frame;
    } completion:^(BOOL finished) {


            }];
}
-(void)showCenter
{
    CGRect frame = self.mainView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame = frame;

    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}
-(void)showRight
{
    CGRect frame = self.mainView.frame;
    frame.origin.x = -_width*RIGHT_OFFSET_FACTOR;
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.frame = frame;


    } completion:^(BOOL finished) {
    }];
}

#pragma mark - vc-life-circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _width = self.view.frame.size.width;
    self.mainView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainView];
    self.mainView.backgroundColor = [UIColor clearColor];

    if (self.leftMenuViewController) {
        [self addChildViewController:self.leftMenuViewController];
        self.leftMenuViewController.view.frame = CGRectMake(0, 0,_width * LEFT_OFFSET_FACTOR, self.view.frame.size.height);
        self.leftView =  self.leftMenuViewController.view;
        [self.view addSubview:self.leftView];
        [self.leftMenuViewController didMoveToParentViewController:self];

    }
    if (self.rightMenuViewController) {
        [self addChildViewController:self.rightMenuViewController];
        self.rightMenuViewController.view.frame = CGRectMake(_width*(1-RIGHT_OFFSET_FACTOR), 0,_width * RIGHT_OFFSET_FACTOR, self.view.frame.size.height);
        self.rightView =  self.rightMenuViewController.view;
        [self.view addSubview:self.rightView];
        [self.rightMenuViewController didMoveToParentViewController:self];
    }

    if (self.currentCenterViewController) {
        [self addChildViewController:self.currentCenterViewController];
        self.currentCenterViewController.view.frame = self.view.bounds;
        [self.mainView addSubview: self.currentCenterViewController.view];
        [self.view addSubview:self.mainView];
        [self.currentCenterViewController didMoveToParentViewController:self];

    }
    [self.view bringSubviewToFront:self.mainView];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCenter)];
    self.tapGesture = tap;
    [self.coverView addGestureRecognizer:tap];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
    pan.delegate = self;
    self.panGesture = pan;
        // [self.leftView addGestureRecognizer:pan];
    [self.mainView addGestureRecognizer:self.panGesture];

}


#pragma mark - private-tools methords

#pragma mark - property-setter-getter
-(UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}
-(void)setCurrentCenterViewController:(UIViewController *)currentCenterViewController
{
    if (!currentCenterViewController) {
        return;
    }

    [_currentCenterViewController willMoveToParentViewController:nil];
    [_currentCenterViewController.view removeFromSuperview];
    [_currentCenterViewController removeFromParentViewController];


    [self addChildViewController:currentCenterViewController];
    currentCenterViewController.view.frame = self.view.bounds;
    [self.mainView addSubview:currentCenterViewController.view];
    [currentCenterViewController didMoveToParentViewController:self];
    _currentCenterViewController = currentCenterViewController;

}
#pragma mark - event methords
-(void)panEvent:(UIPanGestureRecognizer*)panGesture
{

}

#pragma mark - delegate methords
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
