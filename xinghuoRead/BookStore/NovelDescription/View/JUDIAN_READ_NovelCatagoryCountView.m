//
//  JUDIAN_READ_NovelCatagoryCountView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelCatagoryCountView.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_NovelCatagoryCountView ()
@property(nonatomic, weak)UIImageView* rightArrowView;
@property(nonatomic, weak)UILabel* catagoryLabel;
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UIView* topLineView;
@property(nonatomic, weak)UIView* bottomLineView;
@end


@implementation JUDIAN_READ_NovelCatagoryCountView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UILabel* titleLabel = [[UILabel alloc]init];
    _titleLabel = titleLabel;
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"";
    [self.contentView addSubview:titleLabel];
    
    
    UILabel* catagoryLabel = [[UILabel alloc]init];
    _catagoryLabel = catagoryLabel;
    catagoryLabel.textColor = RGB(0x99, 0x99, 0x99);
    catagoryLabel.font = [UIFont systemFontOfSize:14];
    catagoryLabel.text = @"";
    catagoryLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:catagoryLabel];
    
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"novel_catagory_right_arrow"];
    _rightArrowView = imageView;
    [self.contentView addSubview:imageView];
    

    UIView* topLineView = [[UIView alloc] init];
    _topLineView = topLineView;
    topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:topLineView];
    
    UIView* bottomLineView = [[UIView alloc] init];
    _bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:bottomLineView];
    
    
    WeakSelf(that);
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(0));
        make.height.equalTo(@(16));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.contentView.mas_right).offset(-12);
        make.width.equalTo(@(7));
        make.height.equalTo(@(12));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    [catagoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_left).offset(-10);
        make.height.equalTo(@(14));
        make.left.equalTo(titleLabel.mas_right).offset(20);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.contentView.mas_top);
    }];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
}



- (void)setChapterWithModel:(JUDIAN_READ_NovelSummaryModel*)model {
    
    _topLineView.hidden = YES;
    _bottomLineView.hidden = YES;
    
    _titleLabel.text = @"目录";
    NSString* state = [model getNovelStateStr];
    if (state.length <= 0) {
        _catagoryLabel.text = @"";
    }
    else {
        _catagoryLabel.text = [NSString stringWithFormat:@"%@, 共%@章", state, model.chapters_total];
    }
    
    CGFloat width = [_titleLabel getTextWidth:16];
    width = ceil(width);
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
}



- (void)setEditorWithModel:(JUDIAN_READ_NovelSummaryModel*)model {
    
    _topLineView.hidden = NO;
    _bottomLineView.hidden = NO;
    
    _titleLabel.text = @"聚合内容源";
    _catagoryLabel.text = model.editorid;
    
    CGFloat width = [_titleLabel getTextWidth:16];
    width = ceil(width);
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}



@end
