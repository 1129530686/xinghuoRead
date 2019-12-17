//
//  JUDIAN_READ_ContentFeedbackComfirmItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentFeedbackConfirmItem.h"

@interface JUDIAN_READ_ContentFeedbackConfirmItem ()
@property(nonatomic, weak)UIButton* confirmButton;
@end



@implementation JUDIAN_READ_ContentFeedbackConfirmItem


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UIView* topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:topLineView];
    
#if 0
    UIButton* cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelButton setTitleColor:RGB(0x66, 0x66, 0x66) forState:(UIControlStateNormal)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:cancelButton];
#endif
    
    UIButton* confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _confirmButton = confirmButton;
    [confirmButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:(UIControlStateNormal)];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self addSubview:confirmButton];
#if 0
    UIView* leftLineView = [[UIView alloc]init];
    leftLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [confirmButton addSubview:leftLineView];
#endif
    
    WeakSelf(that);
#if 0
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
        make.width.equalTo((that.mas_width)).multipliedBy(0.5);
    }];
#endif
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
        make.width.equalTo((that.mas_width));
    }];

    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.mas_top);
    }];
    
#if 0
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton.mas_left);
        make.top.equalTo(confirmButton.mas_top);
        make.width.equalTo(@(0.5));
        make.bottom.equalTo(confirmButton.mas_bottom);
    }];
#endif
}



- (void)handleTouchEvent:(UIButton*)sender {
    
    if (_block) {
        if (sender == _confirmButton) {
            _block(@(kConfrimFeedbackCmd));
        }
        else {
            NSDictionary* dictionary =  @{
                                          @"cmd":@(kCancelFeedbackCmd)
                                          };
            [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: dictionary];
        }
    }
}



@end
