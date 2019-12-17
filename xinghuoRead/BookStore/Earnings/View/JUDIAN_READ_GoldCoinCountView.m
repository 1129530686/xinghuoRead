//
//  JUDIAN_READ_GoldCoinCountView.m
//  xinghuoRead
//
//  Created by judian on 2019/6/20.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_GoldCoinCountView.h"
#import "UILabel+JUDIAN_READ_Label.h"


@interface JUDIAN_READ_GoldCoinCountView ()

@property(nonatomic, weak)UIImageView* bgView;
@property(nonatomic, weak)UIImageView* goldCoinView;
@property(nonatomic, weak)UILabel* countLabel;
@property(nonatomic, weak)UILabel* receiveStateLabel;
@end




@implementation JUDIAN_READ_GoldCoinCountView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        [self updateCoinCount];
    }
    
    return self;
}



- (void)addViews {
    
    UIImageView* bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"unreceive_gold_coin_bg"];
    _bgView = bgView;
    [self addSubview:bgView];
    
    
    UIImageView* goldCoinView = [[UIImageView alloc] init];
    _goldCoinView = goldCoinView;
    goldCoinView.image = [UIImage imageNamed:@"gold_coin_gray_image"];
    [self addSubview:goldCoinView];
    
    
    UILabel* countLabel = [[UILabel alloc] init];
    _countLabel = countLabel;
    countLabel.text = @"";
    countLabel.textColor = RGB(0x99, 0x99, 0x99);
    countLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:countLabel];

    
    UILabel* receiveStateLabel = [[UILabel alloc] init];
    _receiveStateLabel = receiveStateLabel;
    receiveStateLabel.text = @"";
    receiveStateLabel.textColor = RGB(0x99, 0x99, 0x99);
    receiveStateLabel.font = [UIFont systemFontOfSize:10];
    receiveStateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:receiveStateLabel];
    
    

    CGFloat goldCoinSize = 13;

    WeakSelf(that);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
    }];
    

    [goldCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(0);
        make.top.equalTo(that.mas_top).offset(4);
        make.width.equalTo(@(goldCoinSize));
        make.height.equalTo(@(goldCoinSize));
    }];
    
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goldCoinView.mas_right).offset(3);
        make.centerY.equalTo(goldCoinView.mas_centerY);
        make.width.equalTo(@(0));
        make.height.equalTo(@(12));
    }];
    
    
    [receiveStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(that.mas_width);
        make.centerX.equalTo(that.mas_centerX);
        make.top.equalTo(countLabel.mas_bottom).offset(2);
        make.height.equalTo(@(10));
    }];
    
}



- (void)updateCoinCount {

    if (TRUE) {
        _bgView.image = [UIImage imageNamed:@"receive_gold_coin_bg"];
        _goldCoinView.image = [UIImage imageNamed:@"gold_coin_image"];
        _countLabel.text = @"+10";
        _receiveStateLabel.text = @"已领取";
        
        _countLabel.textColor = RGB(0xff, 0xa0, 0x30);
        _receiveStateLabel.textColor = RGB(0xff, 0xa0, 0x30);
    }
    else {
        _bgView.image = [UIImage imageNamed:@"unreceive_gold_coin_bg"];
        _goldCoinView.image = [UIImage imageNamed:@"gold_coin_gray_image"];
        _countLabel.text = @"+10";
        _receiveStateLabel.text = @"待领取";
        
        _countLabel.textColor = RGB(0x99, 0x99, 0x99);
        _receiveStateLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
    

    CGFloat countWidth = [_countLabel getTextWidth:12];
    countWidth = ceil(countWidth);
    CGFloat goldCoinX = (63 - (countWidth + 13 + 3)) / 2;
    

    WeakSelf(that);
    [_goldCoinView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(goldCoinX);
    }];
    
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(countWidth));
    }];
    
}


@end
