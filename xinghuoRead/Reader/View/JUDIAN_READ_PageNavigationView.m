//
//  JUDIAN_READ_PageNavigationView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/24.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PageNavigationView.h"
#import "JUDIAN_READ_VerticalStyleButton.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_PageNavigationView ()
@property(nonatomic, weak)UIButton* leftButton;
@property(nonatomic, weak)JUDIAN_READ_VerticalStyleButton* moreButton;
@property(nonatomic, weak)JUDIAN_READ_VerticalStyleButton* noAdButton;
@property(nonatomic, weak)JUDIAN_READ_VerticalStyleButton* downloadButton;

@property(nonatomic, weak)UIButton* feedbackButton;
@property(nonatomic, weak)UIButton* shareButton;
@property(nonatomic, weak)UIView* lineView;
@end




@implementation JUDIAN_READ_PageNavigationView


- (instancetype)init {
 
    self = [super init];
    if (self) {
        self.backgroundColor = RGB(0xff, 0xff, 0xff);
        [self addViews];
        [self setViewStyle];
    }
    return self;
}



- (void)addViews {
 
    WeakSelf(that);
    
    //返回按钮
    UIButton* leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.tag = kBackCmd;
    [self addSubview:leftButton];
    _leftButton = leftButton;

    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(0);
        make.bottom.equalTo(that.mas_bottom);
        make.width.equalTo(@(37));
        make.height.equalTo(@(48));
    }];

    

    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    titleLabel.text = @"";
    
    UIColor* buttonColor = RGB(0x66, 0x66, 0x66);
    UIButton* feedbackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _feedbackButton = feedbackButton;
    feedbackButton.tag = kMenuItemFeedbackCmd;
    [feedbackButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [feedbackButton setTitle:@"反馈" forState:(UIControlStateNormal)];
    [feedbackButton setTitleColor:buttonColor forState:(UIControlStateNormal)];
    feedbackButton.titleLabel.font = [UIFont systemFontOfSize:12];
    feedbackButton.layer.cornerRadius = 3;
    feedbackButton.layer.borderWidth = 0.5;
    feedbackButton.layer.borderColor = buttonColor.CGColor;
    [self addSubview:feedbackButton];
    
    [feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-60);
        make.height.equalTo(@(20));
        make.width.equalTo(@(40));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(37);
        make.centerY.equalTo(leftButton.mas_centerY);
        make.height.equalTo(@(14));
        make.right.equalTo(feedbackButton.mas_left).offset(-30);
    }];
    
    
    UIButton* shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _shareButton = shareButton;
    shareButton.tag = kMoreCmd;
    UIImage* image = [UIImage imageNamed:@"reader_bar_share_tip"];
    [shareButton setImage:image forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(20));
        make.width.equalTo(@(40));
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    UIControl* backControl = [[UIControl alloc]init];
    backControl.tag = kBackCmd;
    [backControl addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:backControl];
    
    [backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.height.equalTo(that.mas_height);
        make.right.equalTo(titleLabel.mas_right);
        make.top.equalTo(that.mas_top);
    }];
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:lineView];
    _lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.width.equalTo(that.mas_width);
        make.bottom.equalTo(that.mas_bottom);
    }];

}



- (void)setViewStyle {
 
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        
        self.backgroundColor = RGB(0x33, 0x33, 0x33);

        _titleLabel.textColor = READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR;
        
        [_leftButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"reader_left_back_tip_n"] forState:UIControlStateNormal];
        
        [_feedbackButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
        _feedbackButton.layer.borderColor = READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR.CGColor;
        
        [_shareButton setImage:[UIImage imageNamed:@"reader_bar_share_tip"] forState:UIControlStateNormal];

        _lineView.backgroundColor = RGB(0x33, 0x33, 0x33);
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];

        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
        
        [_leftButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"reader_left_back_tip"] forState:UIControlStateNormal];
        
        [_feedbackButton setTitleColor:_titleLabel.textColor forState:UIControlStateNormal];
        _feedbackButton.layer.borderColor = _titleLabel.textColor.CGColor;
        
        [_shareButton setImage:[UIImage imageNamed:@"reader_bar_share_tip_n"] forState:UIControlStateNormal];
        
        _lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    }

}




- (void)handleTouchEvent:(UIButton*)sender {
    
    if (_bookName.length <= 0 || _chapterName.length <= 0) {
        return;
    }
    

    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{
                                                                                        @"cmd":@(sender.tag),
                                                                                        @"bookName": _bookName,
                                                                                        @"chapterName" : _chapterName
                                                                                        }];
    
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
