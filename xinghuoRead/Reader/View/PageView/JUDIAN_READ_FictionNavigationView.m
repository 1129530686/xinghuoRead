//
//  JUDIAN_READ_FictionNavigationView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionNavigationView.h"
#import "JUDIAN_READ_VerticalStyleButton.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_FictionNavigationView ()
@property(nonatomic, weak)UIButton* leftButton;
@property(nonatomic, weak)JUDIAN_READ_VerticalStyleButton* moreButton;
@property(nonatomic, weak)JUDIAN_READ_VerticalStyleButton* nightButton;
@property(nonatomic, weak)JUDIAN_READ_VerticalStyleButton* catalogButton;
@property(nonatomic, weak)UIView* lineView;
@end


@implementation JUDIAN_READ_FictionNavigationView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = RGB(0xff, 0xff, 0xff);
        self.isShow = FALSE;
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
    
    //10 + 36 + 20 + 36 + 20 + 36 + 10
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(37);
        make.centerY.equalTo(leftButton.mas_centerY);
        make.height.equalTo(@(14));
        make.right.equalTo(that.mas_right).offset(-168);
        //make.width.equalTo(@(136));
    }];
    
    
    //更多
    JUDIAN_READ_VerticalStyleButton *moreButton = [[JUDIAN_READ_VerticalStyleButton alloc] initWithTitle:CGRectMake(0, 27, 26, 10) imageFrame:CGRectMake(0, 0, 20, 20)];
    moreButton.tag = kMoreCmd;
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [self addSubview:moreButton];
    [moreButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    _moreButton = moreButton;
    
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(26));
        make.height.equalTo(@(36));
        make.right.equalTo(that.mas_right).offset(-10);
        make.bottom.equalTo(that.mas_bottom).offset(-7);
    }];
    
    
    //夜间
    JUDIAN_READ_VerticalStyleButton *nightButton = [[JUDIAN_READ_VerticalStyleButton alloc] initWithTitle:CGRectMake(0, 27, 26, 10) imageFrame:CGRectMake(0, 0, 20, 20)];
    nightButton.tag = kNightCmd;
    [nightButton setTitle:@"夜间" forState:UIControlStateNormal];
    [self addSubview:nightButton];
    [nightButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    _nightButton = nightButton;
    
    [nightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(38));
        make.height.equalTo(@(36));
        make.right.equalTo(moreButton.mas_left).offset(-20);
        make.bottom.equalTo(that.mas_bottom).offset(-7);
    }];
    
    
    //目录
    JUDIAN_READ_VerticalStyleButton *catalogButton = [[JUDIAN_READ_VerticalStyleButton alloc] initWithTitle:CGRectMake(0, 27, 26, 10) imageFrame:CGRectMake(0, 0, 20, 20)];
    catalogButton.tag = kCatalogCmd;
    [catalogButton setTitle:@"目录" forState:UIControlStateNormal];
    [self addSubview:catalogButton];
    [catalogButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    _catalogButton = catalogButton;
    
    [catalogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(26));
        make.height.equalTo(@(36));
        make.right.equalTo(nightButton.mas_left).offset(-20);
        make.bottom.equalTo(that.mas_bottom).offset(-7);
    }];
    
    
    UIControl* backControl = [[UIControl alloc]init];
    backControl.tag = kBackCmd;
    [backControl addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:backControl];
    
    [backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.height.equalTo(that.mas_height);
        //make.right.equalTo(titleLabel.mas_right);
        make.width.equalTo(@(136));
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
        [self setNightStyle];
    }
    else {
        [self setDayStyle];
    }
}



- (void)setDayStyle {
    
    self.backgroundColor = RGB(0xff, 0xff, 0xff);
    
    _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    
    [_leftButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"reader_left_back_tip"] forState:UIControlStateNormal];
    
    
    [_moreButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"reader_more_tip"] forState:UIControlStateNormal];
    
    
    [_nightButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
    [_nightButton setImage:[UIImage imageNamed:@"reader_night_tip"] forState:UIControlStateNormal];
    
    
    [_catalogButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
    [_catalogButton setImage:[UIImage imageNamed:@"reader_catalog_tip"] forState:UIControlStateNormal];
    
    _lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    
}


- (void)setNightStyle {
    
    self.backgroundColor = READER_NAVIGATION_BAR_NIGHT_BG_COLOR;
    
    _titleLabel.textColor = READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR;
    
    [_leftButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"reader_left_back_tip_n"] forState:UIControlStateNormal];
    
    [_moreButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"reader_more_tip_n"] forState:UIControlStateNormal];
    
    
    [_nightButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [_nightButton setImage:[UIImage imageNamed:@"reader_sun_tip"] forState:UIControlStateNormal];
    
    [_catalogButton setTitleColor:READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [_catalogButton setImage:[UIImage imageNamed:@"reader_catalog_tip_n"] forState:UIControlStateNormal];
    
    _lineView.backgroundColor = RGB(0x33, 0x33, 0x33);
    
}



- (void)handleTouchEvent:(UIButton*)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(sender.tag)}];
    
}



- (void)hideButton:(BOOL)canShare {
    
    _catalogButton.hidden = YES;
    _nightButton.hidden = !canShare;
    _moreButton.hidden = NO;
    
    [_moreButton setTitle:@"书城" forState:UIControlStateNormal];
    _moreButton.tag = kToBookStoreCmd;
    [_moreButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"to_book_store_tip"] forState:UIControlStateNormal];
    
    [_nightButton setTitle:@"分享" forState:UIControlStateNormal];
    _nightButton.tag = kMenuItemShareCmd;
    [_nightButton setTitleColor:READER_TAB_BAR_TEXT_COLOR forState:UIControlStateNormal];
    [_nightButton setImage:[UIImage imageNamed:@"share_complete_fiction_tip"] forState:UIControlStateNormal];
    
    NSInteger offset = 56;//36 + 10 + 10;
    if (canShare) {
        offset += 56;//36 + 20;
    }
    
    WeakSelf(that);
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-offset);
    }];
}


@end
