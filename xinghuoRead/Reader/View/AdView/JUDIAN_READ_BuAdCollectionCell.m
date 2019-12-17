//
//  JUDIAN_READ_BuAdCollectionCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/11.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BuAdCollectionCell.h"
#import "JUDIAN_READ_BuCellAdView.h"

@interface JUDIAN_READ_BuAdCollectionCell ()
@property(nonatomic, strong)JUDIAN_READ_BuCellAdView* adView;
@end


@implementation JUDIAN_READ_BuAdCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
        [self addBottomLineView];
    }
    
    return self;
}



- (void)addViews {
    
    _adView = [[JUDIAN_READ_BuCellAdView alloc] init];
    [self.contentView addSubview:_adView];
    [_adView setDefaultStyle];
    _adView.backgroundColor = [UIColor whiteColor];
    
    WeakSelf(that);
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom).priority(998);
    }];
}



- (void)addBottomLineView {
    UIView* lineView = [[UIView alloc] init];
    _bottomLineView = lineView;
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    lineView.hidden = YES;
    WeakSelf(that);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.bottom.equalTo(that.contentView.mas_bottom);
        make.height.equalTo(@(0.5));
    }];

}


- (void)buildView:(BUNativeAd*)nativeAd {
    [_adView buildView:nativeAd];
}



- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd{
    [_adView buildGdtView:nativeAd];
}



- (void)addPlaceholderView {
    
    if (self.unifiedNativeAdView) {
        return;
    }
    
    self.unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] init];
    [self.contentView addSubview:self.unifiedNativeAdView];
    
    WeakSelf(that);
    [self.unifiedNativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.unifiedNativeAdView unregisterDataObject];
}

@end
