//
//  JUDIAN_READ_UserAppreciateMoneyCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/31.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppreciateMoneyCell.h"
#import "JUDIAN_READ_MoneyChoicePanel.h"
#import "JUDIAN_READ_ApplePayBar.h"



@interface JUDIAN_READ_UserAppreciateMoneyCell ()<UITextViewDelegate>
@property(nonatomic, weak)JUDIAN_READ_ApplePayBar* payStyleBar;
@property(nonatomic, strong)UITextView* warmTipLabel;
@property(nonatomic, weak)UIButton *settingButton;
@end



@implementation JUDIAN_READ_UserAppreciateMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addRmbChoicePanel];
        //[self addPayStyleBar];
        [self addSettingButton];
        [self addWarmTipView];
    }
    
    return self;
}




- (void)addRmbChoicePanel {
    JUDIAN_READ_MoneyChoicePanel* panel = [[JUDIAN_READ_MoneyChoicePanel alloc]init];
    _choicePanel = panel;
    [self.contentView addSubview:panel];
    
    WeakSelf(that);
    
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(182));
        make.top.equalTo(that.contentView.mas_top);
    }];
    
}






- (void)addPayStyleBar {
    
    JUDIAN_READ_ApplePayBar* bar = [[JUDIAN_READ_ApplePayBar alloc]init];
    _payStyleBar = bar;
    [self.contentView addSubview:bar];
    
    WeakSelf(that);
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.choicePanel.mas_bottom);
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(34));
        
    }];
    
}



- (void)addSettingButton {
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingButton = settingButton;
    [settingButton setText:@"设置我的支付方式" titleFontSize:12 titleColot:kThemeColor];
    [settingButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [settingButton addTarget:self action:@selector(enterPayStyleView) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:settingButton];
    
    WeakSelf(that);
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.choicePanel.mas_bottom);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(120));
        make.height.equalTo(@(14));
    }];
}



- (void)addWarmTipView {
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGB(0x99, 0x99, 0x99);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"温馨提示:";
    [self.contentView addSubview:titleLabel];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *qqGroup = [def objectForKey:QQ_Group];
    
    UITextView* qqLabel = [[UITextView alloc] init];
    qqLabel.editable = NO;
    qqLabel.scrollEnabled = NO;
    qqLabel.textAlignment = NSTextAlignmentLeft;
    qqLabel.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0);
    qqLabel.textColor = RGB(0x99, 0x99, 0x99);
    qqLabel.font = [UIFont systemFontOfSize:12];
    qqLabel.text = [NSString stringWithFormat:APP_PAY_CHAPTER_TIP, qqGroup];

    [self.contentView addSubview:qqLabel];
    
    CGFloat textViewWidth = [self getTextViewWidth:qqLabel height:12];
   
    UIButton* qqGroupButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage* image = [UIImage imageNamed:@"qq_group_tip"];
    [qqGroupButton setBackgroundImage:image forState:UIControlStateNormal];
    [qqGroupButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView  addSubview:qqGroupButton];

#if 0
    CGSize constraintSize = CGSizeMake((SCREEN_WIDTH - 2 * 14), MAXFLOAT);
    CGSize size = [_warmTipLabel sizeThatFits:constraintSize];
    CGFloat height = ceil(size.height);
#endif
    
    WeakSelf(that);
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(12));
        make.top.equalTo(that.settingButton.mas_bottom).offset(25);
    }];
    
    [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(textViewWidth));
        make.height.equalTo(@(14));
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        //make.top.equalTo(that.warmTipLabel.mas_bottom).offset(6);
    }];
    
    
    [qqGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqLabel.mas_right).offset(2);
        make.width.equalTo(@(73));
        make.height.equalTo(@(17));
        make.centerY.equalTo(qqLabel.mas_centerY);
    }];
    
}



- (void)enterPayStyleView {
    if (_block) {
        _block(@"payStyle");
    }
}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    if (_block) {
        _block(@"history");
    }
    
    return NO;
}

- (CGFloat) getTextViewWidth:(UITextView *)textView height:(NSInteger)height {
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(MAXFLOAT, height)];
    return ceil(sizeToFit.width);
}


- (void)handleTouchEvent:(id)sender {
    [JUDIAN_READ_TestHelper joinQQGroup];
}


@end
