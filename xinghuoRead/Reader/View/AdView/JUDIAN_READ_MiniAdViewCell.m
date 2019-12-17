//
//  JUDIAN_READ_MiniAdViewCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_MiniAdViewCell.h"
#import "JUDIAN_READ_BuCellAdView.h"
#import "JUDIAN_READ_TextStyleManager.h"

#define IMAGE_SIZE_HEIGHT 50
#define CONTAINER_SIZE_HEIGHT 70


@interface JUDIAN_READ_MiniAdViewCell ()
@property(nonatomic, strong)JUDIAN_READ_BuCellAdView* adView;
@property(nonatomic, weak)UIView* bottomLineView;
@property(nonatomic, weak)UIView* topLineView;
@end




@implementation JUDIAN_READ_MiniAdViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
        [_adView updatePostion];
    }
    
    return self;
}


- (void)addViews {
    
    _adView = [[JUDIAN_READ_BuCellAdView alloc] init];
    [self.contentView addSubview:_adView];
    
    UIColor* lineColor = RGB(0xee, 0xee, 0xee);
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        lineColor = RGB(0x22, 0x22, 0x22);
    }

    UIView* topLineView = [[UIView alloc] init];
    _topLineView = topLineView;
    topLineView.backgroundColor = lineColor;
    [_adView addSubview:topLineView];
    
    UIView* bottomLineView = [[UIView alloc] init];
    _bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = lineColor;
    [self.contentView addSubview:bottomLineView];
    
    WeakSelf(that);
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(20);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.adView.mas_left);
        make.right.equalTo(that.adView.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.adView.mas_top);
    }];
    
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.adView.mas_left);
        make.right.equalTo(that.adView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.adView.mas_bottom);
    }];
    
}



- (void)setViewStyle {
    [_adView setViewStyle];
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.contentView.backgroundColor = [style getBgColor];
    _adView.backgroundColor = [style getBgColor];
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _topLineView.backgroundColor = RGBA(0x22, 0x22, 0x22, 0.7);
        _bottomLineView.backgroundColor = RGBA(0x22, 0x22, 0x22, 0.7);
    }
    else {
        _topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
        _bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    }
    
}


- (void)buildView:(BUNativeAd*)nativeAd {
    [_adView buildView:nativeAd];
}


- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd {
    [_adView buildGdtView:nativeAd];
}


@end
