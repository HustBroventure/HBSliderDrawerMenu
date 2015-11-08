//
//  HBSliderTopMenuController.m
//  hqd
//
//  Created by wangfeng on 15/10/30.
//  Copyright (c) 2015年 Mucfc. All rights reserved.
//

#import "HBSliderTopMenuController.h"
#define LEFT_MOVE_FACTOR (0.8)
#define RIGHT_MOVE_FACTOR (0.8)


@interface HBSliderTopMenuController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UIView* blackCoverView;
@property (nonatomic, strong) UIView* leftView;
@property (nonatomic, strong) UIView* rightView;

@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;
@end

@implementation HBSliderTopMenuController
{
    CGFloat _width;
    CGFloat _leftCenterXInLeft;
    CGFloat _rightCenterXInRight;
    CGFloat _leftCentrXInCenter;
    CGFloat _rightCenterXInCenter;
    
}
#pragma mark - public methords
-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController mainViewController:(UIViewController *)mainViewController
{
    if (self = [super init]) {
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
        self.mainViewController = mainViewController;

    }
    return self;
}
-(void)showLeft
{
    [self.mainView addSubview:self.blackCoverView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.center = CGPointMake(_leftCentrXInCenter , self.leftView.center.y);
        self.blackCoverView.alpha = 0.3;
        
    } completion:^(BOOL finished) {
            }];
}
-(void)showHome
{
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.center = CGPointMake(_leftCenterXInLeft , self.leftView.center.y);
        self.blackCoverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self.blackCoverView removeFromSuperview];
    }];
}
#pragma mark - vc-life-circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _width = self.view.frame.size.width;

    if (self.mainViewController) {
        self.mainView = self.mainViewController.view;
        [self addChildViewController:self.mainViewController];
        [self.view addSubview:self.mainView];
        [self.mainViewController didMoveToParentViewController:self];
    }
    if (self.leftViewController) {
        self.leftView = self.leftViewController.view;
        [self addChildViewController:self.leftViewController];
        self.leftView.frame = CGRectMake( - _width * LEFT_MOVE_FACTOR,0, _width * LEFT_MOVE_FACTOR, self.view.frame.size.height);
        [self.view addSubview:self.leftView];
        [self.leftViewController didMoveToParentViewController:self];
        
    }
    if (self.rightViewController) {
        self.rightView = self.rightViewController.view;
        [self addChildViewController:self.rightViewController];
        [self.view addSubview:self.rightView];
        [self.rightViewController didMoveToParentViewController:self];
        self.leftView.frame = CGRectMake( _width  , 0,_width * RIGHT_MOVE_FACTOR, self.view.frame.size.height);

    }
    
    
    _leftCenterXInLeft = - self.leftView.frame.size.width / 2;
    _rightCenterXInRight =  _width + self.rightView.frame.size.width / 2;
//    self.leftView.center = CGPointMake(_leftCenterXInLeft, self.leftView.center.y);
//    self.rightView.center = CGPointMake(_rightCenterXInRight, self.rightView.center.y);
    _leftCentrXInCenter = self.leftView.frame.size.width / 2;
    _rightCenterXInCenter= _width - self.rightView.frame.size.width / 2;

    
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHome)];
    self.tapGesture = tap;
    [self.mainView addGestureRecognizer:tap];
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
    pan.delegate = self;
    self.panGesture = pan;
        // [self.leftView addGestureRecognizer:pan];
    [self.mainView addGestureRecognizer:self.panGesture];

}


#pragma mark - private-tools methords

#pragma mark - property-setter-getter
-(UIView *)blackCoverView
{
    if (!_blackCoverView) {
        _blackCoverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _blackCoverView.backgroundColor = [UIColor blackColor];
        _blackCoverView.alpha = 0.0;
            //[_blackCoverView addGestureRecognizer:self.panGesture];
    }
    return _blackCoverView;
}

#pragma mark - event methords
-(void)panEvent:(UIPanGestureRecognizer*)panGesture
{
    static CGFloat startX;
    static CGFloat lastX;
    static CGFloat durationX;
    CGPoint touchPoint = [panGesture locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }else if(panGesture.state == UIGestureRecognizerStateChanged){
        CGFloat currentX = touchPoint.x;
        durationX = currentX - lastX;
        lastX = currentX;
        
        if (durationX > 0){
        }else{
            
        }
//        if (self.leftView.frame.origin.x + durationX >0 && durationX > 0){
//            return;
//        }
        
    
        float x = durationX + self.leftView.frame.origin.x;
        if (x > 0) {
            x = 0;
        }
        if (x < - _width*LEFT_MOVE_FACTOR) {
            x = - _width*LEFT_MOVE_FACTOR;
        }
        [self.leftView setFrame:CGRectMake(x, self.leftView.frame.origin.y, self.leftView.frame.size.width, self.leftView.frame.size.height)];
         CGFloat factor = -x / self.leftView.frame.size.width;
        self.blackCoverView.alpha = 0.3 *(1- factor);
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        CGFloat x = self.leftView.frame.origin.x;
        CGFloat factor = -x / self.leftView.frame.size.width;
        if (durationX > 0) {
            [UIView animateWithDuration:0.5*factor<0.25?0.25:0.5*factor animations:^{
                self.leftView.center = CGPointMake(_leftCentrXInCenter , self.leftView.center.y);
                self.blackCoverView.alpha = 0.3;
                
            } completion:^(BOOL finished) {
            }];
        }else{
            [UIView animateWithDuration:0.5 * (1-factor)<0.25?0.25:0.5 * (1-factor) animations:^{
                self.leftView.center = CGPointMake(_leftCenterXInLeft , self.leftView.center.y);
                self.blackCoverView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                [self.blackCoverView removeFromSuperview];
            }];

        }
    }
}

#pragma mark - delegate methords
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
