//
//  JUDIAN_READ_BuImageAdView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/10.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BuImageAdView.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"
#import "JUDIAN_READ_AdsManager.h"
#import "UIView+Common.h"

#define TITLE_FONT_SIZE 14
#define DESCRIPTION_FONT_SIZE 14

#define VIEW_AD_TIP_HEIGHT 20
#define VIEW_AD_FONT 10

@interface JUDIAN_READ_BuImageAdView ()
@property(nonatomic, strong)JUDIAN_READ_VerticalAlignmentLabel* adDetailLabel;
@property(nonatomic, strong)UIImageView* imageView;
@property(nonatomic, strong)UILabel* adTitleLabel;
@property(nonatomic, strong)UILabel* adTipLabel;
@property(nonatomic, strong)UILabel* viewAdLabel;
@property(nonatomic, weak)UIImageView* channelTipImageView;
@end


@implementation JUDIAN_READ_BuImageAdView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}



- (void)setupViews {
    //self.layer.cornerRadius = 6;
    //self.layer.masksToBounds = YES;
   //
    self.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addViews];
}



- (void)addViews {

    _adDetailLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [_adDetailLabel setAlignmentStyle:(TextInTop)];
    _adDetailLabel.numberOfLines = 2;


    [self addSubview:_adDetailLabel];
    

    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    
    _viewAdLabel = [[UILabel alloc]init];
    _viewAdLabel.text = _AD_BUTTON_TEXT_;
    _viewAdLabel.layer.cornerRadius = 3;
    _viewAdLabel.layer.borderWidth = 0.5;
    _viewAdLabel.layer.masksToBounds = YES;
    _viewAdLabel.layer.borderColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR.CGColor;
    _viewAdLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    _viewAdLabel.textAlignment = NSTextAlignmentCenter;
    _viewAdLabel.font = [UIFont systemFontOfSize:VIEW_AD_FONT];
    [self addSubview:_viewAdLabel];
    
    
    UIImageView* channelTipImageView = [[UIImageView alloc]init];
    _channelTipImageView = channelTipImageView;
    [self addSubview:channelTipImageView];
    
    _adTitleLabel = [[UILabel alloc]init];
    _adTitleLabel.text = @"";
    _adTitleLabel.textColor = RGB(0x66, 0x66, 0x66);
    _adTitleLabel.textAlignment = NSTextAlignmentLeft;
    _adTitleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    [self addSubview:_adTitleLabel];
    
    
    WeakSelf(that);
    [_adDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(10);
        make.right.equalTo(that.mas_right).offset(-10);
        make.top.equalTo(that.mas_top).offset(10);
        make.height.equalTo(@(0));
    }];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(5);
        make.right.equalTo(that.mas_right).offset(-5);
        make.top.equalTo(that.adDetailLabel.mas_bottom).offset(10);
        make.bottom.equalTo(that.mas_bottom).offset(-41);
    }];
    
    
    [_viewAdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-5);
        make.width.equalTo(@(0));
        make.centerY.equalTo(that.adTitleLabel.mas_centerY);
        make.height.equalTo(@(VIEW_AD_TIP_HEIGHT));
    }];
    
    
    
    [_adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(5);
        make.right.equalTo(that.mas_right).offset(-5);
        make.height.equalTo(@(TITLE_FONT_SIZE));
        make.bottom.equalTo(that.mas_bottom).offset(-14);
    }];

    [channelTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(35));
        make.height.equalTo(@(12));
        
        make.bottom.equalTo(that.imageView.mas_bottom);
        make.right.equalTo(that.imageView.mas_right);
        
    }];
}


- (void)addGdtView {
    
    if (self.unifiedNativeAdView) {
        return;
    }
    self.unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] init];
    [self addSubview:self.unifiedNativeAdView];
    
    WeakSelf(that);
    [self.unifiedNativeAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
    }];
    
}

- (void)removeGdtView {
    [self.unifiedNativeAdView removeFromSuperview];
}


