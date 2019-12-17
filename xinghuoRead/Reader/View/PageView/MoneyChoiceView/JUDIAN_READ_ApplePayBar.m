//
//  JUDIAN_READ_ApplePayBar.m
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ApplePayBar.h"

@implementation JUDIAN_READ_ApplePayBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
   
    UIImageView* payImageView = [[UIImageView alloc]init];
    payImageView.image = [UIImage imageNamed:@"members_pay_apple"];
    [self addSubview:payImageView];
    
    UILabel* payLabel = [[UILabel alloc]init];
    payLabel.textColor = RGB(0x33, 0x33, 0x33);
    payLabel.font = [UIFont systemFontOfSize:12];
    payLabel.text = @"Apple支付";
    [self addSubview:payLabel];
    
    
    UIImageView* choiceImageView = [[UIImageView alloc]init];
    choiceImageView.image = [UIImage imageNamed:@"members_pay_selected"];
    [self addSubview:choiceImageView];
    
    WeakSelf(that);
    [payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(34));
        make.height.equalTo(@(34));
        make.left.equalTo(that.mas_left).offset(14);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payImageView.mas_right).offset(10);
        make.width.equalTo(@(100));
        make.height.equalTo(@(12));
        make.centerY.equalTo(payImageView.mas_centerY);
    }];
    
    
    [choiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(16));
        make.height.equalTo(@(16));
        make.right.equalTo(that.mas_right).offset(-14);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
}


@end
