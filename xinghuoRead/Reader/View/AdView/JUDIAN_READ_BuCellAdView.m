//
//  JUDIAN_READ_BuCellAdView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BuCellAdView.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"
#import "JUDIAN_READ_AdsManager.h"

#define AD_IMAGE_HEIGHT 50
#define VIEW_AD_TIP_HEIGHT 15
#define VIEW_AD_FONT 9

@interface JUDIAN_READ_BuCellAdView ()

@property(nonatomic, weak)UIImageView* imageView;
@property(nonatomic, weak)UILabel* adTipLabel;
@property(nonatomic, weak)UILabel* adTitleLabel;
@property(nonatomic, weak)JUDIAN_READ_VerticalAlignmentLabel* adContentLabel;

@property(nonatomic, strong)UILabel* viewAdLabel;
@property(nonatomic, assign)BOOL isDefaultStyle;
@property(nonatomic, weak)UIImageView* channelTipImageView;
@end


@implementation JUDIAN_READ_BuCellAdView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _isDefaultStyle = FALSE;
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}



- (void)addViews {
    
    UIImageView* imageView = [[UIImageView alloc]init];
    _imageView = imageView;
    imageView.image = [UIImage imageNamed:@"default_h_image"];
    [self addSubview:imageView];
    
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
    
    
    UILabel* adTitleLabel = [[UILabel alloc]init];
    _adTitleLabel = adTitleLabel;
    adTitleLabel.text = @"";
    adTitleLabel.font = [UIFont systemFontOfSize:12];
    adTitleLabel.textColor = RGB(0x99, 0x99, 0x99);
    adTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:adTitleLabel];

    
    JUDIAN_READ_VerticalAlignmentLabel* adContentLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    _adContentLabel = adContentLabel;
    adContentLabel.numberOfLines = 2;
    [self addSubview:adContentLabel];
    
    UIImageView* channelTipImageView = [[UIImageView alloc]init];
    _channelTipImageView = channelTipImageView;
    [self addSubview:channelTipImageView];
    
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(89)).priority(998);
        make.height.equalTo(@(AD_IMAGE_HEIGHT));
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [_viewAdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(0));
        make.height.equalTo(@(0));
        make.bottom.equalTo(that.mas_bottom).offset(-10);
    }];
    
    
    [adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(11);
        make.centerY.equalTo(that.viewAdLabel.mas_centerY).priority(998);
        make.right.equalTo(that.viewAdLabel.mas_left).offset(-10);
        make.height.equalTo(@(12));
        
    }];
    

    
    
    [adContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adTitleLabel.mas_left);
        make.top.equalTo(that.mas_top).offset(0);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(0));
    }];
    
    
    [channelTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(35));
        make.height.equalTo(@(12));
        make.right.equalTo(imageView.mas_right);
        make.bottom.equalTo(imageView.mas_bottom);
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


- (void)updatePostion {
    
    WeakSelf(that);
    [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(0);
    }];
    
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(that.mas_left).offset(0);
    }];
    
    [_adContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(0);
    }];
}




- (void)setViewStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        self.backgroundColor = RGB(0x33, 0x33, 0x33);
        _adTitleLabel.textColor = RGB(0x66, 0x66, 0x66);
    }
    else {
       self.backgroundColor = RGB(0xf9, 0xf9, 0xf9);
        _adTitleLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
}



- (void)setBottomViewStyle {
    
    self.backgroundColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _adContentLabel.textColor = RGB(0x9b, 0x9b, 0x9b);
        _adTitleLabel.textColor = RGB(0x66, 0x66, 0x66);
    }
    else {
        _adContentLabel.textColor = RGB(0x66, 0x66, 0x66);
        _adTitleLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
}



- (void)setDefaultStyle {
    self.backgroundColor = RGB(0xf9, 0xf9, 0xf9);
    _adTitleLabel.textColor = RGB(0x99, 0x99, 0x99);;

    _isDefaultStyle = TRUE;
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(89));
    }];
}


