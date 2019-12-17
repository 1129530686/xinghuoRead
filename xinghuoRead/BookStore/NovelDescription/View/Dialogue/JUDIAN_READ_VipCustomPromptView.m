//
//  JUDIAN_READ_VipCustomPromptView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_VipCustomPromptView.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"

//用户未开通会员提示
#define USER_GUEST_TYPE 0
//激励视频提示
#define REWARD_VEDIO_TYPE 1
//充值提示
#define USER_RECHARGE_TYPE 2
//收藏提示
#define USER_COLLECTION_TYPE 3
//个人主页
#define USER_HOME_TYPE 4

#define WATCH_VIDEO_AD_TYPE 5

@interface JUDIAN_READ_VipCustomPromptView ()
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UILabel* contentLabel;
@property(nonatomic, weak)UILabel* closeTipLabel;
@property(nonatomic, weak)UIView* container;
@property(nonatomic, weak)UIButton* becomeVipButton;
@property(nonatomic, weak)UIButton* closeButton;
@property(nonatomic, copy)buttonClock block;
@property(nonatomic, copy)buttonClock cancelBlock;
@property(nonatomic, copy)NSString* needGoldCoinCount;
@property(nonatomic, assign)NSInteger viewType;
@property (nonatomic,copy) NSString  *headText;
@property (nonatomic,copy) NSString  *btnText;



@end



@implementation JUDIAN_READ_VipCustomPromptView


+ (void)createPromptView:(UIView*)container block:(buttonClock)block {
    
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithType:USER_GUEST_TYPE];
    view.frame = container.frame;
    view.block = block;
    [container addSubview:view];

}



+ (void)createAdPromptView:(UIView*)container block:(buttonClock)block {
    
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithType:REWARD_VEDIO_TYPE];
    view.frame = container.frame;
    view.block = block;
    [container addSubview:view];
    
}


+ (void)createAdPromptView:(UIView*)container block:(buttonClock)block cancel:(buttonClock)cancelBlock {
    
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithType:REWARD_VEDIO_TYPE];
    view.frame = container.frame;
    view.block = block;
    view.tag = REWARD_VIDEO_VIEW_TAG;
    view.cancelBlock = cancelBlock;
    [container addSubview:view];
    
}



+ (void)createNoFeePromptView:(UIView*)container goldCoin:(NSString*)goldCoin block:(buttonClock)block {
    
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithCount:USER_RECHARGE_TYPE count:goldCoin];
    view.frame = container.frame;
    view.block = block;
    view.needGoldCoinCount = goldCoin;
    [container addSubview:view];
    
}




+ (void)createCollectionPromptView:(UIView*)container block:(buttonClock)block cancel:(buttonClock)cancelBlock {
    
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithType:USER_COLLECTION_TYPE];
    view.frame = container.frame;
    view.block = block;
    view.cancelBlock = cancelBlock;
    [container addSubview:view];
    
}


+ (void)createVideoAdPromptView:(UIView*)container block:(buttonClock)block cancel:(buttonClock)cancelBlock {
    
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithType:WATCH_VIDEO_AD_TYPE];
    view.frame = container.frame;
    view.block = block;
    view.cancelBlock = cancelBlock;
    [container addSubview:view];
    
}




+ (void)createInfoHomePromptView:(UIView*)container text:(NSString *)text detailText:(NSString *)detailText btnText:(nonnull NSString *)btnText block:(buttonClock)block{
    JUDIAN_READ_VipCustomPromptView* view = [[JUDIAN_READ_VipCustomPromptView alloc]initWithType:USER_HOME_TYPE title:text detailText:detailText btnText:btnText];
    view.frame = container.frame;
    view.block = block;
    [container addSubview:view];
}

- (instancetype)initWithType:(NSInteger)type {
    
    self = [super init];
    if (self) {
        _viewType = type;
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        if (type == REWARD_VEDIO_TYPE) {
            //[self addRewardVedioDlg];
            [self showMoneyForAppreciateDlg];
        }
        else if(type == USER_COLLECTION_TYPE) {
            [self addCollectionTipDlg];
        }
        else if(type == WATCH_VIDEO_AD_TYPE) {
            [self addVideoAdTipDlg];
        }
        else {
            [self addViews];
        }
        
    }
    
    return self;
}


