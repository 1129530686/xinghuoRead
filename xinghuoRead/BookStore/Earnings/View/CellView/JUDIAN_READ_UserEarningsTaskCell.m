//
//  JUDIAN_READ_UserEarningsTaskCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserEarningsTaskCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_UserEarningsTaskCell ()
@property(nonatomic, weak)UIImageView* taskTypeImageView;
@property(nonatomic, weak)UILabel* tipLabel;
@property(nonatomic, weak)UILabel* rmbCountLabel;
@property(nonatomic, weak)UILabel* describeLabel;
@property(nonatomic, weak)UIButton* receiveButton;
@property(nonatomic, weak)UIImageView* rmbImageView;

@end




@implementation JUDIAN_READ_UserEarningsTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];

}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = [UIColor clearColor];
        [self addTaskView];
        [self addBottomLine];
    }
    
    return self;
}


- (void)addTaskView {

    UIImageView* taskTypeImageView = [[UIImageView alloc] init];
    _taskTypeImageView = taskTypeImageView;
    //taskTypeImageView.image = [UIImage imageNamed:@"task_watch_vedio_image"];
    [self.contentView addSubview:taskTypeImageView];

    UILabel* tipLabel = [[UILabel alloc] init];
    _tipLabel = tipLabel;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = RGB(0x33, 0x33, 0x33);
    tipLabel.text = @"";
    [self.contentView addSubview:tipLabel];
    
    
    UIImageView* rmbImageView = [[UIImageView alloc] init];
    _rmbImageView = rmbImageView;
    rmbImageView.image = [UIImage imageNamed:@"ingots_small_tip"];
    [self.contentView addSubview:rmbImageView];
    //13 13

    UILabel* rmbCountLabel = [[UILabel alloc] init];
    _rmbCountLabel = rmbCountLabel;
    rmbCountLabel.font = [UIFont systemFontOfSize:12];
    rmbCountLabel.textColor = RGB(0xff, 0xa0, 0x30);
    rmbCountLabel.text = @"";
    [self.contentView addSubview:rmbCountLabel];
    
    
    UILabel* describeLabel = [[UILabel alloc] init];
    _describeLabel = describeLabel;
    describeLabel.font = [UIFont systemFontOfSize:12];
    describeLabel.textColor = RGB(0x99, 0x99, 0x99);
    describeLabel.text = @"";
    [self.contentView addSubview:describeLabel];
    

    UIButton* receiveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _receiveButton = receiveButton;
    receiveButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [receiveButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [receiveButton setTitle:@"去领取" forState:UIControlStateNormal];
    [receiveButton addTarget:self action:@selector(handleTouchEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [receiveButton setBackgroundImage:[UIImage imageNamed:@"receive_gold_button"] forState:UIControlStateNormal];
    [self.contentView addSubview:receiveButton];
    

    WeakSelf(that);
    [taskTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.left.equalTo(that.contentView.mas_left).offset(14);
    }];
    
    
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
        make.height.equalTo(@(12));
        make.left.equalTo(taskTypeImageView.mas_right).offset(10);
        make.top.equalTo(taskTypeImageView.mas_top);
    }];
    
    [rmbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(18));
        make.height.equalTo(@(9));
        make.left.equalTo(tipLabel.mas_right).offset(10);
        make.centerY.equalTo(tipLabel.mas_centerY);
    }];
    
    
    
    [rmbCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
        make.height.equalTo(@(12));
        make.left.equalTo(rmbImageView.mas_right).offset(3);
        make.centerY.equalTo(tipLabel.mas_centerY);
    }];
    
    

    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taskTypeImageView.mas_right).offset(10);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.height.equalTo(@(12));
        make.bottom.equalTo(taskTypeImageView.mas_bottom);
    }];
    
    
    
    [receiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(67));
        make.height.equalTo(@(27));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    
}



- (void)addBottomLine {
    UIView* lineView = [[UIView alloc] init];
    _lineView = lineView;
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    WeakSelf(that);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(0);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
    
    
}




