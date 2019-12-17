//
//  JUDIAN_READ_UserEarningsNavigationView.m
//  xinghuoRead
//
//  Created by judian on 2019/6/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_UserEarningsNavigationView ()

@property(nonatomic, weak)UIButton* backButton;
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UIButton* rightButton;
@property(nonatomic, weak)UIView* lineView;

@end




@implementation JUDIAN_READ_UserEarningsNavigationView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
    
}


- (void)addViews {
    
    UIButton* backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _backButton = backButton;
    UIImage* leftArrowImage = [UIImage imageNamed:@"nav_return_white"];
    [backButton setImage:leftArrowImage forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:backButton];
    
    
    UIButton* ruleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _rightButton = ruleButton;
    ruleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [ruleButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [ruleButton setTitle:@"" forState:UIControlStateNormal];
    ruleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:ruleButton];
    [ruleButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel* titleLabel = [[UILabel alloc]init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"";
    [self addSubview:titleLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:lineView];
    
    
    CGFloat statusViewHeight = 0;
    if (iPhoneX) {
        statusViewHeight = 44;
    }
    else {
        statusViewHeight = 20;
    }
    
   // CGFloat titlePosition = statusViewHeight + 16;
    
    WeakSelf(that);
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14 + 2.5);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
        make.bottom.equalTo(that.mas_bottom);
        //make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    
    
    
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(10);
        make.right.equalTo(that.mas_right).offset(-10);
        make.height.equalTo(@(18));
        //make.top.equalTo(that.mas_top).offset(titlePosition);
        make.centerY.equalTo(backButton.mas_centerY);
    }];


    
    CGFloat ruleWidth = [ruleButton.titleLabel getTextWidth:14] + 10;
    [ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(ceil(ruleWidth)));
        make.height.equalTo(@(18));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.mas_bottom);
    }];

}



- (void)handleTouchEvent:(UIButton*)sender {

    if (_block) {
        
        if (_backButton == sender) {
            _block(@"back");
        }
        else {
            _block(@"rule");
        }
    }
}


- (void)updateEarningsNavigation:(NSString*)title rightTitle:(NSString*)rightTitle {
    
    _lineView.hidden = YES;
    
    UIImage* leftArrowImage = [UIImage imageNamed:@"nav_return_white"];
    [_backButton setImage:leftArrowImage forState:(UIControlStateNormal)];
    
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor whiteColor];
    
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    if (rightTitle.length > 0) {
        CGFloat ruleWidth = [_rightButton.titleLabel getTextWidth:14];
        ruleWidth = ceil(ruleWidth);
        [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(ruleWidth));
        }];
    }
}



- (void)updateTitle:(NSString*)title rightTitle:(NSString*)rightTitle {
    
    _lineView.hidden = YES;
    
    UIImage* leftArrowImage = [UIImage imageNamed:@"nav_return_white"];
    [_backButton setImage:leftArrowImage forState:(UIControlStateNormal)];
    
    _titleLabel.text = title;
    _titleLabel.textColor = [UIColor whiteColor];
    
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _rightButton.layer.cornerRadius = 12;
    _rightButton.layer.masksToBounds = YES;
    _rightButton.backgroundColor = RGBA(0xff, 0xff, 0xff, 0.2);
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _rightButton.hidden = YES;
    if (rightTitle.length > 0) {
        _rightButton.hidden = NO;
        //CGFloat ruleWidth = [_rightButton.titleLabel getTextWidth:14] + 20;
        //ruleWidth = ceil(ruleWidth);
        [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(73));
            make.height.equalTo(@(23));
        }];
    }
    
}




- (void)updateUserBriefNavigation:(NSString*)title rightTitle:(NSString*)rightTitle {
    UIImage* leftArrowImage = [UIImage imageNamed:@"nav_return_black"];
    [_backButton setImage:leftArrowImage forState:(UIControlStateNormal)];
    
    _titleLabel.text = title;
    _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    
    if (rightTitle.length > 0) {
        [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
        CGFloat ruleWidth = [_rightButton.titleLabel getTextWidth:14];
        ruleWidth = ceil(ruleWidth);
        [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(ruleWidth));
        }];
    }

}


@end
