//
//  JUDIAN_READ_ContributionBoardTipCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContributionBoardTipCell.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"

@interface JUDIAN_READ_ContributionBoardTipCell ()
@property(nonatomic, weak)UILabel* tipLabel;
@end



@implementation JUDIAN_READ_ContributionBoardTipCell

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
    JUDIAN_READ_VerticalAlignmentLabel* tipLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc] init];
    _tipLabel = tipLabel;
    _tipLabel.numberOfLines = 0;
    tipLabel.attributedText = [self createAttributedText:APP_CONTRIBUTION_TIP];
    [self.contentView addSubview:tipLabel];
    
    WeakSelf(that);
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(0);
        make.right.equalTo(that.contentView.mas_right).offset(-0);
        make.top.equalTo(that.contentView.mas_top).offset(12);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-12);
    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_tipLabel sizeToFit];
}


- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:4];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];
    
    return attributedText;
}



- (CGFloat)getCellHeight {
    CGSize size = [_tipLabel sizeWithAttributes:CGSizeMake(SCREEN_WIDTH - 2 * 14, MAXFLOAT)];
    return ceil(size.height) + 2 * 12;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end


@interface JUDIAN_READ_ContributionBoardTipView ()
@property(nonatomic, weak)UILabel* tipLabel;
@end


@implementation JUDIAN_READ_ContributionBoardTipView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    JUDIAN_READ_VerticalAlignmentLabel* tipLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc] init];
    _tipLabel = tipLabel;
    _tipLabel.numberOfLines = 0;
    tipLabel.attributedText = [self createAttributedText:APP_CONTRIBUTION_TIP];
    [self addSubview:tipLabel];
    
    WeakSelf(that);
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(0);
        make.right.equalTo(that.mas_right).offset(-0);
        make.top.equalTo(that.mas_top).offset(12);
        make.bottom.equalTo(that.mas_bottom).offset(-12);
    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_tipLabel sizeToFit];
}


- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:4];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];
    
    return attributedText;
}



- (CGFloat)getCellHeight {
    CGSize size = [_tipLabel sizeWithAttributes:CGSizeMake(SCREEN_WIDTH - 2 * 14, MAXFLOAT)];
    return ceil(size.height) + 2 * 12;
}



@end



@interface JUDIAN_READ_UserContributionView ()
@property(nonatomic, weak)UIImageView* headView;
@property(nonatomic, weak)UILabel* nameLabel;
@property(nonatomic, weak)UILabel* rankLabel;
@property(nonatomic, weak)UILabel* amountLabel;
@end


@implementation JUDIAN_READ_UserContributionView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        [self updateUserContribution];
    }
    
    return self;
}



- (void)addViews {
    
    UIImageView* bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"user_contribution_tip"];
    [self addSubview:bgView];
    

    UIImageView* headView = [[UIImageView alloc] init];
    _headView = headView;
    headView.image = [UIImage imageNamed:@"contribution_small_head"];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 47 / 2.0f;
    headView.layer.masksToBounds = YES;
    headView.layer.borderWidth = 1;
    headView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:headView];
    
    
    UILabel* amountLabel = [[UILabel alloc] init];
    _amountLabel = amountLabel;
    //amountLabel.attributedText = [self buildAmountString:@"10000"];
    [self addSubview:amountLabel];
    
    UILabel* nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = @"";
    [self addSubview:nameLabel];
    
    UILabel* rankLabel = [[UILabel alloc] init];
    _rankLabel = rankLabel;
    rankLabel.font = [UIFont systemFontOfSize:12];
    rankLabel.textColor = [UIColor whiteColor];
    rankLabel.text = @"";
    [self addSubview:rankLabel];
    

    WeakSelf(that);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(27);
        make.width.equalTo(@(47));
        make.height.equalTo(@(47));
        make.centerY.equalTo(bgView.mas_centerY).offset(-4);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
        make.height.equalTo(@(18));
        make.right.equalTo(bgView.mas_right).offset(-13);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).offset(10);
        make.top.equalTo(headView.mas_top).offset(7);
        make.height.equalTo(@(14));
        make.right.equalTo(amountLabel.mas_left).offset(-10);
    }];
    
    
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).offset(10);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.height.equalTo(@(12));
        make.right.equalTo(amountLabel.mas_left).offset(-10);
    }];
    
}




- (NSMutableAttributedString*)buildAmountString:(NSString*)amount {
    
    NSString* text = [NSString stringWithFormat:@"¥ %@", amount];
    
    UIFont* samllFont = [UIFont systemFontOfSize:12 weight:(UIFontWeightMedium)];
    UIFont* bigFont = [UIFont systemFontOfSize:18 weight:(UIFontWeightMedium)];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSFontAttributeName value:samllFont range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(0, text.length)];
    
    return attributedString;
}





- (void)updateUserContribution {
    
    _nameLabel.text = @"郭坤鹏sb郭坤鹏sb郭坤鹏";
    _rankLabel.text = @"您还没有贡献哦~";
    _amountLabel.attributedText = [self buildAmountString:@"10000"];
    
    CGSize size = [_amountLabel sizeWithAttributes:CGSizeMake(MAXFLOAT, 18)];
    [_amountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ceil(size.width)));
    }];
}



@end