- (void)updateTask:(JUDIAN_READ_TaskModel*)model isCheckIn:(BOOL)isCheckIn {

    _tipLabel.text = model.title;
    
    [_receiveButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_receiveButton setTitle:@"去领取" forState:UIControlStateNormal];
    [_receiveButton setBackgroundImage:[UIImage imageNamed:@"receive_gold_button"] forState:UIControlStateNormal];
    
    _rmbImageView.hidden = NO;
    _rmbCountLabel.hidden = NO;
    
    NSString* count = @"";
    NSString* content = @"";
    if ([model.type isEqualToString:@"invent"]) {
        content = @"奖励不设上限，邀请越多，奖励越多";
        _taskTypeImageView.image = [UIImage imageNamed:@"task_invite_friend_image"];
    }
    else if ([model.type isEqualToString:@"advert"]) {
        
        if (model.count.integerValue <= 0) {
            _rmbImageView.hidden = YES;
            _rmbCountLabel.hidden = YES;
        }
        
        count = [NSString stringWithFormat:@"%ld", model.count.integerValue];
        content = [NSString stringWithFormat:@"观看15-30秒小视频，今天还可领取%@次", count];
        _taskTypeImageView.image = [UIImage imageNamed:@"task_watch_vedio_image"];
    }
    else if ([model.type isEqualToString:@"checkIn"]) {
        NSString* signDays = model.signDays;
        if (signDays.length <= 0) {
            signDays = @"0";
        }
        content = [NSString stringWithFormat:@"您已连续签到%@天", signDays];
        
        if (isCheckIn) {
            _rmbImageView.hidden = YES;
            _rmbCountLabel.hidden = YES;
            
            [_receiveButton setTitle:@"已签到 >" forState:(UIControlStateNormal)];
            [_receiveButton setTitleColor:RGB(0x66, 0x66, 0x66) forState:(UIControlStateNormal)];
            [_receiveButton setBackgroundImage:[UIImage imageNamed:@"checked_in_image"] forState:UIControlStateNormal];
        }
        else {
            [_receiveButton setTitle:@"去签到" forState:(UIControlStateNormal)];
        }
        
        _taskTypeImageView.image = [UIImage imageNamed:@"task_check_in_image"];
    }
    else if ([model.type isEqualToString:@"version"]) {
        content = @"新版速度更快，体验更好";
        _taskTypeImageView.image = [UIImage imageNamed:@"task_download_image"];
    }
    else if([model.type isEqualToString:@"complete material"]) {
        if (model.count.integerValue <= 0) {
            _rmbImageView.hidden = YES;
            _rmbCountLabel.hidden = YES;
        }
        
        count = [NSString stringWithFormat:@"%ld", model.count.integerValue];
        content = [NSString stringWithFormat:@"还剩%@项基本资料未填写", count];
        _taskTypeImageView.image = [UIImage imageNamed:@"task_finish_user_info_image"];
    }
    
    _describeLabel.attributedText = [self buildContentString:count content:content];
    NSString* coins = model.coins;
    if(coins.length <= 0) {
        coins = @"0";
    }
    _rmbCountLabel.text = [NSString stringWithFormat:@"+%@元宝", coins];
    
    CGFloat tipWidth = ceil([_tipLabel getTextWidth:12]);
    [_tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(tipWidth));
    }];
    
    
    CGFloat countWidth = ceil([_rmbCountLabel getTextWidth:12]);
    [_rmbCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(countWidth));
    }];
}



- (void)handleTouchEvent {

    if (_block) {
        _block(@"");
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



- (NSMutableAttributedString*)buildContentString:(NSString*)count content:(NSString*)content {
    
    NSString* text = content;
    NSRange range = NSMakeRange(0, 0);
    if (count.length > 0) {
        range = [text rangeOfString:count options:(NSBackwardsSearch)];
    }

    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    // [paragraphStyle setLineSpacing:5];
    //paragraphStyle.alignment = NSTextAlignmentCenter;
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x99, 0x99, 0x99) range:NSMakeRange(0, [text length])];
    
    if (range.length > 0) {
        [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(range.location, range.length)];
    }

    return attributedText;
}







@end






