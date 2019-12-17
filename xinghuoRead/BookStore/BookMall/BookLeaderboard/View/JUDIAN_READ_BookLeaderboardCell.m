//
//  JUDIAN_READ_BookLeaderboardCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BookLeaderboardCell.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_CornerLabel.h"
#import "NSString+JUDIAN_READ_Url.h"
#import "UIImage+JUDIAN_READ_Blur.h"

#define IMAGE_WIDTH 57
#define IMAGE_HEIGHT 81

@interface JUDIAN_READ_BookLeaderboardCell ()
@property(nonatomic, weak)UIImageView* bookCoverImageView;
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UILabel* briefLabel;
@property(nonatomic, weak)UILabel* authorLabel;
@property(nonatomic, weak)UILabel* bookCategoryLabel;
@property(nonatomic, weak)UILabel* userActionLabel;
@property(nonatomic, weak)UIImageView* rankImageView;
@end



@implementation JUDIAN_READ_BookLeaderboardCell

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
    
    UIImageView* bookCoverImageView = [[UIImageView alloc] init];
    bookCoverImageView.layer.cornerRadius = 2;
    bookCoverImageView.layer.borderWidth = 0.5;
    bookCoverImageView.layer.borderColor = RGB(0xee, 0xee, 0xee).CGColor;
    bookCoverImageView.layer.masksToBounds = YES;
    _bookCoverImageView = bookCoverImageView;
    [self.contentView addSubview:bookCoverImageView];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:titleLabel];
    
    JUDIAN_READ_VerticalAlignmentLabel* briefLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc] init];
    _briefLabel = briefLabel;
    briefLabel.textColor = RGB(0x66, 0x66, 0x66);
    briefLabel.font = [UIFont systemFontOfSize:kAutoFontSize12_13];
    briefLabel.numberOfLines = 2;
    [briefLabel setAlignmentStyle:(TextInTop)];
    [self.contentView addSubview:briefLabel];
    
    
    UILabel* authorLabel = [[UILabel alloc] init];
    _authorLabel = authorLabel;
    authorLabel.font = [UIFont systemFontOfSize:kAutoFontSize12_13];
    authorLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:authorLabel];
    
    
    JUDIAN_READ_CornerLabel* bookCategoryLabel = [[JUDIAN_READ_CornerLabel alloc] init];
    _bookCategoryLabel = bookCategoryLabel;
    bookCategoryLabel.layer.cornerRadius = 2;
    bookCategoryLabel.layer.borderWidth = 0.5;
    bookCategoryLabel.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
    bookCategoryLabel.layer.masksToBounds = YES;
    bookCategoryLabel.font = [UIFont systemFontOfSize:kAutoFontSize10_11];
    bookCategoryLabel.textColor = RGB(0x99, 0x99, 0x99);
    bookCategoryLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:bookCategoryLabel];
    
    
    UILabel* userActionLabel = [[UILabel alloc] init];
    _userActionLabel = userActionLabel;
    userActionLabel.font = [UIFont systemFontOfSize:12];
    userActionLabel.textAlignment = NSTextAlignmentRight;
    userActionLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    [self.contentView addSubview:userActionLabel];
    
    
    UIImageView* rankImageView = [[UIImageView alloc] init];
    _rankImageView = rankImageView;
    rankImageView.hidden = YES;
    [self.contentView addSubview:rankImageView];
    
    //self.iconheight.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
    //self.iconWidth.constant = (SCREEN_WIDTH-30-54)/4;
    NSInteger imageWidth = (SCREEN_WIDTH - 84) / 4.0f;
    
    WeakSelf(that);
    [bookCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.top.equalTo(that.contentView.mas_top);
        make.width.equalTo(@(imageWidth));
        make.height.equalTo(@(ceil(imageWidth*1.35f)));
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookCoverImageView.mas_right).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.top.equalTo(bookCoverImageView.mas_top).offset(3);
        make.height.equalTo(@(20));
    }];
    
    
    [briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookCoverImageView.mas_right).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@(0));
    }];
    
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookCoverImageView.mas_right).offset(14);
        make.width.equalTo(@(0));
        make.bottom.equalTo(bookCoverImageView.mas_bottom).offset(-3);
        make.height.equalTo(@(12));
    }];
    
    
    [bookCategoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel.mas_right).offset(10);
        make.width.equalTo(@(0));
        make.centerY.equalTo(authorLabel.mas_centerY);
        make.height.equalTo(@(15));
    }];
    
    

    [userActionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookCategoryLabel.mas_right).offset(10);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.centerY.equalTo(authorLabel.mas_centerY);
        make.height.equalTo(@(12));
    }];
    
    
    [rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bookCoverImageView.mas_top);
        make.left.equalTo(bookCoverImageView.mas_left).offset(7);
        make.width.equalTo(@(11));
        make.height.equalTo(@(14));
    }];
    
    
}



