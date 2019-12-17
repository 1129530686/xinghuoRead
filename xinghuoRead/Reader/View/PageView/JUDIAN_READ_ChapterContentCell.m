//
//  JUDIAN_READ_ChapterContentCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterContentCell.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_FictionTextContainer.h"
#import "JUDIAN_READ_TextStyleModel.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_ChapterContentCell ()

@end



@implementation JUDIAN_READ_ChapterContentCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    JUDIAN_READ_FictionTextContainer* textView = [[JUDIAN_READ_FictionTextContainer alloc]init];
    [self.contentView addSubview:textView];
    _textView = textView;
    
#if 0
    UIControl* touchControl = [[UIControl alloc] init];
    [touchControl addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:touchControl];
#endif
    
    WeakSelf(that);
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(CONTENT_VIEW_SIDE_EDGE);
        make.right.equalTo(that.contentView.mas_right).offset(-CONTENT_VIEW_SIDE_EDGE);
        make.height.equalTo(that.mas_height);
        make.top.equalTo(that.mas_top);
    }];
    
#if 0
    [touchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.width.equalTo(that.contentView.mas_width).multipliedBy(0.5);
        make.height.equalTo(that.mas_height);
        make.top.equalTo(that.mas_top);
    }];
#endif
}



- (void)setContent:(NSAttributedString*)attributedText {
    //_attributedString = attributedText;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.attributedString = attributedText;
    [_textView setNeedsDisplay];
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.contentView.backgroundColor = [style getBgColor];
}


- (void)handleTouchEvent:(id)sender {
    if (_block) {
        _block(@"");
    }
}


@end



@interface JUDIAN_READ_SegmentChapterContentCell ()
@property(nonatomic, weak)UIButton* moreContentView;
@end



@implementation JUDIAN_READ_SegmentChapterContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addMoreTipView];
    }
    return self;
}


- (void)addMoreTipView {
    
    UIButton* moreContentView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _moreContentView = moreContentView;
    [moreContentView setBackgroundImage:[UIImage imageNamed:@"novel_more_content_tip"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:moreContentView];
    
    [moreContentView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = RGB(0x99, 0x99, 0x99);
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.text = @"展开更多";
    [moreContentView addSubview:tipLabel];
    
    UIImageView* arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"novel_extra_down_arrow"];
    [moreContentView addSubview:arrowImageView];
    
    moreContentView.hidden = YES;
    
    //13 + 2 + 7
    //CGFloat topOffset = 39;
    WeakSelf(that);
    [moreContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(200));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    CGFloat width = [tipLabel getTextWidth:13];
    width = ceil(width);
    CGFloat centerX = (SCREEN_WIDTH - width - 2 - 12) / 2;

    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moreContentView.mas_left).offset(centerX);
        make.width.equalTo(@(width));
        make.height.equalTo(@(13));
        make.bottom.equalTo(moreContentView.mas_bottom).offset(-24);
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(12));
        make.height.equalTo(@(7));
        make.left.equalTo(tipLabel.mas_right).offset(2);
        make.centerY.equalTo(tipLabel.mas_centerY);
    }];
}



- (void)setContent:(NSAttributedString*)attributedText nextTip:(BOOL)nextTip {
    //_attributedString = attributedText;
    self.textView.bgColor = [UIColor whiteColor];
    self.textView.attributedString = attributedText;
    [self.textView setNeedsDisplay];
    
    self.contentView.backgroundColor = [UIColor whiteColor];

    _moreContentView.hidden = YES;
    if (nextTip) {
        _moreContentView.hidden = NO;
    }

}


- (void)handleTouchEvent:(id)sender {
    if (_nextRenderBlock) {
        _nextRenderBlock(nil);
    }
}



@end
