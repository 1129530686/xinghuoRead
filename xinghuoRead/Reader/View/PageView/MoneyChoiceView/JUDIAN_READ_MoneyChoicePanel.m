//
//  JUDIAN_READ_MoneyChoicePanel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_MoneyChoicePanel.h"
#import "JUDIAN_READ_AttributedButton.h"
#import "JUDIAN_READ_AppreciateAmountModel.h"

@interface JUDIAN_READ_MoneyChoicePanel ()
@property(nonatomic, copy)NSArray* amountArray;
@end


@implementation JUDIAN_READ_MoneyChoicePanel


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    UILabel* tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = RGB(0x99, 0x99, 0x99);
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"您的一点心意，都在给我们加油！";
    [self addSubview:tipLabel];
    
    NSInteger buttonWidth = (SCREEN_WIDTH - 2 * 14 - 2 * 16) / 3;
    
    //1、3、18、50、88、188
    //第一行
    JUDIAN_READ_AttributedButton* rmb1Button = [JUDIAN_READ_AttributedButton buttonWithType:(UIButtonTypeCustom)];
    [rmb1Button setTitleText:@"0" click:NO];
    [rmb1Button setRoundBorder];
    rmb1Button.tag = kRmbButtonTag;
    [rmb1Button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:rmb1Button];
    
    
    JUDIAN_READ_AttributedButton* rmb3Button = [JUDIAN_READ_AttributedButton buttonWithType:(UIButtonTypeCustom)];
    [rmb3Button setTitleText:@"0" click:YES];
    [rmb3Button setRoundBorder];
    rmb3Button.tag = kRmbButtonTag + 1;
    [rmb3Button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:rmb3Button];
    

    JUDIAN_READ_AttributedButton* rmb18Button = [JUDIAN_READ_AttributedButton buttonWithType:(UIButtonTypeCustom)];
    [rmb18Button setTitleText:@"0" click:NO];
    [rmb18Button setRoundBorder];
    rmb18Button.tag = kRmbButtonTag + 2;
    [rmb18Button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:rmb18Button];
    
    //第二行
    JUDIAN_READ_AttributedButton* rmb50Button = [JUDIAN_READ_AttributedButton buttonWithType:(UIButtonTypeCustom)];
    [rmb50Button setTitleText:@"0" click:NO];
    [rmb50Button setRoundBorder];
    rmb50Button.tag = kRmbButtonTag + 3;
    [rmb50Button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:rmb50Button];
    

    JUDIAN_READ_AttributedButton* rmb88Button = [JUDIAN_READ_AttributedButton buttonWithType:(UIButtonTypeCustom)];
    [rmb88Button setTitleText:@"0" click:NO];
    [rmb88Button setRoundBorder];
    rmb88Button.tag = kRmbButtonTag + 4;
    [rmb88Button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:rmb88Button];
    
    
    JUDIAN_READ_AttributedButton* rmb188Button = [JUDIAN_READ_AttributedButton buttonWithType:(UIButtonTypeCustom)];
    [rmb188Button setTitleText:@"0" click:NO];
    [rmb188Button setRoundBorder];
    rmb188Button.tag = kRmbButtonTag + 5;
    [rmb188Button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:rmb188Button];
    
    
    WeakSelf(that);
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(12));
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-14);
        make.top.equalTo(that.mas_top).offset(14);
    }];
    
    
    [rmb1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(50));
        make.top.equalTo(tipLabel.mas_bottom).offset(14);
    }];
    
    
    [rmb3Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rmb1Button.mas_right).offset(16);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(50));
        make.top.equalTo(rmb1Button.mas_top);
    }];
    
    
    [rmb18Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(50));
        make.top.equalTo(rmb1Button.mas_top);
    }];

    
    [rmb50Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(50));
        make.top.equalTo(rmb1Button.mas_bottom).offset(17);
    }];
    
    
    
    [rmb88Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rmb50Button.mas_right).offset(16);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(50));
        make.top.equalTo(rmb1Button.mas_bottom).offset(17);
    }];
    
    
    [rmb188Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(50));
        make.top.equalTo(rmb1Button.mas_bottom).offset(17);
    }];
}




- (void)handleTouchEvent:(JUDIAN_READ_AttributedButton*)sender {
    for (NSInteger tag = 0; tag < 6; tag++) {
        JUDIAN_READ_AttributedButton* button = [self viewWithTag:kRmbButtonTag + tag];
        [button initDefaultState];
        [button setRoundBorder];
    }
    [sender clickButton];
    if (sender.isClicked) {
        sender.layer.borderWidth = 0;
    }
    else {
        [sender setRoundBorder];
    }
    
    if (_block) {
       JUDIAN_READ_AppreciateAmountModel* model = [self getSelectedModel];
        _block(model);
    }

}



- (void)updateAmount:(NSArray*)array {
    _amountArray = array;
    
    for (NSInteger index = 0; index < 6; index++) {
        JUDIAN_READ_AttributedButton* button = [self viewWithTag:kRmbButtonTag + index];
        
        JUDIAN_READ_AppreciateAmountModel* model = _amountArray[index];
        
        if (index == 1) {
            button.layer.borderWidth = 0;
            [button setTitleText:model.price click:YES];
        }
        else {
            [button setRoundBorder];
            [button setTitleText:model.price click:NO];
        }
    }

}


- (JUDIAN_READ_AppreciateAmountModel*)getSelectedModel {
    for (NSInteger index = 0; index < 6; index++) {
        JUDIAN_READ_AttributedButton* button = [self viewWithTag:kRmbButtonTag + index];
        if ([button getClickedState]) {
            JUDIAN_READ_AppreciateAmountModel* model = _amountArray[index];
            return model;
        }
    }
    return nil;
}


@end
