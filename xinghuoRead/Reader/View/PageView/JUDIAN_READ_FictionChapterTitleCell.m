//
//  JUDIAN_READ_FictionChapterTitleCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionChapterTitleCell.h"
#import "JUDIAN_READ_TextStyleModel.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_FictionChapterTitleCell ()
@property(nonatomic, strong)UILabel* chapterTitleLabel;
@end

@implementation JUDIAN_READ_FictionChapterTitleCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    _chapterTitleLabel = [[UILabel alloc]init];

    _chapterTitleLabel.text = @"";
    _chapterTitleLabel.textColor = RGB(0x33, 0x33, 0x33);
    _chapterTitleLabel.numberOfLines = 0;
    NSInteger fontSize = [self getFontSize];
    _chapterTitleLabel.font = [UIFont systemFontOfSize:fontSize weight:(UIFontWeightMedium)];
    [self.contentView addSubview:_chapterTitleLabel];
    
    WeakSelf(that);
    [_chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(20);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.height.equalTo(@(20));
        make.top.equalTo(that.contentView.mas_top).offset(20);
    }];
}



- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSInteger fontSize = [self getFontSize];
    UIColor* textColor = [self getTextColor];
    //UIFont* font = [UIFont systemFontOfSize:(fontSize) weight:(UIFontWeightMedium)];
    UIFont* font = [UIFont fontWithName:FONT_ALIBABA_PUHUITI_REGULAR size:fontSize];
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [text length])];
    
    return attributedText;
}



- (NSInteger)getFontSize {
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    NSInteger fontSize = [style getChapterTitleFontSize];
    return fontSize;
}


- (UIColor*)getTextColor {
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    return [style getTextColor];
}



- (UIColor*)getBgColor {
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    return [style getBgColor];
}




- (void)setTitleText:(NSString*)text {

    _chapterTitleLabel.attributedText = [self createAttributedText:text];
    CGSize size = [_chapterTitleLabel sizeWithAttributes:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    
    self.contentView.backgroundColor = [self getBgColor];
    
    NSInteger fontSize = ceil(size.height);
    [_chapterTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(fontSize));
    }];
}


- (NSInteger)getCellHeight:(BOOL)showAdvertise {
    CGSize size = [_chapterTitleLabel sizeWithAttributes:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    NSInteger fontSize = ceil(size.height) + 20;
    if (!showAdvertise) {
        fontSize += 20;
    }
    return fontSize;
}

@end
