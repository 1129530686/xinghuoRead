//
//  JUDIAN_READ_GdtAdSize250ViewCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_GdtAdSize250ViewCell.h"

@interface JUDIAN_READ_GdtAdSize250ViewCell ()

@end


@implementation JUDIAN_READ_GdtAdSize250ViewCell


- (void)addPlaceholderView {
    if (self.unifiedNativeAdView) {
        return;
    }
    self.unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] init];
    [self.contentView addSubview:self.unifiedNativeAdView];

    WeakSelf(that);
    [self.unifiedNativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(20);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-20).priority(980);
    }];
}





@end
