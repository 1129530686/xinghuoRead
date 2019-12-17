//
//  JUDIAN_READ_NovelNavigationBar.m
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelNavigationBar.h"

@interface JUDIAN_READ_NovelNavigationBar ()

@property(nonatomic, weak) UIButton* backButton;
@property(nonatomic, weak) UIButton* shareButton;

@end



@implementation JUDIAN_READ_NovelNavigationBar

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
    
}


- (void)addViews {
    
    UIButton* backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _backButton = backButton;
    UIImage* leftArrowImage = [UIImage imageNamed:@"nav_return_white"];
    [backButton setImage:leftArrowImage forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:backButton];
    [backButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton* shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _shareButton = shareButton;
    [shareButton setImage:[UIImage imageNamed:@"nav_share_white_tip"] forState:(UIControlStateNormal)];
    [shareButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:shareButton];
    [shareButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightRegular)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"";
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    
    WeakSelf(that);
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(44));
        make.height.equalTo(@(46));
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.width.equalTo(@(44));
        make.height.equalTo(@(46));
        make.centerY.equalTo(that.mas_centerY);
        
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).offset(10);
        make.right.equalTo(shareButton.mas_left).offset(-10);
        make.height.equalTo(@(18));
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
}



- (void)handleTouchEvent:(UIButton*)sender {
    if (!_block) {
        return;
    }

    if (sender == _backButton) {
        _block(@"0");
    }
    else if(sender == _shareButton) {
        _block(@"1");
    }

}




- (void)changeBarStyle:(BOOL)isTransparent {
    
    NSString* leftArrowName = @"";
    NSString* shareName = @"";
    
    if (isTransparent) {
        leftArrowName = @"nav_return_white";
        shareName = @"nav_share_white_tip";
        _titleLabel.hidden = YES;
    }
    else {
        leftArrowName = @"nav_return_black";
        shareName = @"nav_share_black_tip";
        _titleLabel.hidden = NO;
    }
    

    [_backButton setImage:[UIImage imageNamed:leftArrowName] forState:(UIControlStateNormal)];
    [_shareButton setImage:[UIImage imageNamed:shareName] forState:(UIControlStateNormal)];
    
    
}


- (void)showShareButton:(BOOL)visible {
    _shareButton.hidden = !visible;
}




@end
