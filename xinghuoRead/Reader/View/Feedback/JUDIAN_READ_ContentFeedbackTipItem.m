//
//  JUDIAN_READ_ContentFeedbackTitleItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentFeedbackTipItem.h"
#import "UILabel+JUDIAN_READ_Label.h"

@implementation JUDIAN_READ_ContentFeedbackTipItem


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
    NSInteger fontSize = 17;
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.text = @"意见反馈";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:titleLabel];
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(fontSize));
        make.centerY.equalTo(that.mas_centerY);
    }];
}

@end



@implementation JUDIAN_READ_FeedbackContactItem


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}


- (void)addViews {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *qqGroup = [def objectForKey:QQ_Group];
    NSString* qqGroupTip = [NSString stringWithFormat:@"追书宝QQ群：%@", qqGroup];
    
    NSString *weixiin = [def objectForKey:WEI_XIN_CUSTOMER];
    NSString* weixinTip = [NSString stringWithFormat:@"客服微信号：%@", weixiin];
    
    UITextView* qqLabel = [[UITextView alloc] init];
    qqLabel.editable = NO;
    qqLabel.scrollEnabled = NO;
    qqLabel.textAlignment = NSTextAlignmentLeft;
    qqLabel.textContainerInset = UIEdgeInsetsMake(0, -1, 0, 0);
    qqLabel.textColor = RGB(0x99, 0x99, 0x99);
    qqLabel.font = [UIFont systemFontOfSize:12];
    qqLabel.text = qqGroupTip;
    [self addSubview:qqLabel];
    
    
    UIButton* qqGroupButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage* image = [UIImage imageNamed:@"qq_group_tip"];
    [qqGroupButton setBackgroundImage:image forState:UIControlStateNormal];
    [qqGroupButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:qqGroupButton];

    UITextView* weixinLabel = [[UITextView alloc] init];
    weixinLabel.editable = NO;
    weixinLabel.scrollEnabled = NO;
    weixinLabel.textAlignment = NSTextAlignmentLeft;
    weixinLabel.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0);
    weixinLabel.textColor = RGB(0x99, 0x99, 0x99);
    weixinLabel.font = [UIFont systemFontOfSize:12];
    weixinLabel.text = weixinTip;
    [self addSubview:weixinLabel];
    
    CGFloat qqWidth = [self getTextViewWidth:qqLabel];
    qqWidth = ceil(qqWidth);
    
    WeakSelf(that);
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(qqWidth));
        make.height.equalTo(@(17));
        make.left.equalTo(that.mas_left).offset(14);
        make.top.equalTo(that.mas_top);
    }];
    
    [qqGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqLabel.mas_right).offset(10);
        make.width.equalTo(@(73));
        make.height.equalTo(@(17));
        make.top.equalTo(that.mas_top);
    }];
    
    
    CGFloat weixinWidth = [self getTextViewWidth:weixinLabel];
    weixinWidth = ceil(weixinWidth);
    [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(weixinWidth));
        make.height.equalTo(@(17));
        make.left.equalTo(that.mas_left).offset(14);
        make.top.equalTo(qqGroupButton.mas_bottom).offset(4);
    }];
    
    
}


- (CGFloat) getTextViewWidth:(UITextView *)textView{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(MAXFLOAT, 12)];
    return ceil(sizeToFit.width);
}


- (void)handleTouchEvent:(id)sender {
    [JUDIAN_READ_TestHelper joinQQGroup];
}

@end
