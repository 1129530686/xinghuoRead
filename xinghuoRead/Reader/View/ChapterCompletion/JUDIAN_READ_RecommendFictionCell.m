//
//  JUDIAN_READ_RecommendFictionCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_RecommendFictionCell.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"

#define HEAD_VIEW_WIDTH 107


@interface JUDIAN_READ_RecommendFictionCell ()
@property(nonatomic, weak)JUDIAN_READ_VerticalAlignmentLabel* titleLabel;
@property(nonatomic, weak)UILabel* authorLabel;
@property(nonatomic, weak)UILabel* readCountLabel;
@property(nonatomic, weak)UIImageView* imageView;
@end


@implementation JUDIAN_READ_RecommendFictionCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {
    
    UIImageView* imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* titleLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc] init];
    _titleLabel = titleLabel;
    [titleLabel setAlignmentStyle:(TextInTop)];
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    
    
    UILabel* authorLabel = [[UILabel alloc] init];
    _authorLabel = authorLabel;
    authorLabel.font = [UIFont systemFontOfSize:11];
    authorLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:authorLabel];
    
    
    UILabel* readCountLabel = [[UILabel alloc] init];
    _readCountLabel = readCountLabel;
    readCountLabel.font = [UIFont systemFontOfSize:11];
    readCountLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:readCountLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    

    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(HEAD_VIEW_WIDTH));
        make.height.equalTo(@(73));
        make.top.equalTo(that.contentView.mas_top).offset(14);
        make.left.equalTo(that.contentView.mas_left).offset(14);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(0)).priority(980);
        make.top.equalTo(imageView.mas_top);
    }];
    
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(14);
        make.width.equalTo(@(0));
        make.height.equalTo(@(11));
        make.bottom.equalTo(imageView.mas_bottom);
    }];
    
    [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel.mas_right).offset(13);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(11));
        make.bottom.equalTo(imageView.mas_bottom);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.contentView.mas_bottom);
    }];
    
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
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}



- (void)updateCell:(JUDIAN_READ_ArticleListModel*)model {
    
    _titleLabel.attributedText = [self createAttributedText:model.title];
    
    UIImage* image = [UIImage imageNamed:@"default_h_image"];
    NSURL* url = [NSURL URLWithString:model.img_list.firstObject];
    [_imageView sd_setImageWithURL:url placeholderImage:image];
    
    _authorLabel.text = model.source;
    
    _readCountLabel.text = [NSString stringWithFormat:@"%@次阅读", model.read_number];
    
    CGFloat width = ScreenWidth - 3 * 14 - HEAD_VIEW_WIDTH;
    CGSize titleSize = [_titleLabel sizeWithAttributes:CGSizeMake(width, MAXFLOAT)];
    CGFloat height = ceil(titleSize.height);

    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    CGFloat authorwidth = [_authorLabel getTextWidth:11];
    authorwidth = ceil(authorwidth);
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(authorwidth));
    }];
    
    [_titleLabel sizeToFit];
    
}



- (NSInteger) getCellHeight:(JUDIAN_READ_ArticleListModel*)model {
    
    _titleLabel.attributedText = [self createAttributedText:model.title];
    CGFloat width = ScreenWidth - 2 * 14;
    CGFloat height = [_titleLabel getTextHeight:width];
    height = ceil(height);
    CGFloat imageHeight = ceil(width * 0.52);
    return 14 * 2 + height + imageHeight + 11 + 10 * 2;
}



@end


@interface JUDIAN_READ_RecommendThreeImageCell ()
@property(nonatomic, weak)JUDIAN_READ_VerticalAlignmentLabel* titleLabel;
@property(nonatomic, weak)UILabel* authorLabel;
@property(nonatomic, weak)UILabel* readCountLabel;
@property(nonatomic, weak)UIImageView* imageView1;
@property(nonatomic, weak)UIImageView* imageView2;
@property(nonatomic, weak)UIImageView* imageView3;
@end



@implementation JUDIAN_READ_RecommendThreeImageCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {
    
    UIImage* image = [UIImage imageNamed:@"default_h_image"];
    
    UIImageView* imageView1 = [[UIImageView alloc] init];
    _imageView1 = imageView1;
    imageView1.image = image;
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    imageView1.layer.cornerRadius = 3;
    imageView1.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView1];
    
    
    UIImageView* imageView2 = [[UIImageView alloc] init];
    _imageView2 = imageView2;
    imageView2.image = image;
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    imageView2.layer.cornerRadius = 3;
    imageView2.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView2];
    
    
    UIImageView* imageView3 = [[UIImageView alloc] init];
    _imageView3 = imageView3;
    imageView3.image = image;
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.clipsToBounds = YES;
    imageView3.layer.cornerRadius = 3;
    imageView3.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView3];
    

    JUDIAN_READ_VerticalAlignmentLabel* titleLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    _titleLabel = titleLabel;
    [titleLabel setAlignmentStyle:(TextInTop)];
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    
    
    UILabel* authorLabel = [[UILabel alloc] init];
    _authorLabel = authorLabel;
    authorLabel.font = [UIFont systemFontOfSize:11];
    authorLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:authorLabel];
    
    
    UILabel* readCountLabel = [[UILabel alloc] init];
    _readCountLabel = readCountLabel;
    readCountLabel.font = [UIFont systemFontOfSize:11];
    readCountLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:readCountLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    
    CGFloat imageWidth = (ScreenWidth - 2 * 14 - 2 * 7) / 3;
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(16));
        make.top.equalTo(that.contentView.mas_top).offset(14);
    }];
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(73));
        make.width.equalTo(@(imageWidth));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_right).offset(7);
        make.height.equalTo(@(73));
        make.width.equalTo(@(imageWidth));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.mas_right).offset(7);
        make.height.equalTo(@(73));
        make.width.equalTo(@(imageWidth));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(0));
        make.height.equalTo(@(11));
        make.top.equalTo(imageView1.mas_bottom).offset(10);
    }];
    

    [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel.mas_right).offset(13);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(11));
        make.top.equalTo(imageView1.mas_bottom).offset(10);
    }];
    

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.contentView.mas_bottom);
    }];
    
    
}


