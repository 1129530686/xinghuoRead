//
//  JUDIAN_READ_CoverViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/9/24.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_CoverViewController.h"
#import "JUDIAN_READ_CoreTextManager.h"
#define ViewWidth self.view.frame.size.width
#define ViewHeight self.view.frame.size.height

#define AnimateDuration 0.20

@interface JUDIAN_READ_CoverViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic,assign) BOOL isInLeftPart;
@property (nonatomic,assign) BOOL isPanEnd;
@property (nonatomic,assign) BOOL isPanBegin;
@property (nonatomic,assign) BOOL isAnimateChange;

@property (nonatomic,strong,nullable) UIViewController *pendingViewController;

@property (nonatomic,assign) CGPoint moveTouchPoint;
@property (nonatomic,assign) CGFloat moveSpaceX;

@end

@implementation JUDIAN_READ_CoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGestureRecognizer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.frame = [[JUDIAN_READ_CoreTextManager shareInstance] getFrameOutOfAd];
}

- (void)initGestureRecognizer
{
    // 动画效果开启
    self.canAnimate = YES;
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加手势
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGuesture:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    // 启用手势
    self.gestureRecognizerEnabled = YES;
    
    // 开启裁剪
    self.view.layer.masksToBounds = YES;
}

/**
 *  手势开关
 */
- (void)setGestureRecognizerEnabled:(BOOL)gestureRecognizerEnabled
{
    _gestureRecognizerEnabled = gestureRecognizerEnabled;
    
    self.panGestureRecognizer.enabled = gestureRecognizerEnabled;
    
    self.tapGestureRecognizer.enabled = gestureRecognizerEnabled;
}

#pragma mark - 手势处理

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    // 用于辨别方向
    CGPoint tempPoint = [pan translationInView:self.view];
    
    // 用于计算位置
    CGPoint touchPoint = [pan locationInView:self.view];
    
    // 比较获取差值
    if (!CGPointEqualToPoint(self.moveTouchPoint, CGPointZero) && (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)) {
        
        self.moveSpaceX = touchPoint.x - self.moveTouchPoint.x;
    }
    
    // 记录位置
    self.moveTouchPoint = touchPoint;
    
    if (pan.state == UIGestureRecognizerStateBegan) { // 手势开始
        if (self.isAnimateChange) {
            return;
        }
        
        // 放弃动画时则不需要设置正在动画中
        if (self.canAnimate) {
            self.isAnimateChange = YES;
        }
        
        self.isPanBegin = YES;
        self.isPanEnd = YES;
        
    }else if (pan.state == UIGestureRecognizerStateChanged) { // 手势移动
        [self handleMovingGesture:touchPoint point:tempPoint];
    }
    else {
        [self handleEndGuesture];
    }
}

- (void)handleMovingGesture:(CGPoint)touchPoint point:(CGPoint)tempPoint{
    
    if (!(fabs(tempPoint.x) > 0.01)) {
        return;
    }
        
    // 获取将要显示的控制器
    if (self.isPanBegin) {
        self.isPanBegin = NO;
        // 获取将要显示的控制器
        self.pendingViewController = [self getPanControllerWithTouchPoint:tempPoint];
        
        // 将要显示的控制器
        if ([self.delegate respondsToSelector:@selector(coverController:willTransitionToPendingController:)]) {
            [self.delegate coverController:self willTransitionToPendingController:self.pendingViewController];
        }
        // 添加
        [self addViewController:self.pendingViewController];
    }
        
    // 判断显示
    if (self.canAnimate && self.isPanEnd) {
        if (!self.pendingViewController) {
            return;
        }
        
        if (self.isInLeftPart) {
            self.pendingViewController.view.frame = CGRectMake(touchPoint.x - ViewWidth, 0, ViewWidth, ViewHeight);
        }
        else {
            self.currentViewController.view.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, ViewWidth, ViewHeight);
        }
        
    }
}