- (instancetype)initWithCount:(NSInteger)type count:(NSString*)count {
    
    self = [super init];
    if (self) {
        _viewType = type;
        _needGoldCoinCount = count;
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addViews];
        
    }
    
    return self;
}

- (instancetype)initWithType:(NSInteger)type title:(NSString*)title detailText:(NSString *)detailText btnText:(NSString *)btnText {
    
    self = [super init];
    if (self) {
        _viewType = type;
        self.headText = title;
        self.needGoldCoinCount = detailText;
        self.btnText = btnText;
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addViews];
        
    }
    
    return self;
}





- (void)addViews {
    
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 7;
    container.layer.masksToBounds = YES;
    [self addSubview:container];
    _container = container;
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:19];//weight:(UIFontWeightMedium)
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"温馨提示";
    if (_viewType == USER_HOME_TYPE) {
        titleLabel.text = self.headText;
    }
    [container addSubview:titleLabel];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* contentLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [contentLabel setAlignmentStyle:(TextInTop)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    contentLabel.attributedText = [self buildAttributedString];
    [container addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    
    
    JUDIAN_READ_VerticalAlignmentLabel* closeTipLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [closeTipLabel setAlignmentStyle:(TextInTop)];
    closeTipLabel.textAlignment = NSTextAlignmentLeft;
    closeTipLabel.numberOfLines = 0;
    closeTipLabel.attributedText = [self buildTipAttributedString];
    [container addSubview:closeTipLabel];
    _closeTipLabel = closeTipLabel;
    if (_viewType == USER_RECHARGE_TYPE) {
        _closeTipLabel.hidden = NO;
    }
    else {
        _closeTipLabel.hidden = YES;
    }

    UIButton* becomeVipButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [becomeVipButton setTitle:@"去体验" forState:(UIControlStateNormal)];
    [becomeVipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    becomeVipButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [becomeVipButton setBackgroundImage:[UIImage imageNamed:@"bounced_btn"] forState:UIControlStateNormal];
    becomeVipButton.layer.cornerRadius = 4;
    becomeVipButton.layer.masksToBounds = YES;
    [self addSubview:becomeVipButton];
    [becomeVipButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _becomeVipButton = becomeVipButton;

    UIButton* closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _closeButton = closeButton;
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_prompt_button"] forState:(UIControlStateNormal)];
    [self addSubview:closeButton];
    [closeButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSInteger height = 220;
    
    if (_viewType == REWARD_VEDIO_TYPE) {
        height = 245;
        _closeTipLabel.hidden = NO;
        _closeButton.hidden = YES;
        [_becomeVipButton setTitle:@"确定" forState:(UIControlStateNormal)];
    }
    else if(_viewType == USER_RECHARGE_TYPE) {
        _closeButton.hidden = NO;
        [_becomeVipButton setTitle:@"去赚元宝" forState:(UIControlStateNormal)];
    }else if (_viewType == USER_HOME_TYPE){
        _closeButton.hidden = NO;
        [_becomeVipButton setTitle:self.btnText forState:(UIControlStateNormal)];
        height = 195;
    }

    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.mas_left).offset(60);
        make.right.equalTo(that.mas_right).offset(-60);
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(19));
        make.top.equalTo(container.mas_top).offset(33);
    }];
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(container.mas_left).offset(10);
        make.right.equalTo(container.mas_right).offset(-10);
        make.height.equalTo(@(0));
        make.top.equalTo(titleLabel.mas_bottom).offset(30);
        
    }];
    
    
    [closeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(container.mas_left).offset(10);
        make.right.equalTo(container.mas_right).offset(-10);
        make.height.equalTo(@(0));
        make.top.equalTo(contentLabel.mas_bottom).offset(17);
        
    }];
    
    NSInteger buttonHeight = 40;
    if (iPhone6Plus) {
        buttonHeight = 44;
    }
    
    [becomeVipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(17);
        make.right.equalTo(container.mas_right).offset(-17);
        make.height.equalTo(@(buttonHeight));
        make.bottom.equalTo(container.mas_bottom).offset(-17);
    }];
    
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(33));
        make.height.equalTo(@(33));
        make.centerX.equalTo(container.mas_centerX);
        make.top.equalTo(container.mas_bottom).offset(27);
    }];
    
    
}




