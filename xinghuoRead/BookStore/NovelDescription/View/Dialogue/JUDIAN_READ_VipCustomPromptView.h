//
//  JUDIAN_READ_VipCustomPromptView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonClock)(_Nonnull id args);


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_VipCustomPromptView : UIView

+ (void)createPromptView:(UIView*)container block:(buttonClock)block;
+ (void)createAdPromptView:(UIView*)container block:(buttonClock)block;
+ (void)createNoFeePromptView:(UIView*)container goldCoin:(NSString*)goldCoin block:(buttonClock)block;
+ (void)createAdPromptView:(UIView*)container block:(buttonClock)block cancel:(buttonClock)cancelBlock;
+ (void)createCollectionPromptView:(UIView*)container block:(buttonClock)block cancel:(buttonClock)cancelBlock;
+ (void)createVideoAdPromptView:(UIView*)container block:(buttonClock)block cancel:(buttonClock)cancelBlock;

+ (void)createInfoHomePromptView:(UIView*)container text:(NSString *)text detailText:(NSString *)detailText btnText:(NSString *)btnText block:(buttonClock)block;

@end

NS_ASSUME_NONNULL_END
