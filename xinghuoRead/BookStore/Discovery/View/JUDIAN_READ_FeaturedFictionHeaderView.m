//
//  JUDIAN_READ_FeaturedFictionHeaderView.m
//  xinghuoRead
//
//  Created by judian on 2019/8/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FeaturedFictionHeaderView.h"
#import "UILabel+JUDIAN_READ_Label.h"


@implementation JUDIAN_READ_FeaturedFictionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews:frame];
    }
    return self;
}



- (void)addViews:(CGRect)frame {
    
    UIView* container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    
    UIImageView* headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"default_v_image"];
    [self addSubview:headImageView];
    
    
    UILabel* bookNameLabel = [[UILabel alloc] init];
    bookNameLabel.font = [UIFont systemFontOfSize:19 weight:(UIFontWeightMedium)];
    bookNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    bookNameLabel.text = @"圣兽帝国";
    [self addSubview:bookNameLabel];
    
    
    UILabel* bookTypeLabel = [[UILabel alloc] init];
    bookTypeLabel.font = [UIFont systemFontOfSize:12];
    bookTypeLabel.textColor = RGB(0x66, 0x66, 0x66);
    bookTypeLabel.text = @"风中有种云做的雨";
    [self addSubview:bookTypeLabel];
    
    
    UILabel* fansCountLabel = [[UILabel alloc] init];
    fansCountLabel.font = [UIFont systemFontOfSize:12];
    fansCountLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    fansCountLabel.text = @"14.8W人气";
    [self addSubview:fansCountLabel];
    
    
    UIButton* favoriteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage* image = [UIImage imageNamed:@"favorite_book_tip"];
    [favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [self addSubview:favoriteButton];
    
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.top.equalTo(that.mas_top);
        make.width.equalTo(that.mas_width);
        make.height.equalTo(that.mas_height);
    }];
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(20);
        make.centerY.equalTo(that.mas_centerY);
        make.width.equalTo(@(48));
        make.height.equalTo(@(68));
    }];
    
    
    
    [favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-20);
        make.bottom.equalTo(headImageView.mas_bottom).offset(-3);
        make.width.equalTo(@(80));
        make.height.equalTo(@(27));
    }];
    
    
    CGFloat width = [fansCountLabel getTextWidth:12];
    width = ceil(width);

    [fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-20);
        make.height.equalTo(@(12));
        make.bottom.equalTo(favoriteButton.mas_top).offset(-13);
        make.width.equalTo(@(width));
    }];
    
    
    CGFloat height = CGRectGetHeight(frame);
    //20 - 17 - 12;
    CGFloat topOffset = (height - 49) / 2;
    
    [bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(13);
        make.top.equalTo(that.mas_top).offset(topOffset);
        make.height.equalTo(@(20));
        make.right.equalTo(fansCountLabel.mas_left).offset(-30);
    }];
    
    
    [bookTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookNameLabel.mas_left);
        make.height.equalTo(@(12));
        make.top.equalTo(bookNameLabel.mas_bottom).offset(17);
        make.right.equalTo(bookNameLabel.mas_right);
    }];
    
}


@end
