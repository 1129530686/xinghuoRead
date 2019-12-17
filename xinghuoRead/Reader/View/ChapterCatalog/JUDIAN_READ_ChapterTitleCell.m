//
//  JUDIAN_READ_ChapterTitleCell.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterTitleCell.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_ChapterTitleCell ()
@property(nonatomic, weak)UILabel* titleLabel;
@end



@implementation JUDIAN_READ_ChapterTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}



- (void)addViews {
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"";
    _titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
}


- (void)setViewStyle {

    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
    }
    else {
        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    }
    
    if (_isClicked) {
        _titleLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    }
}


- (void)setDefaultStyle {

    _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    if (_isClicked) {
        _titleLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    }
}

- (void)setTitleWithModel:(JUDIAN_READ_ChapterTitleModel*)model {
    _titleLabel.text = model.title;
}


@end
