//
//  JUDIAN_READ_AdSize250ViewCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AdSize250ViewCell.h"
#import "JUDIAN_READ_BuImageAdView.h"
#import "JUDIAN_READ_BuImageAdView.h"
#import "JUDIAN_READ_TextStyleModel.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_AdSize250ViewCell ()
@property(nonatomic, strong)JUDIAN_READ_BuImageAdView* adView;
@end



@implementation JUDIAN_READ_AdSize250ViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
        [self addPlaceholderView];
    }
    
    return self;
}



- (void)addViews {
    
    _adView = [[JUDIAN_READ_BuImageAdView alloc]init];
    [self.contentView addSubview:_adView];
    
    WeakSelf(that);
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(20);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-20).priority(980);
    }];

}


- (void)addPlaceholderView {
    
    
}



- (void)buildView:(BUNativeAd*)nativeAd {
    [_adView buildView:nativeAd];
}



- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd {
    [_adView buildGdtView:nativeAd];
}




- (void)setViewStyle {
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.contentView.backgroundColor = [style getBgColor];
    
    [_adView setViewStyle];
}

@end