- (void)showMoneyForAppreciateDlg {
    
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 7;
    container.layer.masksToBounds = YES;
    [self addSubview:container];
    _container = container;
    
    UIImageView* headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"dialogue_head_image"];
    [container addSubview:headImageView];
    
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:19];//weight:(UIFontWeightMedium)
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"温馨提示";
    [container addSubview:titleLabel];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* contentLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [contentLabel setAlignmentStyle:(TextInTop)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 2;
    contentLabel.attributedText = [self buildFreeAppString];
    [container addSubview:contentLabel];
    _contentLabel = contentLabel;
    

    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _becomeVipButton = appreciateButton;
    //[appreciateButton setBackgroundImage:[UIImage imageNamed:@"user_appeciate_money_tip"] forState:UIControlStateNormal];
    //appreciateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //[appreciateButton setTitle:@"立即打赏，支持追书宝" forState:UIControlStateNormal];
    //[appreciateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSAttributedString* videoTitle = [self buildButtonTitle:0];
    [appreciateButton setAttributedTitle:videoTitle forState:UIControlStateNormal];
    appreciateButton.titleLabel.numberOfLines = 0;
    
    appreciateButton.layer.cornerRadius = 27;
    appreciateButton.layer.borderColor = RGB(0x66, 0x66, 0x66).CGColor;
    appreciateButton.layer.borderWidth = 0.5;
    appreciateButton.layer.masksToBounds = YES;
    
    [container addSubview:appreciateButton];
    [appreciateButton addTarget:self action:@selector(handleVideoTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    UIButton* closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _closeButton = closeButton;
    closeButton.layer.cornerRadius = 27;
    closeButton.layer.borderColor = RGB(0x66, 0x66, 0x66).CGColor;
    closeButton.layer.borderWidth = 0.5;
    closeButton.layer.masksToBounds = YES;
    //[closeButton setTitle:@"暂不支持，继续免费看书" forState:(UIControlStateNormal)];
    //[closeButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    //closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSAttributedString* moneyTitle = [self buildButtonTitle:1];
    [closeButton setAttributedTitle:moneyTitle forState:UIControlStateNormal];
    closeButton.titleLabel.numberOfLines = 0;
    
    [container addSubview:closeButton];
    [closeButton addTarget:self action:@selector(handleVideoTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    CGSize size = [contentLabel sizeWithAttributes:CGSizeMake(120, MAXFLOAT)];
    NSInteger contentHeight = ceil(size.height);
    
    NSInteger height = 283;
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.mas_left).offset(60);
        make.right.equalTo(that.mas_right).offset(-60);
    }];
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(105));
        make.top.equalTo(container.mas_top);
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(19));
        make.top.equalTo(container.mas_top).offset(20);
    }];
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container.mas_centerX);
        make.width.equalTo(@(120));
        make.height.equalTo(@(contentHeight));
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    

    [appreciateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container.mas_centerX);
        make.height.equalTo(@(53));
        make.width.equalTo(@(207));
        make.top.equalTo(headImageView.mas_bottom).offset(25);
    }];
    
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container.mas_centerX);
        make.height.equalTo(@(53));
        make.width.equalTo(@(207));
        make.top.equalTo(appreciateButton.mas_bottom).offset(17);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [contentLabel sizeToFit];
    });
}






