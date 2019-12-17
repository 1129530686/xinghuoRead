//
//  JUDIAN_READ_UserCheckInAdvertiseCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserCheckInAdvertiseCell.h"
#import "JUDIAN_READ_BuCellAdView.h"

@interface JUDIAN_READ_UserCheckInAdvertiseCell ()
@property(nonatomic, weak)JUDIAN_READ_BuCellAdView* adView;
@end


@implementation JUDIAN_READ_UserCheckInAdvertiseCell

- (void)awakeFromNib {
    [super awakeFromNib];

}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self addAdView];
        [self addPlaceholderView];
        
        [self addBottomLine];
        
    }
    
    return self;
}




- (void)addAdView {
    
    JUDIAN_READ_BuCellAdView* adView = [[JUDIAN_READ_BuCellAdView alloc] init];
    _adView = adView;
    [adView setDefaultStyle];
    adView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:adView];
    
    WeakSelf(that);
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
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


- (void)addBottomLine {
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    WeakSelf(that);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(0);
        make.right.equalTo(that.contentView.mas_right).offset(0);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd {
    if (!nativeAd) {
        return;
    }
    [_adView buildGdtView:nativeAd];
}


- (void)buildCsjView:(BUNativeAd*)nativeAd {
    if (!nativeAd) {
        return;
    }
    [_adView buildView:nativeAd];
}



@end
