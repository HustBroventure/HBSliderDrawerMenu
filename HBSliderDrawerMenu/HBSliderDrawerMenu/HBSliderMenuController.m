//
//  HBSliderMenuController.m
//  HBSliderMenuDemo
//
//  Created by wangfeng on 15/8/5.
//  Copyright (c) 2015年 HustBroventure. All rights reserved.
//

#import "HBSliderMenuController.h"

@interface HBSliderMenuController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UIView* blackCover;
@property (nonatomic, strong) UIView* leftView;
    //滑动时的透明遮罩
@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, strong) UITapGestureRecognizer* tap;
@property (nonatomic, strong) UIPanGestureRecognizer* pan;
@end

@implementation HBSliderMenuController
{
    CGFloat _distance ;//0
    CGFloat _fullDistance;//0.78
    CGFloat _proportion;//0.77
    
    CGPoint _centerOfLeftViewAtBeginning;
    CGFloat _proportionOfLeftView;// CGFloat = 1
    CGFloat _distanceOfLeftView;// CGFloat = 50
    
    BOOL _leftViewIsShow;
}
#pragma mark - public methord
-(instancetype)initWithLeftViewController:(UIViewController*)leftViewController mainViewController:(UIViewController*)mainViewController
{
    if (self = [super init]) {
        self.leftViewController = leftViewController;
        self.mainVc = mainViewController;
        
    }
    return self;
}
-(void)removePanGesture
{
    [self.mainView removeGestureRecognizer:self.pan];
}
-(void)addPanGesture
{
     [self.mainView addGestureRecognizer:self.pan];
}
- (void)showLeft
{
    [self showLeftWithFactor:1];
}
    //显示主界面
- (void)showHome
{
    [self showHomeWithFactor:1];

}
- (void)showLeftWithFactor:(CGFloat)factor
{
    [self addMaskView];
    [self.mainView addGestureRecognizer:self.tap];
    _distance = self.view.center.x * (_fullDistance*2 + _proportion - 1);
    [self doTheAnimate:_proportion type:0 andTime:0.3 * factor];
    [self statusBarNeedsAppearanceUpdate];
}
- (void)showHomeWithFactor:(CGFloat)factor
{
    [self.mainView  removeGestureRecognizer:self.tap];
    _distance = 0;
    [self doTheAnimate:1 type:1 andTime:0.3 * factor];
    [self.maskView removeFromSuperview];
    [self statusBarNeedsAppearanceUpdate];
}

#pragma mark - vc-life-circle
- (void)viewDidLoad
{
    [super viewDidLoad];
        //初始化
    _fullDistance = 0.78;
    _proportion = 0.77;
    _distance = 0;
    _proportionOfLeftView = 1;
    _distanceOfLeftView = 50;
    _leftViewIsShow = NO;
    
    if(self.backgroundImage){
        UIImageView* bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        bgView.image = self.backgroundImage;
        [self.view addSubview:bgView];
    }
    
    if (self.leftViewController) {
        self.leftView = self.leftViewController.view;
        [self addChildViewController:self.leftViewController];
        [self.view addSubview:self.leftView];
        [self.leftViewController didMoveToParentViewController:self];
    }
    if (self.mainVc) {
        self.mainView = self.mainVc.view;
        [self addChildViewController:self.mainVc];
        [self.view addSubview:self.mainView];
        [self.mainVc didMoveToParentViewController:self];
    }
    

    self.leftView.center = CGPointMake(self.leftView.center.x - 50, self.leftViewController.view.center.y);
    
    self.leftView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    
    _centerOfLeftViewAtBeginning = self.leftView.center;
    
    [self.view addSubview:self.leftView];
    
    
        // 增加黑色遮罩层，实现视差特效
    self.blackCover = [[UIView alloc]initWithFrame: CGRectOffset(self.view.frame, 0, 0)];
    self.blackCover.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.blackCover];
    
    [self.view addSubview:self.mainView];
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHome)];
    self.tap = tap;
    [self.mainView addGestureRecognizer:tap];
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    self.pan = pan;
    [self.mainView addGestureRecognizer:pan];
   
    
}

#pragma mark-  privatetools methords
-(void)addMaskView
{
    if (self.maskView.superview) {
        return;
    }
    self.maskView.frame = self.mainView.bounds;
    [self.mainView addSubview:self.maskView];
}

