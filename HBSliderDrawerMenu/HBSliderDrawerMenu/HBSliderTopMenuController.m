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
#define ANIMIATION_TIME (0.3)


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
        //手势开始时，初始的位置
    CGFloat _orginX;
    BOOL _isShowLeft;
    BOOL _isShowRight;

}
#pragma mark - public methords
-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController mainViewController:(UIViewController *)mainViewController
{
    if (self = [super init]) {
        self.leftMenuViewController = leftViewController;
        self.rightMenuViewController = rightViewController;
        self.currentCenterViewController = mainViewController;
        self.view.backgroundColor = [UIColor redColor];

    }
    return self;
}
-(void)showLeftMenu
{
    
    [self.view insertSubview:self.leftView belowSubview:self.mainView];
    [self.mainView addSubview:self.coverView];
    CGRect frame = self.mainView.frame;
    frame.origin.x = _width*LEFT_OFFSET_FACTOR;

    [UIView animateWithDuration:ANIMIATION_TIME animations:^{
        self.mainView.frame = frame;
    } completion:^(BOOL finished) {

        
            }];
    _isShowLeft = YES;
}
-(void)showCenter
{
     _isShowLeft = NO;
    _isShowRight = NO;
    CGRect frame = self.mainView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:ANIMIATION_TIME animations:^{
        self.mainView.frame = frame;

    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
    }];
}
-(void)showRightMenu
{
    [self.view insertSubview:self.rightView belowSubview:self.mainView];
    [self.mainView addSubview:self.coverView];
    CGRect frame = self.mainView.frame;
    frame.origin.x = -_width*RIGHT_OFFSET_FACTOR;
    [UIView animateWithDuration:ANIMIATION_TIME animations:^{
        self.mainView.frame = frame;

    } completion:^(BOOL finished) {
    }];
    _isShowRight = YES;

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
    CGFloat deltaX = [panGesture translationInView:self.view].x;
    CGFloat ve = [panGesture velocityInView:self.view ].x;
    if (_orginX == 0 && deltaX > 0 ) {
        _isShowLeft = YES;
        [self.view insertSubview:self.leftView belowSubview:self.mainView];

    }
    else if(_orginX == 0 && deltaX < 0){
//        _isShowRight = YES;
//        [self.view insertSubview:self.rightView belowSubview:self.mainView];

    }
    if (panGesture.state == UIGestureRecognizerStateBegan) {
         _orginX = self.mainView.frame.origin.x;
    }else if(panGesture.state == UIGestureRecognizerStateEnded){
        if (1) {
            if (ve>0) {
                [self showLeftMenu];
            }else{
                [self showCenter];
            }
            
        }
//        if (_isShowLeft) {
//            [self showLeftMenu];
//        }
    }else{
        if (_isShowLeft) {
            CGRect frame = self.mainView.frame;
            frame.origin.x = _orginX + deltaX;
            if (frame.origin.x < 0 ) {
                frame.origin.x  = 0;
            }
            if (frame.origin.x > self.leftView.frame.size.width) {
                frame.origin.x = self.leftView.frame.size.width;
            }
            self.mainView.frame =  frame;

        }
//        if (_isShowRight) {
//            CGRect frame = self.mainView.frame;
//            frame.origin.x = _orginX + deltaX;
//            if (frame.origin.x < self.rightView.frame.size.width ) {
//                frame.origin.x =self.rightView.frame.size.width;
//            }
//            if (frame.origin.x > 0) {
//                frame.origin.x = 0;
//            }
//            self.mainView.frame =  frame;
//            
//        }

    }
}

#pragma mark - delegate methords
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