- (void)updateCell:(JUDIAN_READ_BookDescribeModel*)model type:(NSString*)type row:(NSInteger)row {
    
    _rankImageView.hidden = YES;
    if (row == 0) {
        _rankImageView.image = [UIImage imageNamed:@"book_city_first_name"];
        _rankImageView.hidden = NO;
    }
    else if (row == 1) {
        _rankImageView.image = [UIImage imageNamed:@"book_city_second"];
        _rankImageView.hidden = NO;
    }
    else if (row == 2) {
        _rankImageView.image = [UIImage imageNamed:@"book_city_third"];
        _rankImageView.hidden = NO;
    }
    
    UIImage* image = [UIImage imageNamed:@"default_v_image"];
    [_bookCoverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:image];
#if 0
    WeakSelf(that);
    [_bookCoverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        that.bookCoverImageView.image = [image createCornerImage:CGSizeMake(2, 2)];
    }];
#endif
    
    _titleLabel.text = model.bookname;
    //_briefLabel.attributedText = [self createAttributedText:model.brief];
    _briefLabel.text = [model.brief removeAllWhitespace];
    
    _authorLabel.text = model.author;
    _bookCategoryLabel.text = model.cat_name;
    
    CGFloat tenThousand = 0.0f;
    NSInteger favoriteCount = 0;
    
    if ([type containsString:@"分"]) {
        tenThousand = model.avgScore.floatValue;
        _userActionLabel.text = [NSString stringWithFormat:@"%.1f%@", tenThousand, type];
    }
    else {
        
        if ([type containsString:@"粉丝"]) {
            favoriteCount = model.favoriteNum.integerValue;
        }
        else if ([type containsString:@"人气"]) {
            favoriteCount = model.readingNum.integerValue;
        }
        else if ([type containsString:@"赞赏"]) {
            favoriteCount = model.praiseNum.integerValue;
        }
        
        if (favoriteCount >= 10000) {
            tenThousand = favoriteCount / 10000.0f;
            _userActionLabel.text = [NSString stringWithFormat:@"%.1f万%@", tenThousand, type];
        }
        else {
            _userActionLabel.text = [NSString stringWithFormat:@"%ld%@", favoriteCount, type];
        }
    }
    

    CGFloat briefWidth = (SCREEN_WIDTH - 3 * 14 - IMAGE_WIDTH);
    //CGSize briefSize = [_briefLabel sizeWithAttributes:CGSizeMake(briefWidth, MAXFLOAT)];
    CGFloat briefHeight = [_briefLabel getTextHeight:briefWidth];
    briefHeight = ceil(briefHeight);
    
    CGFloat categoryWidth = [_bookCategoryLabel getTextWidth:10];
    categoryWidth = ceil(categoryWidth) + 7;
    
    CGFloat authorWidth = [_authorLabel getTextWidth:12 count:14];
    authorWidth = ceil(authorWidth);

    
    [_briefLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(briefHeight));
    }];
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(authorWidth));
    }];
    

    [_bookCategoryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(categoryWidth));
    }];
    
    [_briefLabel sizeToFit];
    
    [self setNeedsLayout];
}




- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x99, 0x99, 0x99) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_bookCategoryLabel.size.width <= 0) {
        return;
    }
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
