//
//  JUDIAN_READ_MiniAdViewCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MiniAdViewCell : UICollectionViewCell

- (void)setViewStyle;

- (void)buildView:(BUNativeAd*)nativeAd;
- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd;
@end

NS_ASSUME_NONNULL_END
