//

//
//  Created by apple on 18/9/11.
//  Copyright (c) 2018年 Hu. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Read)
/**
 *  提示用户某种操作成功
 *
 *  @param success 操作成功后显示的文字信息
 *  @param view    显示文字的那个View
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  提示用户某种操作失败（一秒后HUD自动消失）
 *
 *  @param error 错误信息
 *  @param view  显示错误信息的那个View
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  展示需要用HUD显示的信息
 *
 *  @param message 需要显示的文字
 *  @param view    显示文字的那个View
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  提示用户某种操作成功(不需指定显示的View,默认为当前的View)
 *
 *  @param success 成功后显示的文字信息
 */
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

/**
 *  展示需要用HUD显示的信息（默认显示在当前的View）
 *
 *  @param message 需要显示的文字
 *
 */
+ (void)showMessage:(NSString *)message;

/**
 *  隐藏HUD对应方法:+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
 */
+ (void)hideHUDForView:(UIView *)view;

/**
 *  对应方法:+ (MBProgressHUD *)showMessage:(NSString *)message;
 */
+ (void)hideHUD;


// 显示加载中
+ (void)showLoadingForView:(UIView *)view;

+ (void)showLoadingForView:(UIView *)view bgColor:(UIColor*)bgColor;

//plaLoading
+ (void)showPayLoading;


+ (void)showTipWithImage:(NSString *)message image:(UIImage*)image toVc:(UIViewController *)vc;
+ (void)showForWaiting:(UIView*)view;

@end
