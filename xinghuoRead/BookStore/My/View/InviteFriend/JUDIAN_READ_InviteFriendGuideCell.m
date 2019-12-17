//
//  JUDIAN_READ_InviteFriendGuideCell.m
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_InviteFriendGuideCell.h"
#import "UIView+Common.h"
#import "JUDIAN_READ_UserGoldCoinView.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_InviteFriendGuideCell ()

@property(nonatomic, weak)UILabel* inviteCodeLabel;
@property(nonatomic, weak)UIButton* invtieCopyButton;

@property(nonatomic, weak)JUDIAN_READ_UserGoldCoinView* goldCoinView;
@property(nonatomic, weak)JUDIAN_READ_UserGoldCoinView* myFriendView;
@property(nonatomic, weak)JUDIAN_READ_UserGoldCoinView* mySubordinateView;

@property(nonatomic, weak)UIButton* sharePosterButton;
@property(nonatomic, weak)UIButton* shareLinkButton;
@property(nonatomic, weak)UIButton* watchDetailButton;
@property(nonatomic, assign)NSInteger cellHeight;
@end



@implementation JUDIAN_READ_InviteFriendGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIImageView* earningTipView = [[UIImageView alloc] init];
    earningTipView.image = [UIImage imageNamed:@"invite_friend_earning_money"];
    [self.contentView addSubview:earningTipView];
    
    UIImageView* inviteSloganImageView = [[UIImageView alloc] init];
    inviteSloganImageView.image = [UIImage imageNamed:@"invite_friend_slogan"];
    //inviteSloganImageView.contentMode = UIViewContentModeScaleAspectFill;
    //inviteSloganImageView.clipsToBounds = YES;
    [self.contentView addSubview:inviteSloganImageView];
    
    UIImage* posterTipImage = nil;
    if (iPhone6Plus) {
        posterTipImage = [UIImage imageNamed:@"invite_friend_share_poster_w"];
    }
    else {
        posterTipImage = [UIImage imageNamed:@"invite_friend_share_poster"];
    }
    
    UIButton* sharePosterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _sharePosterButton = sharePosterButton;
    [sharePosterButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [sharePosterButton setImage:posterTipImage forState:(UIControlStateNormal)];
    [sharePosterButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:sharePosterButton];
    
    UIImage* shareLinkTipImage = nil;
    if (iPhone6Plus) {
        shareLinkTipImage = [UIImage imageNamed:@"invite_friend_share_link_w"];
    }
    else {
        shareLinkTipImage = [UIImage imageNamed:@"invite_friend_share_link"];
    }
    
    UIButton* shareLinkButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _shareLinkButton = shareLinkButton;
    [shareLinkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [shareLinkButton setImage:shareLinkTipImage forState:(UIControlStateNormal)];
    [shareLinkButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:shareLinkButton];
    
    
    //[self playAnimation:inviteButton];
    
    UIImageView* ruleImageView = [[UIImageView alloc] init];
    ruleImageView.image = [UIImage imageNamed:@"invite_friend_rule_bg"];
    [self.contentView addSubview:ruleImageView];
    
    
    UIView* barView = [[UIView alloc] init];//WithFrame:CGRectMake(14, 46, ScreenWidth - 2 * 14, 67)
    //[barView clipCorner:CGSizeMake(6, 6)];
    barView.backgroundColor = [UIColor whiteColor];
    barView.layer.cornerRadius = 6;
    [self.contentView addSubview:barView];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [barView addSubview:lineView];
    
    UIView* nextLineView = [[UIView alloc] init];
    nextLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [barView addSubview:nextLineView];
    
    JUDIAN_READ_UserGoldCoinView* goldCoinView = [[JUDIAN_READ_UserGoldCoinView alloc] init];
    [goldCoinView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _goldCoinView = goldCoinView;
    [barView addSubview:goldCoinView];
    //[goldCoinView updateUserGoldCount:@"" type:@"我的金币" imageName:@"invite_friend_gold_coin"];
    
    
    JUDIAN_READ_UserGoldCoinView* myFriendView = [[JUDIAN_READ_UserGoldCoinView alloc] init];
    [myFriendView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _myFriendView = myFriendView;
    [barView addSubview:myFriendView];
    
    
    JUDIAN_READ_UserGoldCoinView* mySubordinateView = [[JUDIAN_READ_UserGoldCoinView alloc] init];
    [mySubordinateView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _mySubordinateView = mySubordinateView;
    [barView addSubview:mySubordinateView];
    
    
    WeakSelf(that);
    NSInteger sideEdge = 42;
    CGFloat height = (SCREEN_WIDTH - sideEdge * 2) * 0.21;
    height = ceil(height);
    
    _cellHeight = height + 45;
    
    [inviteSloganImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(sideEdge);
        make.right.equalTo(that.contentView.mas_right).offset(-sideEdge);
        make.top.equalTo(@(45));
        make.height.equalTo(@(height));
    }];
    
    
    NSInteger earningTipSide = 34;
    CGFloat earningTipHeight = ceil((SCREEN_WIDTH - 2 * earningTipSide) * 0.96f);
    
    _cellHeight += 13;
    _cellHeight += earningTipHeight;
    
    [earningTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(earningTipSide);
        make.right.equalTo(that.contentView.mas_right).offset(-earningTipSide);
        make.top.equalTo(inviteSloganImageView.mas_bottom).offset(13);
        make.height.equalTo(@(earningTipHeight));
    }];
    

    [sharePosterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(earningTipView.mas_left).offset(12);
        make.width.equalTo(@(posterTipImage.size.width));
        make.height.equalTo(@(shareLinkTipImage.size.height));
        make.bottom.equalTo(earningTipView.mas_bottom).offset(-35);
    }];
    
    
    [shareLinkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(earningTipView.mas_right).offset(-12);
        make.width.equalTo(@(shareLinkTipImage.size.width));
        make.height.equalTo(@(shareLinkTipImage.size.height));
        make.bottom.equalTo(earningTipView.mas_bottom).offset(-35);
    }];
    
    _cellHeight += 20;
    _cellHeight += 67;
    
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(13);
        make.right.equalTo(that.contentView.mas_right).offset(-13);
        make.top.equalTo(earningTipView.mas_bottom).offset(20);
        make.height.equalTo(@(67));
    }];
    
    
    [goldCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barView.mas_left);
        make.width.equalTo(barView.mas_width).multipliedBy(0.33);
        make.height.equalTo(barView.mas_height);
        make.top.equalTo(barView.mas_top);
    }];
    
    
    [mySubordinateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(barView.mas_right);
        make.width.equalTo(barView.mas_width).multipliedBy(0.33);
        make.height.equalTo(barView.mas_height);
        make.top.equalTo(barView.mas_top);
    }];
    
    
    [myFriendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(barView.mas_centerX);
        make.width.equalTo(barView.mas_width).multipliedBy(0.34);
        make.height.equalTo(barView.mas_height);
        make.top.equalTo(barView.mas_top);
    }];
    

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.5));
        make.top.equalTo(barView.mas_top).offset(16);
        make.bottom.equalTo(barView.mas_bottom).offset(-16);
        make.right.equalTo(goldCoinView.mas_right);
    }];
    
    
    [nextLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.5));
        make.top.equalTo(barView.mas_top).offset(16);
        make.bottom.equalTo(barView.mas_bottom).offset(-16);
        make.right.equalTo(myFriendView.mas_right);
    }];
    
    
    NSInteger ruleHeight = (SCREEN_WIDTH - 2 * 13) * 0.60;
    ruleHeight = ceil(ruleHeight);
    
    _cellHeight += 27;
    _cellHeight += ruleHeight;
    
    [ruleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(13);
        make.right.equalTo(that.contentView.mas_right).offset(-13);
        make.top.equalTo(barView.mas_bottom).offset(20);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-27);
    }];
    
    
}



