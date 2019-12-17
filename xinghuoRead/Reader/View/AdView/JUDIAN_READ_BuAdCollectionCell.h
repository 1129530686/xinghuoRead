//
//  JUDIAN_READ_BuAdCollectionCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/11.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BuAdCollectionCell : UICollectionViewCell

@property(nonatomic, strong)GDTUnifiedNativeAdView* unifiedNativeAdView;
@property(nonatomic, weak)UIView* bottomLineView;
- (void)buildView:(BUNativeAd*)nativeAd;
- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd;
- (void)addPlaceholderView;
@end

NS_ASSUME_NONNULL_END
