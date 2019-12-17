//
//  JUDIAN_READ_ UserAppreciateFictionCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppreciateFictionCell.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_UserAppreciateFictionCell ()
@property(nonatomic, weak)UILabel* appreciateLabel;
@end



@implementation JUDIAN_READ_UserAppreciateFictionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    appreciateButton.tag = kAppreciateMoneyCmd;
    appreciateButton.layer.cornerRadius = 13;
    appreciateButton.layer.masksToBounds = YES;
    
    [appreciateButton setTitle:@"赞赏" forState:(UIControlStateNormal)];
    [appreciateButton setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
    [appreciateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appreciateButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [appreciateButton setBackgroundImage:[UIImage imageNamed:@"reader_appreciate_bg_tip"] forState:UIControlStateNormal];
    [appreciateButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:appreciateButton];
    
    
    UILabel* appreciateLabel = [[UILabel alloc]init];
    _appreciateLabel = appreciateLabel;
    appreciateLabel.textColor = RGB(0x66, 0x66, 0x66);
    appreciateLabel.font = [UIFont systemFontOfSize:12];
    appreciateLabel.text = APP_USER_APPRECIATE_TIP;
    appreciateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:appreciateLabel];
    
    
    WeakSelf(that);
    [appreciateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(110));
        make.height.equalTo(@(52));
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.centerX.equalTo(that.contentView.mas_centerX);
    }];
    
    
    [appreciateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(appreciateButton.mas_bottom).offset(5);
        make.height.equalTo(@(12));
    }];
    
}



- (void)handleTouchEvent:(UIButton*)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(sender.tag)}];
}



- (void)setViewStyle {
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.contentView.backgroundColor = [style getBgColor];
    
    _appreciateLabel.textColor = RGB(0x66, 0x66, 0x66);
    if ([style isNightMode]) {
        _appreciateLabel.textColor = RGB(0x88, 0x88, 0x88);
    }
    
}


@end
