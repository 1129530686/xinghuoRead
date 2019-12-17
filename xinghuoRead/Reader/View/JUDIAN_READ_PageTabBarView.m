//
//  JUDIAN_READ_PageTabBarView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/24.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PageTabBarView.h"
#import "JUDIAN_READ_VerticalStyleButton.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_PageTabBarView ()
@property(nonatomic, weak)UIView* lineView;
@end


@implementation JUDIAN_READ_PageTabBarView


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.backgroundColor = RGB(0xff, 0xff, 0xff);
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}



- (void)addViews {
    
    NSMutableArray *array = [NSMutableArray array];
    
    JUDIAN_READ_VerticalStyleButton *catalogButton = [[JUDIAN_READ_VerticalStyleButton alloc] initWithTitle:CGRectMake(0, 27, 26, 10) imageFrame:CGRectMake(0, 0, 20, 20)];
    [catalogButton setTitle:@"目录" forState:UIControlStateNormal];
    [array addObject:catalogButton];
    [self addSubview:catalogButton];
    
    catalogButton.tag = kCatalogCmd;
    [catalogButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    JUDIAN_READ_VerticalStyleButton *nightButton = [[JUDIAN_READ_VerticalStyleButton alloc] initWithTitle:CGRectMake(0, 27, 26, 10) imageFrame:CGRectMake(0, 0, 20, 20)];
    [nightButton setTitle:@"夜间" forState:UIControlStateNormal];
    [array addObject:nightButton];
    [self addSubview:nightButton];
    nightButton.tag = kNightCmd;
    [nightButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_VerticalStyleButton *settingButton = [[JUDIAN_READ_VerticalStyleButton alloc] initWithTitle:CGRectMake(0, 27, 26, 10) imageFrame:CGRectMake(0, 0, 20, 20)];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [array addObject:settingButton];
    [self addSubview:settingButton];
    [settingButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    settingButton.tag = kStyleSettingCmd;
    
    CGFloat width = 26.0f;
    CGFloat height = 36.0f;
    
    
#if 0
    // 计算间隔距离
    CGFloat padding = (SCREEN_WIDTH - width * 3) / 4;
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:width leadSpacing:padding tailSpacing:padding];
    
    WeakSelf(that);
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(that.mas_centerY);
        make.height.equalTo(@(height));
        make.width.equalTo(@(width));
    }];
#endif
    

    WeakSelf(that);
    
    [catalogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        
        make.left.equalTo(that.mas_left).offset(50);
        make.top.equalTo(that.mas_top).offset(14);
        //make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [nightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        //make.centerY.equalTo(that.mas_centerY);
        make.top.equalTo(that.mas_top).offset(13);
        make.centerX.equalTo(that.mas_centerX);
    }];
    
    
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        
        make.right.equalTo(that.mas_right).offset(-50);
        //make.centerY.equalTo(that.mas_centerY);
        make.top.equalTo(that.mas_top).offset(13);
    }];
    
    
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:lineView];
    _lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.width.equalTo(that.mas_width);
        make.top.equalTo(that.mas_top);
    }];

}



- (void)setViewStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        
        self.backgroundColor = RGB(0x33, 0x33, 0x33);
        
        UIButton* catalogButton = [self viewWithTag:kCatalogCmd];
        [catalogButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
        [catalogButton setImage:[UIImage imageNamed:@"reader_catalog_tip_n"] forState:UIControlStateNormal];
        
        
        UIButton* nigthButton = [self viewWithTag:kNightCmd];
        [nigthButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
        [nigthButton setTitle:@"白天" forState:UIControlStateNormal];
        [nigthButton setImage:[UIImage imageNamed:@"reader_sun_tip"] forState:UIControlStateNormal];
        
        
        UIButton* settingButton = [self viewWithTag:kStyleSettingCmd];
        [settingButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
        [settingButton setImage:[UIImage imageNamed:@"reader_setting_tip_n"] forState:UIControlStateNormal];
    
        _lineView.backgroundColor = RGB(0x33, 0x33, 0x33);
    }
    else {
        
        self.backgroundColor = RGB(0xff, 0xff, 0xff);
        
        UIButton* catalogButton = [self viewWithTag:kCatalogCmd];
        [catalogButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
        [catalogButton setImage:[UIImage imageNamed:@"reader_catalog_tip"] forState:UIControlStateNormal];
        
        UIButton* nigthButton = [self viewWithTag:kNightCmd];
        [nigthButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
        [nigthButton setTitle:@"夜间" forState:UIControlStateNormal];
        [nigthButton setImage:[UIImage imageNamed:@"reader_night_tip"] forState:UIControlStateNormal];
        

        UIButton* settingButton = [self viewWithTag:kStyleSettingCmd];
        [settingButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
        [settingButton setImage:[UIImage imageNamed:@"reader_setting_tip"] forState:UIControlStateNormal];
        
        _lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    }
}



- (void)handleTouchEvent:(UIButton*)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(sender.tag)}];
    
}


@end
