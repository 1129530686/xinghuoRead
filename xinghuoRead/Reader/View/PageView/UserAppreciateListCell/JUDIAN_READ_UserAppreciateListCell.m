//
//  JUDIAN_READ_UserAppreciateListCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppreciateListCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_UserAppreciateListCell ()
@property(nonatomic, weak)UILabel* moneyLabel;
@property(nonatomic, weak)UILabel* payStyleLabel;
@property(nonatomic, weak)UILabel* chapterNameLabel;
@property(nonatomic, weak)UILabel* payDateLabel;
@end




@implementation JUDIAN_READ_UserAppreciateListCell

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
    
    UILabel* moneyLabel = [[UILabel alloc]init];
    _moneyLabel = moneyLabel;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLabel];
    
    
    UILabel* payStyleLabel = [[UILabel alloc]init];
    _payStyleLabel = payStyleLabel;
    payStyleLabel.textColor = RGB(0x99, 0x99, 0x99);
    payStyleLabel.font = [UIFont systemFontOfSize:12];
    payStyleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:payStyleLabel];
    
    
    UILabel* chapterNameLabel = [[UILabel alloc]init];
    _chapterNameLabel = chapterNameLabel;
    chapterNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    chapterNameLabel.font = [UIFont systemFontOfSize:14];
    chapterNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:chapterNameLabel];
    
    
    UILabel* payDateLabel = [[UILabel alloc]init];
    _payDateLabel = payDateLabel;
    payDateLabel.textColor = RGB(0x99, 0x99, 0x99);
    payDateLabel.font = [UIFont systemFontOfSize:12];
    payDateLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:payDateLabel];
    
    
    
    UIView* bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:bottomLineView];
    
    

    WeakSelf(that);
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
        make.height.equalTo(@(13));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.top.equalTo(that.contentView.mas_top).offset(13);
    }];
    
    
    [payStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-13);
    }];
    
    
    
    [chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.centerY.equalTo(moneyLabel.mas_centerY);
        make.height.equalTo(@(14));
        make.right.equalTo(moneyLabel.mas_left).offset(-30);
    }];
    
    
    [payDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.centerY.equalTo(payStyleLabel.mas_centerY);
        make.height.equalTo(@(12));
        make.right.equalTo(payStyleLabel.mas_left).offset(-30);
    }];
    
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(0.5));
        make.right.equalTo(that.contentView.mas_right);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-0.5);
    }];
    
}




- (NSMutableAttributedString*)buildAttributedString:(NSString*)amount {
    
    NSString* text = [NSString stringWithFormat:@"¥ %@", amount];
    
    UIFont* samllFont = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    UIFont* bigFont = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:samllFont range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(2, amount.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, text.length)];
    
    return attributedString;
}



- (void)setAppreciatedInfoWithMode:(JUDIAN_READ_UserAppreciatedItemModel*)model {
    
    NSString* chapterIitle = model.chapter_title;
    if (chapterIitle.length <= 0) {
        chapterIitle = @"";
    }
    
    NSString* bookInfo = [NSString stringWithFormat:@"%@ %@", model.bookname, chapterIitle];
    _chapterNameLabel.text = bookInfo;
    _moneyLabel.attributedText = [self buildAttributedString:model.amount];
    _payDateLabel.text = model.create_time;
    _payStyleLabel.text = model.pay_type;

    
    CGFloat moneyWidth = [_moneyLabel sizeWithAttributes:CGSizeMake(MAXFLOAT, 13)].width + 10;
    CGFloat payStyleWidth = [_payStyleLabel getTextWidth:12] + 10;
    
    
    [_moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(moneyWidth));
    }];
    
    [_payStyleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(payStyleWidth));
    }];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
