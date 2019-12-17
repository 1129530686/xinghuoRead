//
//  JUDIAN_READ_UserContributionInfoCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserContributionInfoCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_UserContributionInfoCell ()

@property(nonatomic, weak)UILabel* sortLabel;
@property(nonatomic, weak)UILabel* userNameLabel;
@property(nonatomic, weak)UILabel* userIdLabel;
@property(nonatomic, weak)UILabel* userMoneyLabel;
@property(nonatomic, weak)UIImageView* headImageVIew;
@property(nonatomic, weak)UIImageView* rankImageView;
@end


@implementation JUDIAN_READ_UserContributionInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UIView* bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    UIImageView* rankImageView = [[UIImageView alloc] init];
    _rankImageView = rankImageView;
    rankImageView.hidden = YES;
    [self.contentView addSubview:rankImageView];
    
    UILabel* sortLabel = [[UILabel alloc] init];
    _sortLabel = sortLabel;
    _sortLabel.textAlignment = NSTextAlignmentCenter;
    _sortLabel.numberOfLines = 1;
    _sortLabel.adjustsFontSizeToFitWidth = TRUE;
    sortLabel.font = [UIFont systemFontOfSize:17];
    sortLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:sortLabel];
    

    JUDIAN_READ_UserRoundCornerImageView* headImageVIew = [[JUDIAN_READ_UserRoundCornerImageView alloc] init];
    _headImageVIew = headImageVIew;
    headImageVIew.contentMode = UIViewContentModeScaleAspectFill;
    headImageVIew.clipsToBounds = YES;
    //headImageVIew.layer.cornerRadius = 20;
    //headImageVIew.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageVIew];
    
    
    NSInteger fontOffset = 0;
    if (iPhone6Plus) {
        fontOffset = 2;
    }
    
    UILabel* userNameLabel = [[UILabel alloc] init];
    _userNameLabel = userNameLabel;
    userNameLabel.font = [UIFont systemFontOfSize:14 + fontOffset];
    userNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:userNameLabel];
    
    
    UILabel* userMoneyLabel = [[UILabel alloc] init];
    _userMoneyLabel = userMoneyLabel;
    userMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:userMoneyLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(0);
        make.right.equalTo(that.contentView.mas_right).offset(-0);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    
    
    [sortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(1);
        make.width.equalTo(@(60));
        make.height.equalTo(@(50));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    
    [rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(23));
        make.height.equalTo(@(29));
        make.centerX.equalTo(sortLabel.mas_centerX);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [headImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(sortLabel.mas_right).offset(5);
    }];
    
    
    
    [userMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-14);
        make.height.equalTo(@(12 + fontOffset));
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.equalTo(@(0));
    }];
    
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageVIew.mas_right).offset(10);
        make.right.equalTo(userMoneyLabel.mas_left).offset(-50);
        make.height.equalTo(@(14 + fontOffset));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(14);
        make.right.equalTo(bgView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}




- (NSMutableAttributedString*)createAttributedText:(NSString*)text rmbTip:(NSString*)rmbTip {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSInteger fontOffset = 0;
    if (iPhone6Plus) {
        fontOffset = 2;
    }
    
    NSString* money = [NSString stringWithFormat:@"%@%@", rmbTip, text];
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:money];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8 + fontOffset] range:NSMakeRange(0, rmbTip.length)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 + fontOffset] range:NSMakeRange(rmbTip.length, [money length] - rmbTip.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(0, [money length])];
    
    return attributedText;
}



- (void)updateUserContribution:(JUDIAN_READ_UserContributionModel*)model row:(NSInteger)row {
    
    NSString* urlStr = model.avatar;
    UIImage* defaultImage = [UIImage imageNamed:@"head_small"];
    [_headImageVIew sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:defaultImage];
    
    if (row > 2) {
        _rankImageView.hidden = YES;
        _sortLabel.text = model.rankId;
    }
    else {
        _sortLabel.text = @"";
        NSString* imageName = [NSString stringWithFormat:@"time_icon_%ld", row + 1];
        _rankImageView.image = [UIImage imageNamed:imageName];
        _rankImageView.hidden = NO;
    }

    _userNameLabel.text = model.nickname;
    _userIdLabel.text = model.uidb;
    
    NSString* money = [NSString stringWithFormat:@"%.1f", model.totalMoney.floatValue];
    _userMoneyLabel.attributedText = [self createAttributedText:money rmbTip:@"¥ "];
    
    CGSize size = [_userMoneyLabel sizeWithAttributes:CGSizeMake(200, 12)];
    
    [_userMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ceil(size.width)));
    }];
    
}



- (void)updateChapterContribution:(JUDIAN_READ_UserAppreciatedChapterModel*)model {
    
    NSString* urlStr = model.avatar;
    UIImage* defaultImage = [UIImage imageNamed:@"head_small"];
    [_headImageVIew sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:defaultImage];
    
    _sortLabel.text = model.rankId;
    
    _userNameLabel.text = model.nickname;
    _userIdLabel.text = model.uidb;
    
    NSString* money = [NSString stringWithFormat:@"%.1f", model.reward_money.floatValue];
    _userMoneyLabel.attributedText = [self createAttributedText:money rmbTip:@"¥ "];
    
    CGSize size = [_userMoneyLabel sizeWithAttributes:CGSizeMake(200, 12)];
    
    [_userMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ceil(size.width)));
    }];
    
}


@end



@implementation JUDIAN_READ_UserRoundCornerImageView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}


- (void)addMaskLayer:(CGRect)frame {
    
    if (self.layer.mask) {
        return;
    }
    
    if (frame.size.width <= 0) {
        return;
    }
    
    UIBezierPath *maskPath =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.width <= 0) {
        return;
    }
    
    [self addMaskLayer:self.bounds];
}








- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    
}



@end
