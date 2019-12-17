//
//  JUDIAN_READ_UserContributionMoneyCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/20.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserContributionMoneyCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_UserContributionMoneyCell ()
@property(nonatomic, weak) UILabel* contributionTimeLabel;
@property(nonatomic, weak) UILabel* moneyLabel;
@property(nonatomic, weak) UILabel* contributionChannelLabel;
@end



@implementation JUDIAN_READ_UserContributionMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UILabel* contributionTimeLabel = [[UILabel alloc] init];
    _contributionTimeLabel = contributionTimeLabel;
    contributionTimeLabel.font = [UIFont systemFontOfSize:14];
    contributionTimeLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:contributionTimeLabel];
    
    
    UILabel* moneyLabel = [[UILabel alloc] init];
    _moneyLabel = moneyLabel;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLabel];
    
    
    UILabel* contributionChannelLabel = [[UILabel alloc] init];
    _contributionChannelLabel = contributionChannelLabel;
    contributionChannelLabel.textAlignment = NSTextAlignmentRight;
    contributionChannelLabel.font = [UIFont systemFontOfSize:12];
    contributionChannelLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:contributionChannelLabel];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [contributionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-100);
        make.height.equalTo(@(14));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.width.equalTo(@(0));
        make.top.equalTo(that.contentView.mas_top).offset(0);
        make.height.equalTo(@(12));
    }];
    
    
    [contributionChannelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moneyLabel.mas_right);
        make.top.equalTo(moneyLabel.mas_bottom).offset(11);
        make.height.equalTo(@(12));
        make.left.equalTo(that.contentView.mas_left).offset(100);
    }];
    

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
    }];
    
    
}



- (void)updateCell:(JUDIAN_READ_UserContributionMoneyModel*)model {
    _contributionTimeLabel.text = model.createTime;
    _moneyLabel.attributedText = [self createAttributedText:model.amount rmbTip:@"¥ "];
    _contributionChannelLabel.text = model.payType;
    [self setNeedsLayout];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_moneyLabel.attributedText.length <= 0) {
        return;
    }
    
    CGSize size = [_moneyLabel sizeWithAttributes:CGSizeMake(MAXFLOAT, 12)];
    CGFloat width = ceil(size.width);
    CGFloat top = (self.frame.size.height - 35) / 2.0f;
    [_moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.top.equalTo(@(top));
    }];

}



- (NSMutableAttributedString*)createAttributedText:(NSString*)text rmbTip:(NSString*)rmbTip {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSString* money = [NSString stringWithFormat:@"%@%@", rmbTip, text];
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:money];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium] range:NSMakeRange(rmbTip.length, [money length] - rmbTip.length)];

    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 weight:UIFontWeightMedium] range:NSMakeRange(0, rmbTip.length)];
    
    return attributedText;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
