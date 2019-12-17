//
//  JUDIAN_READ_ FictionEmbeddedAdManager.h
//  xinghuoRead
//
//  Created by judian on 2019/9/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>

typedef enum : NSUInteger {
    FICTION_BOTTOM_AD = 1,
    FICTION_EMBEDDED_AD,
} FICTION_AD_TYPE;


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FictionEmbeddedAdManager : NSObject

@property (nonatomic, strong)NSMutableDictionary* userChapterCountDictionary;
@property (nonatomic, weak)UIViewController* viewController;
+ (instancetype)createEmbeddedAdManager:(NSInteger)type;

- (void)addBottomAdView:(UIViewController*)controller;
- (void)addMiddleAdView:(UIViewController*)controller container:(UIView*)container frame:(CGRect)frame;

- (void)initGDTBottomAdData;
- (void)initGDTMiddleAdData:(UIViewController*)controller;
- (void)updateViewStyle;
- (void)setViewStyle;
- (void)showVideoPrompt;

@end

NS_ASSUME_NONNULL_END