- (void)addRewardVedioDlg {
    
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 7;
    container.layer.masksToBounds = YES;
    [self addSubview:container];
    _container = container;
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:19];//weight:(UIFontWeightMedium)
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"温馨提示";
    [container addSubview:titleLabel];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* contentLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [contentLabel setAlignmentStyle:(TextInTop)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    contentLabel.attributedText = [self buildAttributedString];
    [container addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    
    
    JUDIAN_READ_VerticalAlignmentLabel* closeTipLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [closeTipLabel setAlignmentStyle:(TextInTop)];
    closeTipLabel.textAlignment = NSTextAlignmentLeft;
    closeTipLabel.numberOfLines = 0;
    closeTipLabel.attributedText = [self buildTipAttributedString];
    [container addSubview:closeTipLabel];
    _closeTipLabel = closeTipLabel;
    _closeTipLabel.hidden = NO;
    
    
    UIButton* confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [confirmButton setTitle:@"好的" forState:(UIControlStateNormal)];
    [confirmButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [container addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _becomeVipButton = confirmButton;
    
    
    UIButton* closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _closeButton = closeButton;
    [closeButton setTitle:@"不用" forState:(UIControlStateNormal)];
    [closeButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [container addSubview:closeButton];
    [closeButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    UIView* topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:topLineView];
    
    
    UIView* rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:rightLineView];
    
    
    NSInteger height = 212;
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.mas_left).offset(60);
        make.right.equalTo(that.mas_right).offset(-60);
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(19));
        make.top.equalTo(container.mas_top).offset(23);
    }];
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(container.mas_left).offset(16);
        make.right.equalTo(container.mas_right).offset(-16);
        make.height.equalTo(@(0));
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        
    }];
    
    
    [closeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(container.mas_left).offset(16);
        make.right.equalTo(container.mas_right).offset(-16);
        make.height.equalTo(@(0));
        make.top.equalTo(contentLabel.mas_bottom).offset(17);
        
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(0);
        make.height.equalTo(@(40));
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_right).offset(0);
        make.height.equalTo(@(40));
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.top.equalTo(confirmButton.mas_top);
        make.height.equalTo(@(0.5));
    }];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.5));
        make.top.equalTo(closeButton.mas_top);
        make.bottom.equalTo(closeButton.mas_bottom);
        make.right.equalTo(closeButton.mas_right).offset(-0.5);
    }];
}







- (void)addCollectionTipDlg {
    
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 7;
    container.layer.masksToBounds = YES;
    [self addSubview:container];
    _container = container;
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"加入收藏，方便下次查看";
    [container addSubview:titleLabel];
    
    
    UIButton* cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelButton setTitle:@"暂不加入" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [container addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _closeButton = cancelButton;

    UIButton* collectionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [collectionButton setTitle:@"加入收藏" forState:(UIControlStateNormal)];
    [collectionButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    collectionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [container addSubview:collectionButton];
    [collectionButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _becomeVipButton = collectionButton;
    
    
    UIView* topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:topLineView];
    
    
    UIView* rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:rightLineView];
    
    
    NSInteger height = 133;
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.mas_left).offset(60);
        make.right.equalTo(that.mas_right).offset(-60);
    }];
    
    
    CGFloat centerY = (93 - 16) / 2.0f;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(16));
        make.top.equalTo(container.mas_top).offset(centerY);
    }];
    

    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(0);
        make.height.equalTo(@(40));
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    
    [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_right).offset(0);
        make.height.equalTo(@(40));
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.top.equalTo(cancelButton.mas_top);
        make.height.equalTo(@(0.5));
    }];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.5));
        make.top.equalTo(cancelButton.mas_top);
        make.bottom.equalTo(cancelButton.mas_bottom);
        make.right.equalTo(cancelButton.mas_right).offset(-0.5);
    }];
}

- (void)addVideoAdTipDlg {
    
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 7;
    container.layer.masksToBounds = YES;
    [self addSubview:container];
    _container = container;
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"友情提示";
    [container addSubview:titleLabel];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* contentLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    //contentLabel.textColor = RGB(0x66, 0x66, 0x66);
    //contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.alignmentStyle = TextInTop;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    contentLabel.attributedText = [self buildSmallVideoString:@"小视频时长约15-30秒，需要看完才能获得奖励哦~"];
    [container addSubview:contentLabel];
    
    
    
    UIButton* cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelButton setTitle:@"放弃奖励" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [container addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _closeButton = cancelButton;
    
    UIButton* collectionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [collectionButton setTitle:@"看小视频" forState:(UIControlStateNormal)];
    [collectionButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    collectionButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [container addSubview:collectionButton];
    [collectionButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _becomeVipButton = collectionButton;
    
    
    UIView* topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:topLineView];
    
    
    UIView* rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:rightLineView];
    
    
    NSInteger height = 147 + 5;
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.mas_left).offset(60);
        make.right.equalTo(that.mas_right).offset(-60);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(16));
        make.top.equalTo(container.mas_top).offset(23);
    }];
    
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(0);
        make.height.equalTo(@(40));
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    
    [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_right).offset(0);
        make.height.equalTo(@(40));
        make.bottom.equalTo(container.mas_bottom).offset(0);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
    }];
    
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.top.equalTo(cancelButton.mas_top);
        make.height.equalTo(@(0.5));
    }];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.5));
        make.top.equalTo(cancelButton.mas_top);
        make.bottom.equalTo(cancelButton.mas_bottom);
        make.right.equalTo(cancelButton.mas_right).offset(-0.5);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(20);
        make.right.equalTo(container.mas_right).offset(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
        make.bottom.equalTo(cancelButton.mas_top).offset(-10);
    }];
}


