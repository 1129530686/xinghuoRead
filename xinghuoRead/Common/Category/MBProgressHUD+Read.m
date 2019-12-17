//
//  MBProgressHUD+Read.m
//
//  Created by apple on 18/9/11.
//  Copyright (c) 2018年 HU. All rights reserved.
//

#import "MBProgressHUD+Read.h"
#import <SDWebImage/UIImage+GIF.h>

@implementation MBProgressHUD (Read)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [self lastWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = [UIFont boldSystemFontOfSize:15.0];
    if (icon == nil) {
        
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.label.textColor = [UIColor whiteColor];
        
        [hud hideAnimated:YES afterDelay:1.0];
        
    }else{
        
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

+ (void)showError:(NSString *)error toView:(UIView *)view {
    //[self show:error icon:@"MBProgress_CLOSE" view:view];
    [self show:error icon:nil view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    //[self show:success icon:@"MBProgress_TICK" view:view];
    [self show:success icon:nil view:view];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    [self show:message icon:nil view:view];
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    if (!view) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}



+ (void)showLoadingForView:(UIView *)view{
    if (!view) {
         view = [self lastWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zsb" ofType:@"gif" ];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data]; // 要配合 SDWebImage
    UIImageView *imgView = [[UIImageView alloc] initWithImage: image];
    imgView.clipsToBounds = YES;
    hud.customView = imgView;
    hud.backgroundColor = kColorWhite;
    hud.alpha = 1;
    hud.square = NO;
    hud.removeFromSuperViewOnHide = YES;
//    hud.bezelVie.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];

}



+ (void)showLoadingForView:(UIView *)view bgColor:(UIColor*)bgColor {
    if (!view) {
        view = [self lastWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zsb" ofType:@"gif" ];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data]; // 要配合 SDWebImage
    UIImageView *imgView = [[UIImageView alloc] initWithImage: image];
    imgView.clipsToBounds = YES;
    hud.customView = imgView;
    hud.backgroundColor = bgColor;
    hud.alpha = 1;
    hud.square = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    
}





+ (void)showPayLoading{//1164
    UIView *view = kKeyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zsb" ofType:@"gif" ];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data]; // 要配合 SDWebImage
    UIImageView *imgView = [[UIImageView alloc] initWithImage: image];
    imgView.clipsToBounds = YES;
    hud.customView = imgView;
    hud.square = NO;
    hud.removeFromSuperViewOnHide = YES;
//    hud.bezelView.backgroundColor = [UIColor clearColor];
}

+ (UIWindow *)lastWindow{
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    for(UIWindow *window in [windows reverseObjectEnumerator]){
//        if ([window.className isEqualToString:NSStringFromClass([UIWindow class])] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
//            return window;
//    }
    return [UIApplication sharedApplication].keyWindow;
}


+ (void)showTipWithImage:(NSString *)message image:(UIImage*)image toVc:(UIViewController *)vc {
    
        MBProgressHUD *hud = nil;
    
        if (vc.view) {
            hud = [[MBProgressHUD alloc]initWithView:vc.view];
            [vc.view addSubview:hud];
            if (vc.edgesForExtendedLayout == 0) {
                hud.offset = CGPointMake(0, -32);
            }
        }
    
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeCustomView;
    
        if (image) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            hud.customView = imageView;
        }
    
        if (message) {
            hud.label.font = [UIFont systemFontOfSize:14];
            hud.label.textColor = [UIColor whiteColor];
            hud.label.text = message;
        }
    
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1];
}


+ (void)showForWaiting:(UIView*)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    hud.bezelView.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
    hud.removeFromSuperViewOnHide = YES;
    
}


@end

