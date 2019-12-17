//
//  JUDIAN_READ_UserCheckInAdvertiseCell.h
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserCheckInAdvertiseCell : UITableViewCell
@property(nonatomic, strong)GDTUnifiedNativeAdView* unifiedNativeAdView;
- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd;
- (void)buildCsjView:(BUNativeAd*)nativeAd;
@end

NS_ASSUME_NONNULL_END