- (void)updateCell:(JUDIAN_READ_ArticleListModel*)model {
    
    _titleLabel.text = model.title;
    
    UIImage* image = [UIImage imageNamed:@"default_h_image"];
    NSURL* url = nil;
   
    if (model.img_list.count > 0) {
        url = [NSURL URLWithString:model.img_list[0]];
        [_imageView1 sd_setImageWithURL:url placeholderImage:image];
    }

    if (model.img_list.count > 1) {
        url = [NSURL URLWithString:model.img_list[1]];
        [_imageView2 sd_setImageWithURL:url placeholderImage:image];
    }
 

    if (model.img_list.count > 2) {
        url = [NSURL URLWithString:model.img_list[2]];
        [_imageView3 sd_setImageWithURL:url placeholderImage:image];
    }
    
    _authorLabel.text = model.source;
    
    _readCountLabel.text = [NSString stringWithFormat:@"%@次阅读", model.read_number];
    
    CGFloat authorwidth = [_authorLabel getTextWidth:11];
    authorwidth = ceil(authorwidth);
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(authorwidth));
    }];
    
    CGFloat width = ScreenWidth - 2 * 14;
    CGFloat height = [_titleLabel getTextHeight:width];
    height = ceil(height);
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    [_titleLabel sizeToFit];

}



- (NSInteger) getCellHeight:(JUDIAN_READ_ArticleListModel*)model {

    _titleLabel.text = model.title;

    CGFloat width = ScreenWidth - 2 * 14;
    CGFloat height = 0.0f;
    height = [_titleLabel getTextHeight:width];
    height = ceil(height);

    if (height < 16) {
        height = 16;
    }

    return 117 + height + 14;
}


@end


@interface JUDIAN_READ_RecommendBigImageCell ()
@property(nonatomic, weak)JUDIAN_READ_VerticalAlignmentLabel* titleLabel;
@property(nonatomic, weak)UILabel* authorLabel;
@property(nonatomic, weak)UILabel* readCountLabel;
@property(nonatomic, weak)UIImageView* imageView;
@end



@implementation JUDIAN_READ_RecommendBigImageCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}




- (void)addViews:(CGRect)frame {
    
    JUDIAN_READ_VerticalAlignmentLabel* titleLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc] init];
    _titleLabel = titleLabel;
    [titleLabel setAlignmentStyle:(TextInTop)];
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    
    UILabel* authorLabel = [[UILabel alloc] init];
    _authorLabel = authorLabel;
    authorLabel.font = [UIFont systemFontOfSize:11];
    authorLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:authorLabel];
    
    
    UILabel* readCountLabel = [[UILabel alloc] init];
    _readCountLabel = readCountLabel;
    readCountLabel.font = [UIFont systemFontOfSize:11];
    readCountLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:readCountLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(0));
        make.top.equalTo(that.contentView.mas_top).offset(14);
    }];
    
    CGFloat width = ScreenWidth - 2 * 14;
    CGFloat imageHeight = ceil(width * 0.52);
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(width));
        make.height.equalTo(@(imageHeight));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(0));
        make.height.equalTo(@(11));
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    
    [readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel.mas_right).offset(13);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(11));
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.contentView.mas_bottom);
    }];
    
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
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}



- (void)updateCell:(JUDIAN_READ_ArticleListModel*)model {
    
    _titleLabel.attributedText = [self createAttributedText:model.title];
    
    UIImage* image = [UIImage imageNamed:@"default_h_image"];
    NSURL* url = [NSURL URLWithString:model.img_list.firstObject];
    [_imageView sd_setImageWithURL:url placeholderImage:image];
    
    _authorLabel.text = model.source;
    
    _readCountLabel.text = [NSString stringWithFormat:@"%@次阅读", model.read_number];
    
    CGFloat width = ScreenWidth - 2 * 14;
    CGFloat height = 0.0f;//[_titleLabel getTextHeight:width];
    CGSize titleSize = [_titleLabel sizeWithAttributes:CGSizeMake(width, MAXFLOAT)];
    
    height = ceil(titleSize.height);
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    CGFloat authorwidth = [_authorLabel getTextWidth:11];
    authorwidth = ceil(authorwidth);
    
    [_authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(authorwidth));
    }];
    
    [_titleLabel sizeToFit];
    
}



- (NSInteger) getCellHeight:(JUDIAN_READ_ArticleListModel*)model {
    
    _titleLabel.attributedText = [self createAttributedText:model.title];
    CGFloat width = ScreenWidth - 2 * 14;
    CGFloat height = 0.0f;
    CGSize titleSize = [_titleLabel sizeWithAttributes:CGSizeMake(width, MAXFLOAT)];
    height = ceil(titleSize.height);
    CGFloat imageHeight = ceil(width * 0.52);
    return 14 * 2 + height + imageHeight + 11 + 10 * 2;
}


@end
