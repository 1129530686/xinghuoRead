//
//  JUDIAN_READ_MySubordinateCell.m
//  universalRead
//
//  Created by judian on 2019/9/29.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_MySubordinateCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_MySubordinateCell ()

@property(nonatomic, weak)UILabel* amountLabel;
@property(nonatomic, weak)UILabel* nameLabel;
@property(nonatomic, weak)UILabel* timeLabel;
@property(nonatomic, weak)UIImageView* headImageView;

@end



@implementation JUDIAN_READ_MySubordinateCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    UIImageView* headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"head_small"];
    headImageView.layer.cornerRadius = 20;
    headImageView.layer.masksToBounds = YES;
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    UILabel* amountLabel = [[UILabel alloc] init];
    _amountLabel = amountLabel;
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    amountLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    [self.contentView addSubview:amountLabel];
    
    UILabel* nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:nameLabel];
    
    
    UILabel* timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:9];
    timeLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:timeLabel];

    
    UIView* bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:bottomLineView];
    
    
    WeakSelf(that);
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(13));
        make.width.equalTo(@(0));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(13));
        make.left.equalTo(headImageView.mas_right).offset(9);
        make.right.equalTo(amountLabel.mas_left).offset(-9);
        make.top.equalTo(headImageView.mas_top).offset(5);
    }];
    
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(10));
        make.left.equalTo(headImageView.mas_right).offset(9);
        make.right.equalTo(amountLabel.mas_left).offset(-9);
        make.bottom.equalTo(headImageView.mas_bottom).offset(-6);
    }];
    
    
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    
    
    [self updateCellWithModel];

}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger amountWidth = [_amountLabel getTextWidth:13];
    [_amountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(amountWidth));
    }];
}



- (void)updateCellWithModel {
    _amountLabel.text = @"+100";
    _nameLabel.text = @"张哈哈哈哈哈哈哈哈哈哈哈";
    _timeLabel.text = @"2019-08-30  11:30:36";

}




@end


@interface JUDIAN_READ_MySubordinateHeaderView ()
@property(nonatomic, weak)UILabel* countLabel;
@property(nonatomic, weak)UILabel* amountLabel;;
@end


@implementation JUDIAN_READ_MySubordinateHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}


- (void)addViews {
    UILabel* countLabel = [[UILabel alloc] init];
    _countLabel = countLabel;
    [self.contentView addSubview:countLabel];
    
    UILabel* amountLabel = [[UILabel alloc] init];
    _amountLabel = amountLabel;
    [self.contentView addSubview:amountLabel];
    
    
    WeakSelf(that);
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(13));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.width.equalTo(@(0));
    }];
    
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(countLabel.mas_right).offset(6);
        make.height.equalTo(@(13));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        
    }];
    
    
    [self updateHeaderViewWithModel];
}


- (NSMutableAttributedString*)buildCountString:(NSString*)count {
    
    NSString* text = [NSString stringWithFormat:@"成功邀请推广员数%@", count];
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //[paragraphStyle setLineSpacing:5];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, [text length])];
    
    NSRange range = [text rangeOfString:count];
    if (range.length > 0) {
        [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(range.location, range.length)];
    }

    return attributedText;
}



- (NSMutableAttributedString*)buildAmountString:(NSString*)count {
    
    NSString* rmbTip = @"¥";
    NSString* text = [NSString stringWithFormat:@"余额：%@%@", rmbTip, count];
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, [text length])];
    

    NSRange range = [text rangeOfString:count];
    if (range.length > 0) {
        [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(range.location, range.length)];
    }
    
    range = [text rangeOfString:rmbTip];
    if (range.length > 0) {
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(range.location, 1)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(range.location, 1)];
    }
    
    return attributedText;
}


- (void)updateHeaderViewWithModel {
    _countLabel.attributedText = [self buildCountString:@"(1000)"];
    _amountLabel.attributedText = [self buildAmountString:@"300"];
    
    CGSize size = [_countLabel sizeWithAttributes:CGSizeMake(MAXFLOAT, 13)];
    CGFloat width = ceil(size.width);
    
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}



@end