- (void)addFailureView {
    
    [_bgAdView removeFromSuperview];
    
    UIImage* defaultImage = [UIImage imageNamed:@"default_advertise_tip"];
    _bgAdView = [[UIImageView alloc] init];
    _bgAdView.image = defaultImage;
    [self addSubview:_bgAdView];
    
    WeakSelf(that);
    [_bgAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(306));
        make.height.equalTo(@(165));
        make.centerX.equalTo(that.mas_centerX);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
}


- (void)removeFailureView {
    [_bgAdView removeFromSuperview];
    _bgAdView = nil;
}


- (void)buildView:(BUNativeAd*)nativeAd {
    BUImage *image = nativeAd.data.imageAry.firstObject;

    _channelTipImageView.image = [UIImage imageNamed:@"chuang_shan_jia_tip"];
    
    UIImage* defaultImage = [UIImage imageNamed:@"default_advertise_tip"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:image.imageURL] placeholderImage:defaultImage];
    
    UIColor* color = [self getTextColor];
    _adDetailLabel.attributedText = [JUDIAN_READ_AdsManager createAttributedText:nativeAd.data.AdDescription color:color];

    _adTitleLabel.text = nativeAd.data.AdTitle;
    _viewAdLabel.text = nativeAd.data.buttonText;
    if (_viewAdLabel.text.length <= 0) {}
    _viewAdLabel.text = _AD_BUTTON_TEXT_;
    CGFloat viewAdWidth = ceil([_viewAdLabel getTextWidth:VIEW_AD_FONT] + 10);
    [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(viewAdWidth));
    }];
    
    WeakSelf(that);
    [_adTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(that.mas_right).offset(-viewAdWidth - 20);
    }];
    
    
    [self setNeedsLayout];
}



- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd {
   
    _channelTipImageView.image = [UIImage imageNamed:@"guang_dian_tong_tip"];
    
    NSURL *imageURL = [NSURL URLWithString:nativeAd.imageUrl];
    UIImage* defaultImage = [UIImage imageNamed:@"default_advertise_tip"];
    [_imageView sd_setImageWithURL:imageURL placeholderImage:defaultImage];
    
    UIColor* color = [self getTextColor];
    _adDetailLabel.attributedText = [JUDIAN_READ_AdsManager createAttributedText:nativeAd.desc color:color];
    _adTitleLabel.text =  nativeAd.title;
    _viewAdLabel.text = _AD_BUTTON_TEXT_;

    
    CGFloat viewAdWidth = ceil([_viewAdLabel getTextWidth:VIEW_AD_FONT] + 10);
    [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(viewAdWidth));
    }];
    
    WeakSelf(that);
    [_adTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-viewAdWidth - 20);
    }];
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_adDetailLabel.attributedText.length <= 0) {
        return;
    }
    
    //[self clipCorner:CGSizeMake(6, 6)];

    NSAttributedString* attributedText = self.adDetailLabel.attributedText;
    NSInteger height = 0;
    NSInteger lineCount = 0;
    
    NSInteger detailWidth = DESCRIPTION_WIDTH;
    [JUDIAN_READ_AdsManager computeAttributedTextHeight:attributedText width:detailWidth height:&height lineCount:&lineCount];
    
    if (lineCount == 1) {
        [self.adDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(DESCRIPTION_FONT_SIZE));
        }];
    }
    else {
        [self.adDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(height)));
        }];
    }
    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        [that.adDetailLabel sizeToFit];
    });

}



- (void)setViewStyle {
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        self.backgroundColor = RGB(0x16, 0x16, 0x16);
    }
    else {
        self.backgroundColor = RGB(0xf9, 0xf9, 0xf9);
    }
    
}



- (UIColor*)getTextColor {
    UIColor* color = RGB(0x33, 0x33, 0x33);
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        color = RGB(0x9b, 0x9b, 0x9b);
    }
    return color;
}




- (void)handleTouchEvent:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kNoAdertiseCmd),
                                                                                         @"value":@(0)
                                                                                         }];
    
    
}



@end
