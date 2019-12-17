//
//  JUDIAN_READ_NovelNavigationBar.m
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelNavigationContainer.h"


@interface JUDIAN_READ_NovelNavigationContainer ()

@end


@implementation JUDIAN_READ_NovelNavigationContainer


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0xff, 0xff, 0xff, 0);
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    UIView* statusView = [[UIView alloc]init];
    [self addSubview:statusView];
    
    CGFloat statusViewHeight = 0;
    if (iPhoneX) {
        statusViewHeight = 44;
    }
    else {
        statusViewHeight = 20;
    }
    
    JUDIAN_READ_NovelNavigationBar* navigationBar = [[JUDIAN_READ_NovelNavigationBar alloc]init];
    _navigationBar = navigationBar;
    [self addSubview:navigationBar];
    
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:lineView];
    _lineView = lineView;
    lineView.hidden = YES;

    WeakSelf(that);
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that);
        make.height.equalTo(@(statusViewHeight));
    }];
    
    
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(statusView.mas_bottom);
        make.height.equalTo(@(44));
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.width.equalTo(that.mas_width);
        make.bottom.equalTo(that.mas_bottom);
    }];
    
}


- (void)changeBarTransparent:(CGFloat)alpha {
    self.backgroundColor = RGBA(0xff, 0xff, 0xff, alpha);
    if (alpha >= 0.8) {
        _lineView.hidden = NO;
        [_navigationBar changeBarStyle:FALSE];
    }
    else {
        _lineView.hidden = YES;
        [_navigationBar changeBarStyle:TRUE];
    }
    
}


- (void)setTitle:(NSString*)title {
    _navigationBar.titleLabel.text = title;
}


- (void)setTitleFont:(NSInteger)size {
    _navigationBar.titleLabel.font = [UIFont systemFontOfSize:size];
}


- (void)showShareButton:(BOOL)visible {
    [_navigationBar showShareButton:visible];
}



@end