- (NSMutableAttributedString*)buildFreeAppString {
    
    NSString* text = @"追书宝是一个不收费完全免费的小说APP";

    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];
    
    return attributedText;
}

- (NSMutableAttributedString*)buildSmallVideoString:(NSString*)text {
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x66, 0x66, 0x66) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}


- (NSMutableAttributedString*)buildMoneyString:(NSString*)count {
    
    NSString* text = [NSString stringWithFormat:@"打赏 %@ 元红包支持开发团队", count];
    NSRange range = [text rangeOfString:count];
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
   // [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, [text length])];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(range.location, range.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(range.location, range.length)];
    
    return attributedText;
}



- (NSMutableAttributedString*)buildAttributedString {
    
    NSString* text = @"开通VIP会员可享受缓存 离线阅读哦！";
    if (_viewType == REWARD_VEDIO_TYPE) {
        text = @"您当前处于长时间阅读状态，看个广告放松一下吧~";
    }
    else if (_viewType == USER_RECHARGE_TYPE) {
        text = [NSString stringWithFormat:@"需要%@元宝", _needGoldCoinCount];
    }
    else if (_viewType == USER_HOME_TYPE){
        text = _needGoldCoinCount;
    }
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x66, 0x66, 0x66) range:NSMakeRange(0, [text length])];

    
    return attributedText;
}




- (NSMutableAttributedString*)buildTipAttributedString {
    
    NSString* text = @"视频结束后，点击右上角关闭按钮，继续看书";
    if (_viewType == USER_RECHARGE_TYPE) {
        text = @"当前元宝不足，去做任务赚取元宝吧";
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x99, 0x99, 0x99) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}





- (NSMutableAttributedString*)buildButtonTitle:(NSInteger)index {
    
    NSString* text = @"";
    NSInteger endIndex = 0;
    if (index == 0) {
        text = @"看个小视频广告  再继续阅读\r（广告结束后右上角可关闭）";
    }
    else {
        text = @"打赏8元红包  支持追书宝\r（打赏后，永久去除视频广告）";
    }
    
    endIndex = [text rangeOfString:@"\r"].location;
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:7];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, endIndex)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, endIndex)];
    
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(endIndex, [text length] - endIndex)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x99, 0x99, 0x99) range:NSMakeRange(endIndex, [text length] - endIndex)];
    
    
    return attributedText;
}






- (void)layoutSubviews {
    [super layoutSubviews];


    if (_contentLabel.attributedText) {
        
        CGFloat height = [self getCellHeight:_container.frame.size.width label:_contentLabel];
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(height)));
        }];
    }
    
    if (_closeTipLabel.attributedText) {
        
        CGFloat height = [self getCellHeight:_container.frame.size.width label:_closeTipLabel];
        [_closeTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(height)));
        }];
    }

}



- (CGFloat)getCellHeight:(CGFloat)width label:(UILabel*)label {
    CGFloat height = [label sizeWithAttributes:CGSizeMake(width - 2 * 33, MAXFLOAT)].height;;
    return  ceil(height);
}



- (void)handleTouchEvent:(id)sender {
    if (sender == _becomeVipButton) {
        if (_block) {
            _block(@"");
        }
        [self removeFromSuperview];
    }
    else {
        
        if (_cancelBlock) {
            _cancelBlock(@"");
        }
        
        [self removeFromSuperview];
    }
    
}



- (void)handleVideoTouchEvent:(id)sender {
    if (sender == _becomeVipButton) {
        if (_block) {
            _block(@"");
        }
        [self removeFromSuperview];
    }
    else {
        
        if (_cancelBlock) {
            _cancelBlock(@"");
        }
    }
    
}




@end
