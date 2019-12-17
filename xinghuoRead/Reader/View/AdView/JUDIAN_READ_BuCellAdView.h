//
//  JUDIAN_READ_BuCellAdView.h
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BuCellAdView : UIControl

@property(nonatomic, strong)GDTUnifiedNativeAdView* unifiedNativeAdView;

- (void)buildView:(BUNativeAd*)nativeAd;
- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd;
- (void)setDefaultStyle;
- (void)setViewStyle;
- (void)setBottomViewStyle;
- (void)updatePostion;
- (void)addGdtView;
- (void)removeGdtView;
@end


@interface JUDIAN_READ_BottomCellAdView : JUDIAN_READ_BuCellAdView


@end


NS_ASSUME_NONNULL_END