@interface JUDIAN_READ_UserGoldCountCell ()
@property(nonatomic, weak)UILabel* myGoldCoin;
@property(nonatomic, weak)UIButton* goldCoinCountButton;
@property(nonatomic, weak)UIControl* goldCoinTouchView;
@property(nonatomic, weak)UIButton* loginButton;
@end



@implementation JUDIAN_READ_UserGoldCountCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self addLoginButton];
        [self addUserGoldCoinView];
    }
    
    return self;
}



- (void)addLoginButton {

    UIButton* loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _loginButton = loginButton;
    loginButton.layer.cornerRadius = 20;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = [UIColor whiteColor];
    [loginButton setTitle:@"登录 天天领元宝" forState:(UIControlStateNormal)];
    [loginButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:loginButton];
    
    NSInteger offset = 0;
    if (iPhone6Plus) {
        offset = 10;
    }
    
    WeakSelf(that);
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(207));
        make.height.equalTo(@(40));
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-23 - offset);
        make.centerX.equalTo(that.contentView.mas_centerX);
    }];
    
}



- (void)addUserGoldCoinView {
    
    UILabel* myGoldCoin = [[UILabel alloc] init];
    _myGoldCoin = myGoldCoin;
    myGoldCoin.textAlignment = NSTextAlignmentCenter;
    myGoldCoin.textColor = [UIColor whiteColor];
    myGoldCoin.font = [UIFont systemFontOfSize:12];
    myGoldCoin.text = @"我的元宝";
    [self.contentView addSubview:myGoldCoin];
    
    
    UIButton* goldCoinCountButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _goldCoinCountButton = goldCoinCountButton;
    goldCoinCountButton.userInteractionEnabled = NO;
    [self.contentView addSubview:goldCoinCountButton];
    
    NSString* count = [JUDIAN_READ_Account currentAccount].totalCoins;
    [goldCoinCountButton setTitle:count forState:UIControlStateNormal];
    
    [goldCoinCountButton setImage:[UIImage imageNamed:@"ingots_big_tip"] forState:(UIControlStateNormal)];
    [goldCoinCountButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, -2, 0)];
    [goldCoinCountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -3)];
    goldCoinCountButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [goldCoinCountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goldCoinCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    UIControl* goldCoinTouchView = [[UIControl alloc]init];
    _goldCoinTouchView = goldCoinTouchView;
    [goldCoinTouchView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:goldCoinTouchView];
    
    
    NSInteger offset = 0;
    if (iPhone6Plus) {
        offset = 10;
    }
    
    WeakSelf(that);
    
    [myGoldCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(10);
        make.right.equalTo(that.contentView.mas_right).offset(-10);
        make.height.equalTo(@(12));
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-19 - offset);
    }];
    
    
    [goldCoinCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(10);
        make.right.equalTo(that.contentView.mas_right).offset(-10);
        make.height.equalTo(@(24));
        make.bottom.equalTo(myGoldCoin.mas_top).offset(-10);
    }];
    
    [goldCoinTouchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goldCoinCountButton.mas_left);
        make.right.equalTo(goldCoinCountButton.mas_right);
        make.top.equalTo(goldCoinCountButton.mas_top);
        make.bottom.equalTo(myGoldCoin.mas_bottom);
    }];
}



- (void)updateCell {
    
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (token.length > 0) {
        _loginButton.hidden = YES;
        
        _myGoldCoin.hidden = NO;
        _goldCoinCountButton.hidden = NO;
        _goldCoinTouchView.hidden = NO;
        
        NSString* count = [JUDIAN_READ_Account currentAccount].totalCoins;
        [_goldCoinCountButton setTitle:count forState:UIControlStateNormal];
    }
    else {
        _loginButton.hidden = NO;
        
        _myGoldCoin.hidden = YES;
        _goldCoinCountButton.hidden = YES;
        _goldCoinTouchView.hidden = YES;
    }
    
}



- (void)handleTouchEvent:(id)sender {
    if (_block) {
        if (_loginButton == sender) {
            _block(@"login");
        }
        else {
            _block(@"myGoldCoin");
        }
    }
}

@end
