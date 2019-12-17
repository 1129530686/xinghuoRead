//
//  JUDIAN_READ_AdSize250ViewCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AdSize250ViewCell : UICollectionViewCell

@property(nonatomic, strong)GDTUnifiedNativeAdView* unifiedNativeAdView;
//@property(nonatomic, strong)id delegate;

- (void)buildView:(BUNativeAd*)nativeAd;
- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd;
- (void)setViewStyle;
@end

NS_ASSUME_NONNULL_END