- (void)doTheAnimate:(CGFloat)proportion type:(NSInteger)showWhat andTime:(CGFloat)time
{
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.mainView.center = CGPointMake(self.view.center.x + _distance , self.view.center.y);
        
        self.mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
        
        if (showWhat == 0) {
            self.leftViewController.view.center = CGPointMake(_centerOfLeftViewAtBeginning.x + _distanceOfLeftView, self.leftViewController.view.center.y);
            
            self.leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, _proportionOfLeftView, _proportionOfLeftView);
            self.blackCover.alpha = 0;
                //self.leftViewController.view.alpha = 1;
        }
        else{
            self.blackCover.alpha = 1;
            self.leftViewController.view.center = CGPointMake(_centerOfLeftViewAtBeginning.x , self.leftViewController.view.center.y);
            self.leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);

        }
        

    } completion:^(BOOL finished) {

        if(showWhat == 0)
            _leftViewIsShow = YES;
        else
              _leftViewIsShow = NO;

    }];
}
- (void)statusBarNeedsAppearanceUpdate
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [UIView animateWithDuration:0.3f animations:^{
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
    
    statusBarStyle = _leftViewIsShow? self.preferredMenuStatusBarStyle : self.mainVc.preferredStatusBarStyle;
    if (self.mainView.frame.origin.y > 10) {
        statusBarStyle = self.preferredMenuStatusBarStyle;
    } else {
        statusBarStyle = self.mainVc.preferredStatusBarStyle;
    }
    
    return statusBarStyle;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation statusBarAnimation = UIStatusBarAnimationNone;
    
    statusBarAnimation = _leftViewIsShow ? self.leftViewController.preferredStatusBarUpdateAnimation : self.mainVc.preferredStatusBarUpdateAnimation;
    if (self.mainView.frame.origin.y > 10) {
        statusBarAnimation = self.leftViewController.preferredStatusBarUpdateAnimation;
    } else {
        statusBarAnimation = self.mainVc.preferredStatusBarUpdateAnimation;
    }
    
    return statusBarAnimation;
}
#pragma mark- property-setter-getter
-(UIView *)maskView
{
    if (!_maskView ) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

#pragma mark- event methords
-(void)pan:(UIPanGestureRecognizer*)rec
{
    CGFloat x = [rec translationInView:self.view].x;
    CGFloat trueDistance = _distance + x ;// 实时距离
        //NSLog(@"%f   %f",trueDistance,_distance);
   
    CGFloat trueProportion = trueDistance / ([UIScreen mainScreen].bounds.size.width*_fullDistance);
    
        // 计算缩放比例
    
    CGFloat proportion = rec.view.frame.origin.x >=0 ? -1 : 1;
    
    proportion *= trueDistance / [UIScreen mainScreen].bounds.size.width;
    proportion *= 1 - _proportion;
    proportion /= _fullDistance + _proportion/2 - 0.5;
    proportion += 1;
    if (proportion <= _proportion) { // 若比例已经达到最小，则不再继续动画
        return;
    }
        // 执行视差特效
    self.blackCover.alpha = (proportion - _proportion) / (1 - _proportion);
    
    CGFloat factor = 1- self.blackCover.alpha;
    
        // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
    if (rec.state ==  UIGestureRecognizerStateEnded) {
        
        if (trueDistance > [UIScreen mainScreen].bounds.size.width * (_proportion / 3)){
            [self showLeftWithFactor:1-factor];
        }
        else if (trueDistance < [UIScreen mainScreen].bounds.size.width * -(_proportion / 3)) {
                [self showHomeWithFactor:factor];
         
        } else {
            [self showHomeWithFactor:factor];
        }
        
            return;
    }
    if (rec.state == UIGestureRecognizerStateBegan) {
        [self addMaskView];
    }
    if (rec.state == UIGestureRecognizerStateChanged) {
        [self statusBarNeedsAppearanceUpdate];

    }
    
    if (trueDistance < 0) {
        return;
    }

        // 执行平移和缩放动画
    self.mainView.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y);
    self.mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
        // 执行左视图动画
    CGFloat pro = 0.8 + (_proportionOfLeftView - 0.8) * trueProportion;
    
    self.leftViewController.view.center = CGPointMake(_centerOfLeftViewAtBeginning.x + _distanceOfLeftView * trueProportion, _centerOfLeftViewAtBeginning.y - (_proportionOfLeftView - 1) * self.leftViewController.view.frame.size.height * trueProportion / 2 );
    
    self.leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro);
}

#pragma mark- delegate methords
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
            //NSLog(@"%f   %f    %f",point.x,self.mainView.center.x,self.view.center.x);
        
        if (point.x > IphoneHeight(20) && self.mainView.center.x == self.view.center.x) {
            return NO;
        } else {
            [((AppDelegate*) [UIApplication sharedApplication].delegate).leftMenu updateStatus];
            return YES;
        }
    }
    
    return YES;
}


@end
