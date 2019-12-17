//
//  JUDIAN_READ_LightSettingItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_LightSettingItem.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_LightSettingItem ()
@property(nonatomic, strong)UISlider * lightSlider;
@property(nonatomic, strong)UILabel* titleLabel;
@end



@implementation JUDIAN_READ_LightSettingItem

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
        [self setTitleStyle];
    }
    
    return self;
}



- (void)addViews {
    
    WeakSelf(that);
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"亮度";
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    CGFloat width = [titleLabel getTextWidth:kTitleFontSize];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceTitleLeft);
        make.height.equalTo(@(kTitleFontSize));
        make.centerY.equalTo(that.mas_centerY);
        make.width.equalTo(@(width));
    }];
    
    
    UISlider * lightSlider = [[UISlider alloc] init];
    lightSlider.minimumValue = 0.2;// 设置最小值
    lightSlider.maximumValue = 1;// 设置最大值
    lightSlider.value = (lightSlider.minimumValue + lightSlider.maximumValue) / 2;// 设置初始值
    lightSlider.continuous = YES;

    [self setButtonStyle];

    //lightSlider.thumbTintColor = [UIColor redColor];
    [lightSlider addTarget:self action:@selector(lightValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [self addSubview:lightSlider];
    
    _lightSlider = lightSlider;
    
    
    [lightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(that.mas_left).offset(kLineSpaceButtonLeft);
        make.right.equalTo(that.mas_right).offset(-14);
        //make.width.equalTo(@(kLightSlideWidth));
        make.centerY.equalTo(that.mas_centerY);
        make.height.equalTo(@(kLightSlideHeight));
        
    }];
    

}



- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel*)model {
    _lightSlider.value = model.brightness;
}



- (void)setButtonStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _lightSlider.minimumTrackTintColor = RGB(0x99, 0x99, 0x99);
        _lightSlider.maximumTrackTintColor = RGB(0xee , 0xee, 0xee);
    }
    else {
        _lightSlider.minimumTrackTintColor = RGB(0xcc, 0xcc, 0xcc);
        _lightSlider.maximumTrackTintColor = RGB(0xee, 0xee, 0xee);
    }

}



- (void)setTitleStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
    }
    else {
        _titleLabel.textColor = READER_TAB_BAR_TEXT_COLOR;
    }
}




- (void)lightValueChanged:(UISlider*)sender {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kBrightnessCmd),
                                                                                         @"value":@(sender.value)
                                                                                         }];
    
}




@end