- (void)buildView:(BUNativeAd*)nativeAd {
    BUImage *image = nativeAd.data.imageAry.firstObject;
    UIImage* defaultImage = [UIImage imageNamed:@"default_h_image"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:image.imageURL] placeholderImage:defaultImage];
    
    _channelTipImageView.image = [UIImage imageNamed:@"chuang_shan_jia_tip"];
    UIColor* color = [self getTextColor];
    _adContentLabel.attributedText = [JUDIAN_READ_AdsManager createAttributedText:nativeAd.data.AdDescription color:color];
    _adTitleLabel.text = nativeAd.data.AdTitle;
    
    //NSString* text = nativeAd.data.buttonText;
    _viewAdLabel.text = _AD_BUTTON_TEXT_;
    
    CGFloat viewAdWidth = ceil([_viewAdLabel getTextWidth:VIEW_AD_FONT] + 8);
    [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(viewAdWidth));
        make.height.equalTo(@(VIEW_AD_TIP_HEIGHT));
    }];
    
    
    [self setNeedsLayout];
}



- (void)buildGdtView:(GDTUnifiedNativeAdDataObject*)nativeAd {
    
    _channelTipImageView.image = [UIImage imageNamed:@"guang_dian_tong_tip"];
    
    NSURL *imageURL = [NSURL URLWithString:nativeAd.imageUrl];
    UIImage* defaultImage = [UIImage imageNamed:@"default_h_image"];
    [_imageView sd_setImageWithURL:imageURL placeholderImage:defaultImage];
    
    UIColor* color = [self getTextColor];
    _adContentLabel.attributedText = [JUDIAN_READ_AdsManager createAttributedText:nativeAd.desc color:color];
    _adTitleLabel.text = nativeAd.title;
    _viewAdLabel.text = _AD_BUTTON_TEXT_;
    
    CGFloat viewAdWidth = ceil([_viewAdLabel getTextWidth:VIEW_AD_FONT] + 8);
    [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(viewAdWidth));
        make.height.equalTo(@(VIEW_AD_TIP_HEIGHT));
    }];
    
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_adContentLabel.attributedText.length <= 0) {
        return;
    }

    [self updateSize];
}


- (void)updateSize {
    
    NSInteger height = 0;
    NSInteger lineCount = 0;

    [JUDIAN_READ_AdsManager computeAttributedTextHeight:_adContentLabel.attributedText width:_adContentLabel.frame.size.width height:&height lineCount:&lineCount];
    

    WeakSelf(that);
    if (lineCount == 1) {
        NSInteger yPosition = [self getDefaultTopOffset];
        
        [_adContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(14));
            make.top.equalTo(that.mas_top).offset(yPosition);
        }];
        
        [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(that.mas_bottom).offset(-yPosition);
        }];
        
    }
    else {
        NSInteger yPosition = [self getTopOffset];
        
        [_adContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(height)));
            make.top.equalTo(that.mas_top).offset(yPosition);
        }];
        
        [_viewAdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(that.mas_bottom).offset(-yPosition);
        }];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.adContentLabel sizeToFit];
    });
    
}



- (UIColor*)getTextColor {
    
    UIColor* color = RGB(0x66, 0x66, 0x66);
    if (_isDefaultStyle) {
        return color;
    }
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        color = RGB(0x99, 0x99, 0x99);
    }
    
    return color;
}



- (NSInteger)getDefaultTopOffset {
    
    NSInteger height = 12 + 14 + 13;
    NSInteger yPosition = (AD_IMAGE_HEIGHT - height) / 2 + 10;
    return yPosition;
}



- (NSInteger)getTopOffset {
    NSInteger yPosition = 10;
    return yPosition;
}


@end




@implementation JUDIAN_READ_BottomCellAdView


- (NSInteger)getTopOffset {
    NSInteger yPosition = 4;
    return yPosition;
}

- (NSInteger)getDefaultTopOffset {
    
    NSInteger yPosition = 10;
    return yPosition;
}

@end
