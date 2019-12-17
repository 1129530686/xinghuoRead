//
//  JUDIAN_READ_RecruitSubordinateTop10Cell.m
//  universalRead
//
//  Created by judian on 2019/10/9.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_RecruitSubordinateTop10Cell.h"
#import "UILabel+JUDIAN_READ_Label.h"


@implementation JUDIAN_READ_RecruitSubordinateTop10Cell

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
    
    UIImageView* bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"recruit_subordinate_top10_bg"];
    [self.contentView addSubview:bgView];
    
    WeakSelf(that);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(10);
        make.right.equalTo(that.contentView.mas_right).offset(-10);
        make.height.equalTo(@(703));
        make.top.equalTo(@(33));
    }];
    
    UIView* lastView = nil;
    for (NSInteger index = 0; index < 10; index++) {
        
        JUDIAN_READ_RecruitLeaderView* rankView = [[JUDIAN_READ_RecruitLeaderView alloc] initWithRow:index];
        [self.contentView addSubview:rankView];
        
        if (index == 0) {
            [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(37);
                make.height.equalTo(@(66));
                make.left.equalTo(bgView.mas_left);
                make.right.equalTo(bgView.mas_right);
            }];
        }
        else {
            [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.height.equalTo(@(66));
                make.left.equalTo(bgView.mas_left);
                make.right.equalTo(bgView.mas_right);
            }];
        }

        lastView = rankView;
    
    }

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end




@interface JUDIAN_READ_RecruitLeaderView ()
@property(nonatomic, weak)UIImageView* rankImageView;
@property(nonatomic, weak)UIImageView* headImageView;
@property(nonatomic, weak)UILabel* nameLabel;
@property(nonatomic, weak)UILabel* rankLabel;
@property(nonatomic, weak)UILabel* amountLabel;
@property(nonatomic, assign)NSInteger row;
@end




@implementation JUDIAN_READ_RecruitLeaderView


- (instancetype)initWithRow:(NSInteger)row {
    self = [super init];
    if (self) {
        _row = row;
        [self addViews];
        [self updateRecruitInfo];
    }
    
    return self;
}




- (void)addViews {
    UIView* rankView = nil;
    if (_row > 2) {
        UILabel* rankLabel = [[UILabel alloc] init];
        _rankLabel = rankLabel;
        rankLabel.font = [UIFont systemFontOfSize:17];
        rankLabel.textColor = RGB(0x33, 0x33, 0x33);
        rankLabel.text = @"10";
        rankLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:rankLabel];
        rankView = rankLabel;
    }
    else {
        UIImageView* rankImageView = [[UIImageView alloc] init];
        _rankImageView = rankImageView;
        rankImageView.image = [UIImage imageNamed:@"time_icon_1"];
        [self addSubview:rankImageView];
        rankView = rankImageView;
    }


    UIImageView* headImageView = [[UIImageView alloc] init];
    _headImageView = headImageView;
    headImageView.image = [UIImage imageNamed:@"contribution_small_head"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    headImageView.layer.cornerRadius = 40 / 2.0f;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderWidth = 1;
    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:headImageView];
    
    
    UILabel* nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = RGB(0x33, 0x33, 0x33);
    nameLabel.text = @"郁达夫故都的秋";
    [self addSubview:nameLabel];
    

    UILabel* amountLabel = [[UILabel alloc] init];
    _amountLabel = amountLabel;
    [self addSubview:amountLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xdd, 0xdd, 0xdd);
    [self addSubview:lineView];
    
    lineView.hidden = NO;
    
    if (_row == 9) {
        lineView.hidden = YES;
    }
    
    
    WeakSelf(that);
    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(23));
        make.height.equalTo(@(29));
        make.left.equalTo(that.mas_left).offset(17);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.left.equalTo(rankView.mas_right).offset(12);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
        make.height.equalTo(@(17));
        make.right.equalTo(that.mas_right).offset(-13);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(10);
        make.right.equalTo(amountLabel.mas_left).offset(-10);
        make.height.equalTo(@(14));
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(17);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.mas_bottom);
    }];
    
}

- (NSMutableAttributedString*)buildAmountString:(NSString*)amount {
    
    NSString* text = [NSString stringWithFormat:@"¥ %@", amount];
    
    UIFont* samllFont = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    UIFont* bigFont = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSFontAttributeName value:samllFont range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(0, text.length)];
    
    return attributedString;
}



- (void)updateRecruitInfo {

    _amountLabel.attributedText = [self buildAmountString:@"100000"];
    CGSize size = [_amountLabel sizeWithAttributes:CGSizeMake(MAXFLOAT, 17)];
    
    [_amountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ceil(size.width)));
    }];
    
}




@end
