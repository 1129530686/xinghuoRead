//
//  JUDIAN_READ_UserRateFictionCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserRateFictionCell.h"


typedef enum : NSUInteger {
    kAppreciateTag = 1,
    kRateTag,
} ButtongTagEnum;


@implementation JUDIAN_READ_UserRateFictionCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {

    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    appreciateButton.layer.borderColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR.CGColor;
    appreciateButton.layer.borderWidth = 0.5;
    appreciateButton.layer.cornerRadius = 3;
    appreciateButton.layer.masksToBounds = YES;
    [appreciateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, 0)];
    [appreciateButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 0)];
    appreciateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [appreciateButton setTitle:@"赞赏" forState:UIControlStateNormal];
    [appreciateButton setImage:[UIImage imageNamed:@"reader_appreciation_button"] forState:(UIControlStateNormal)];
    [appreciateButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:(UIControlStateNormal)];
    [appreciateButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    appreciateButton.tag = kAppreciateTag;
    [self.contentView addSubview:appreciateButton];
    
    UIButton* rateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rateButton.layer.borderColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR.CGColor;
    rateButton.layer.borderWidth = 0.5;
    rateButton.layer.cornerRadius = 3;
    rateButton.layer.masksToBounds = YES;
    [rateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, 0)];
    [rateButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 0)];
    rateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rateButton setTitle:@"评分" forState:UIControlStateNormal];
    [rateButton setImage:[UIImage imageNamed:@"reader_rate_button"] forState:(UIControlStateNormal)];
    [rateButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:(UIControlStateNormal)];
    [rateButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    rateButton.tag = kRateTag;
    [self.contentView addSubview:rateButton];
    
    CGFloat xPos = (frame.size.width - (120 * 2 + 16)) / 2;

    WeakSelf(that);
    [appreciateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(120));
        make.height.equalTo(@(33));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.left.equalTo(that.contentView.mas_left).offset(xPos);
    }];
    
    [rateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(120));
        make.height.equalTo(@(33));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.left.equalTo(appreciateButton.mas_right).offset(16);
    }];
    
}



- (void)handleTouchEvent:(UIButton*)sender {

    if (!_block) {
        return;
    }
    
    if (sender.tag == kAppreciateTag) {
        _block(@"appreciate");
    }
    else if (sender.tag == kRateTag) {
        _block(@"rate");
    }
    
}


@end
