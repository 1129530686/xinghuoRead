//
//  JUDIAN_READ_BuImageAdView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/10.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BuImageAdView : UIView
@property(nonatomic, strong)GDTUnifiedNativeAdView* unifiedNativeAdView;
@property(nonatomic, strong)UIImageView* bgAdView;

- (void)addGdtView;
- (void)removeGdtView;

- (void)buildView:(BUNativeAd*)nativeAd;
- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd;
- (void)setViewStyle;
- (void)addFailureView;
- (void)removeFailureView;
@end

NS_ASSUME_NONNULL_END