- (void)handleEndGuesture {

    if (!self.isPanEnd) {
        self.moveTouchPoint = CGPointZero;
        self.moveSpaceX = 0;
        
        return;
    }
            
    // 结束Pan手势
    self.isPanEnd = NO;

    if (!self.canAnimate) {// 无动画
        //手势结束
        [self gestureSuccess:YES animated:self.canAnimate];
        
        self.moveTouchPoint = CGPointZero;
        self.moveSpaceX = 0;
        
        return;
    }
    
    // 动画
    if (!self.pendingViewController) {
        self.isAnimateChange = NO;
        
        self.moveTouchPoint = CGPointZero;
        self.moveSpaceX = 0;
        
        return;
    }
    
    BOOL isSuccess = YES;
    if (self.isInLeftPart) {
        if (self.pendingViewController.view.frame.origin.x <= -(ViewWidth - ViewWidth*0.18)) {
            isSuccess = NO;
        }
        else{
            if (self.moveSpaceX < 0) {
                isSuccess = NO;
            }
        }
    }
    else {
        if (self.currentViewController.view.frame.origin.x >= -1) {
            isSuccess = NO;
        }
    }
                    
    // 手势结束
    [self gestureSuccess:isSuccess animated:YES];
    
    self.moveTouchPoint = CGPointZero;
    self.moveSpaceX = 0;

}



- (void)handleTapGuesture:(UITapGestureRecognizer *)tap {
    
    if (self.isAnimateChange) {
        return;
    }

    CGFloat leftWidth = 0.32f * WIDTH_SCREEN;
    CGFloat rightWidth = 0.68f * WIDTH_SCREEN;
    
    CGPoint touchPoint = [tap locationInView:self.view];
    
    if(touchPoint.x > leftWidth && touchPoint.x < rightWidth) {
        if ([self.delegate respondsToSelector:@selector(showSettingMenuView)]) {
            [self.delegate showSettingMenuView];
        }
        return;
    }
    
    
    if (self.canAnimate) {
        self.isAnimateChange = YES;
    }
    

    self.pendingViewController = [self getTapControllerWithTouchPoint:touchPoint];
    
    if ([self.delegate respondsToSelector:@selector(coverController:willTransitionToPendingController:)]) {
        
        [self.delegate coverController:self willTransitionToPendingController:self.pendingViewController];
    }
    

    [self addViewController:self.pendingViewController];
    
    [self gestureSuccess:YES animated:self.canAnimate];
}


#pragma mark 手势结束
- (void)gestureSuccess:(BOOL)isSuccess animated:(BOOL)animated {
    if (!self.pendingViewController) {
        return;
    }
    
    if (self.isInLeftPart) {
        [self gestureSuccessInLeftPart:isSuccess animated:animated];
    }
    else {
        [self gestureSuccessInRightPart:isSuccess animated:animated];
    }
    
}



- (void)gestureSuccessInLeftPart:(BOOL)isSuccess animated:(BOOL)animated {
    
    if (animated) {
        __weak JUDIAN_READ_CoverViewController *weakSelf = self;
        [UIView animateWithDuration:AnimateDuration animations:^{
            if (isSuccess) {
                weakSelf.pendingViewController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
            }
            else {
                weakSelf.pendingViewController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
            }
            
        } completion:^(BOOL finished) {
            [weakSelf animateSuccess:isSuccess];
        }];
    }
    else {
        
        if (isSuccess) {
            self.pendingViewController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        }else{
            self.pendingViewController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
        }
        
        [self animateSuccess:isSuccess];
    }
}


- (void)gestureSuccessInRightPart:(BOOL)isSuccess animated:(BOOL)animated {
    
    if (animated) {
        __weak JUDIAN_READ_CoverViewController *weakSelf = self;
        
        [UIView animateWithDuration:AnimateDuration animations:^{
            
            if (isSuccess) {
                weakSelf.currentViewController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
            }
            else {
                weakSelf.currentViewController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
            }
            
        } completion:^(BOOL finished) {
            [weakSelf animateSuccess:isSuccess];
        }];
        
    }
    else {
        if (isSuccess) {
            self.currentViewController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
        }
        else {
            self.currentViewController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        }
        
        [self animateSuccess:isSuccess];
    }
}


- (void)animateSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        
        [self.currentViewController.view removeFromSuperview];
        
        [self.currentViewController removeFromParentViewController];
        
        _currentViewController = self.pendingViewController;
        
        self.pendingViewController = nil;
        
        self.isAnimateChange = NO;
        
    }else{
        
        [self.pendingViewController.view removeFromSuperview];
        
        [self.pendingViewController removeFromParentViewController];
        
        self.pendingViewController = nil;
        
        self.isAnimateChange = NO;
    }
    
    // 代理回调
    if ([self.delegate respondsToSelector:@selector(coverController:currentController:finish:)]) {
        
        [self.delegate coverController:self currentController:self.currentViewController finish:isSuccess];
    }
}


