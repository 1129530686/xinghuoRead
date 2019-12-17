//
//  JUDIAN_READ_UserGoldCoinView.m
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserGoldCoinView.h"
#import "UILabel+JUDIAN_READ_Label.h"


@interface JUDIAN_READ_UserGoldCoinView ()
@property(nonatomic, weak)UIButton* button;
@property(nonatomic, strong)UILabel* typeLabel;
@property(nonatomic, strong)UILabel* countLabel;
@end


@implementation JUDIAN_READ_UserGoldCoinView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {

#if 0
    UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.userInteractionEnabled = NO;
    _button = button;
    [button setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:button];
#endif
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = RGB(0x33, 0x33, 0x33);
    _countLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countLabel];
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.textColor = RGB(0x33, 0x33, 0x33);
    _typeLabel.font = [UIFont systemFontOfSize:12];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_typeLabel];


    WeakSelf(that);
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(4);
        make.right.equalTo(that.mas_right).offset(-4);
        make.height.equalTo(@(15));
        make.top.equalTo(that.mas_top).offset(16);
    }];
    

    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(10);
        make.right.equalTo(that.mas_right).offset(-10);
        make.height.equalTo(@(12));
        make.top.equalTo(that.countLabel.mas_bottom).offset(9);
    }];
    
}



- (void)updateUserGoldCount:(NSString*)title type:(NSString*)type imageName:(NSString*)imageName {
#if 0
    UIImage* image = [UIImage imageNamed:imageName];

    if ([imageName isEqualToString:@"invite_friend_group"]) {
        WeakSelf(that);
        [_button mas_updateConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(that.mas_top).offset(13);
            make.height.equalTo(@(22));
        }];
    }
    
    [_button setImage:image forState:(UIControlStateNormal)];
    [_button setTitle:title forState:UIControlStateNormal];
    
    [_button setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
#endif
    _countLabel.text = title;
    _typeLabel.text = type;
    
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    [super layoutSubviews];

}


@end