- (void) playAnimation:(UIButton*)aView {
    
    WeakSelf(that);
    [UIView animateWithDuration:1 delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
        aView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
            aView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [that playAnimation:aView];
        }];
    }];

}






- (void)updateCell:(NSString*)coinCount friendCount:(NSString*)friendCount {
    
    NSString* uid = [self getCodeString];
    _inviteCodeLabel.text = [NSString stringWithFormat:@"我的邀请码：%@", uid];
    [_goldCoinView updateUserGoldCount:coinCount type:@"我的元宝" imageName:@"ingots_count_tip"];
    [_myFriendView updateUserGoldCount:friendCount type:@"累计邀请好友" imageName:@"invite_friend_group"];
    [_mySubordinateView updateUserGoldCount:@"0" type:@"我的推广员" imageName:@"invite_friend_group"];
    
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    [super layoutSubviews];
#if 0
    CGFloat viewWidth = self.frame.size.width;
    if (viewWidth <= 0) {
        return;
    }
    
    CGFloat labelWidth = [_inviteCodeLabel getTextWidth:17];
    CGFloat width = ceil(labelWidth);
    width += 22;
    width += 10;
    
    CGFloat xPos = (viewWidth - width) / 2;
    
    WeakSelf(that);
    [_inviteCodeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(xPos);
        make.width.equalTo(@(labelWidth));
    }];
#endif
}




- (void)handleTouchEvent:(id)sender {
    
    if (!_block) {
        return;
    }
    
    if (sender == _watchDetailButton) {
        _block(@"watchDetail");
        return;
    }
    
    
    if (sender == _sharePosterButton) {
        _block(@"sharePoster");
        return;
    }
    
    if (sender == _shareLinkButton) {
        _block(@"shareLink");
        return;
    }
    
    if (sender == _goldCoinView) {
        _block(@"goldCoin");
        return;
    }
    
    if (sender == _myFriendView) {
        _block(@"friendCount");
        return;
    }
    
    if (sender == _mySubordinateView) {
        _block(@"subordinateCount");
        return;
    }
    
    if (sender == _invtieCopyButton) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [self getCodeString];
        [MBProgressHUD showSuccess:@"复制成功"];
    }
    
    
    
}


- (NSString*)getCodeString {
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length <= 0) {
        uid = @"";
    }
    return uid;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (NSInteger)getCellHeight {
    return _cellHeight;
}

@end
