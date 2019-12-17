//
//  JUDIAN_READ_CoverViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/9/24.
//  Copyright © 2019 judian. All rights reserved.
//


#import <UIKit/UIKit.h>

@class JUDIAN_READ_CoverViewController;

@protocol JUDIAN_READ_CoverViewControllerDelegate <NSObject>

@optional

- (void)showSettingMenuView;
- (void)coverController:(JUDIAN_READ_CoverViewController * _Nonnull)coverController currentController:(UIViewController * _Nullable)currentController finish:(BOOL)isFinish;
- (void)coverController:(JUDIAN_READ_CoverViewController * _Nonnull)coverController willTransitionToPendingController:(UIViewController * _Nullable)pendingController;

- (UIViewController * _Nullable)coverController:(JUDIAN_READ_CoverViewController * _Nonnull)coverController aboveController:(UIViewController * _Nullable)currentController;
- (UIViewController * _Nullable)coverController:(JUDIAN_READ_CoverViewController * _Nonnull)coverController belowController:(UIViewController * _Nullable)currentController;

@end

@interface JUDIAN_READ_CoverViewController : UIViewController

@property (nonatomic,weak,nullable) id<JUDIAN_READ_CoverViewControllerDelegate> delegate;
@property (nonatomic,assign) BOOL gestureRecognizerEnabled;
@property (nonatomic,assign) BOOL canAnimate;
@property (nonatomic,strong,readonly,nullable) UIViewController *currentViewController;

- (void)setController:(UIViewController * _Nullable)controller;
- (void)setController:(UIViewController * _Nullable)controller animated:(BOOL)animated isAbove:(BOOL)isAbove;

@end
