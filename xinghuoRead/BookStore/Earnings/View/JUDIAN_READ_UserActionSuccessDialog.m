//
//  JUDIAN_READ_UserActionSuccessDialog.m
//  xinghuoRead
//
//  Created by judian on 2019/7/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserActionSuccessDialog.h"

@interface JUDIAN_READ_UserActionSuccessDialog ()
@property(nonatomic, strong)dispatch_source_t timer;
@property(nonatomic, weak)UIImageView* successTipImageView;
@property(nonatomic, weak)UIButton* receiveGoldCoinButton;
@property(nonatomic, weak)UILabel* countTipLabel;
@property(nonatomic, copy)modelBlock block;
@property(nonatomic, copy)NSString* titleTip;
@end


@implementation JUDIAN_READ_UserActionSuccessDialog


+ (void)createPromptView:(UIView*)container count:(NSString*)count title:(NSString*)title block:(modelBlock)block {
    JUDIAN_READ_UserActionSuccessDialog* view = [[JUDIAN_READ_UserActionSuccessDialog alloc] initWithFrame:container.bounds title:title];
    view.block = block;
    [view updateCount:count];
    [container addSubview:view];
}




- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title{
    self = [super initWithFrame:frame];
    if (self) {
        _titleTip = title;
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {
    
    UIImageView* imageView = [[UIImageView alloc] init];
    _successTipImageView = imageView;
    imageView.image = [UIImage imageNamed:@"received_coin_success_tip"];
    [self addSubview:imageView];
    
    
    UILabel* countTipLabel = [[UILabel alloc] init];
    _countTipLabel = countTipLabel;
    countTipLabel.font = [UIFont systemFontOfSize:17];
    countTipLabel.textColor = [UIColor whiteColor];
    countTipLabel.text = @"";
    countTipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:countTipLabel];
    

    UILabel* receivedTipLabel = [[UILabel alloc] init];
    receivedTipLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    receivedTipLabel.textColor = RGB(0xff, 0xed, 0x55);
    receivedTipLabel.text = _titleTip;
    receivedTipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:receivedTipLabel];
    
    
    UIButton* receiveGoldCoinButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _receiveGoldCoinButton = receiveGoldCoinButton;
    [receiveGoldCoinButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [receiveGoldCoinButton setTitle:@"看小视频  再领20元宝" forState:UIControlStateNormal];
    receiveGoldCoinButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [receiveGoldCoinButton setTitleEdgeInsets:UIEdgeInsetsMake(-4, 0, 0, 0)];
    [receiveGoldCoinButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    [receiveGoldCoinButton setBackgroundImage:[UIImage imageNamed:@"user_received_button"] forState:(UIControlStateNormal)];
    [self addSubview:receiveGoldCoinButton];
    

    UIButton* closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"user_received_close_button"] forState:(UIControlStateNormal)];
    [self addSubview:closeButton];
    
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(272));
        make.height.equalTo(@(345));
        make.centerX.equalTo(that.mas_centerX).offset(-5);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [receiveGoldCoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(212));
        make.height.equalTo(@(47));
        make.centerX.equalTo(that.mas_centerX).offset(2);
        make.bottom.equalTo(imageView.mas_bottom).offset(-24);
    }];
    
    
    [countTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(17));
        make.bottom.equalTo(receiveGoldCoinButton.mas_top).offset(-33);
    }];
    
    
    
    [receivedTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(24));
        make.bottom.equalTo(countTipLabel.mas_top).offset(-30);
    }];
    
    
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(33));
        make.height.equalTo(@(33));
        
        make.right.equalTo(that.mas_right).offset(-27);
        make.bottom.equalTo(imageView.mas_top);
        
    }];
    

#if 0
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        receiveGoldCoinButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            receiveGoldCoinButton.transform = CGAffineTransformIdentity;
        }];
    }];
#endif
    

    

}



- (void)handleTouchEvent:(UIButton*)sender {
    [self removeFromSuperview];
    if (_receiveGoldCoinButton == sender) {
        if (_block) {
            _block(nil);
        }
    }
}



- (void)updateCount:(NSString*)count {
    _countTipLabel.text = [NSString stringWithFormat:@"恭喜您获得%@元宝",count];
}



- (void)dealloc {


}



@end