- (UIViewController * _Nullable)getTapControllerWithTouchPoint:(CGPoint)touchPoint
{
    UIViewController *vc = nil;
    
    if (touchPoint.x < ViewWidth / 3) { // 左边
        
        self.isInLeftPart = YES;
        
        // 获取上一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:aboveController:)]) {
            vc = [self.delegate coverController:self aboveController:self.currentViewController];
        }
        
    }else if (touchPoint.x > (ViewWidth - ViewWidth / 3)){ // 右边
        self.isInLeftPart = NO;
        // 获取下一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController: belowController:)]) {
            vc = [self.delegate coverController:self belowController:self.currentViewController];
        }
    }
    
    if (!vc) {
        self.isAnimateChange = NO;
    }
    
    return vc;
}



- (UIViewController * _Nullable)getPanControllerWithTouchPoint:(CGPoint)touchPoint {
    
    UIViewController *vc = nil;
    
    if (touchPoint.x > 0) { // 左边
        self.isInLeftPart = YES;
        // 获取上一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:aboveController:)]) {
            vc = [self.delegate coverController:self aboveController:self.currentViewController];
        }
        
    }else{ // 右边
        self.isInLeftPart = NO;

        // 获取下一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:belowController:)]) {
            vc = [self.delegate coverController:self belowController:self.currentViewController];
        }
    }
    
    if (!vc) {
        self.isAnimateChange = NO;
    }
    
    return vc;
}


- (void)setController:(UIViewController * _Nullable)controller
{
    [self setController:controller animated:NO isAbove:YES];
}


- (void)setController:(UIViewController * _Nullable)controller animated:(BOOL)animated isAbove:(BOOL)isAbove
{
    if (!controller) {
        return;
    }
    
    if (animated && self.canAnimate && self.currentViewController) { // 需要动画 允许手势动画 同时有根控制器了
        // 正在动画
        if (self.isAnimateChange) {
            return;
        }

        self.isAnimateChange = YES;
        self.isInLeftPart = isAbove;
        
        // 记录
        self.pendingViewController = controller;
        // 添加
        [self addViewController:controller];

        // 手势结束
        [self gestureSuccess:YES animated:YES];
    
    }else{
        // 添加
        [self addViewController:controller];
            
        // 修改frame
        controller.view.frame = self.view.bounds;
            
        // 当前控制器有值 进行删除
        if (_currentViewController) {
            [_currentViewController.view removeFromSuperview];
            [_currentViewController removeFromParentViewController];
        }
        // 赋值记录
        _currentViewController = controller;
    }
    
}


- (void)addViewController:(UIViewController * _Nullable)controller
{
    if (!controller) {
        return;
    }

    [self addChildViewController:controller];
    if (self.isInLeftPart) { // 左边
        [self.view addSubview:controller.view];
        controller.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
    }else{ // 右边
        if (self.currentViewController) { // 有值
            [self.view insertSubview:controller.view belowSubview:self.currentViewController.view];
        }else{ // 没值
            [self.view addSubview:controller.view];
        }
        controller.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
    }
        
    // 添加阴影
    [self setShadowViewController:controller];
    
}


- (void)setShadowViewController:(UIViewController * _Nullable)controller
{
    if (!controller) {
        return;
    }
 
    controller.view.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
    controller.view.layer.shadowOffset = CGSizeMake(0, 0); // 偏移距离
    controller.view.layer.shadowOpacity = 0.5; // 不透明度
    controller.view.layer.shadowRadius = 10.0; // 半径
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer isEqual:self.tapGestureRecognizer]) {
        
        CGFloat tempX = ViewWidth / 3;
        
        CGPoint touchPoint = [self.tapGestureRecognizer locationInView:self.view];
        
        if (touchPoint.x > tempX && touchPoint.x < (ViewWidth - tempX)) {
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    // 移除手势
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    
    // 移除当前控制器
    if (self.currentViewController) {
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        _currentViewController = nil;
    }
    
    // 移除临时控制器
    if (self.pendingViewController) {
        [self.pendingViewController.view removeFromSuperview];
        [self.pendingViewController removeFromParentViewController];
        self.pendingViewController = nil;
    }
}

@end
