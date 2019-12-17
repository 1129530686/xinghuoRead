//
//  JUDIAN_READ_NovelBottomBar.m
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelBottomBar.h"

@interface JUDIAN_READ_NovelBottomBar ()
@property(nonatomic, weak)UIButton* cachedButton;
@property(nonatomic, weak)UIButton* collectButton;
@property(nonatomic, weak)UIButton* freeReadButton;
@end



@implementation JUDIAN_READ_NovelBottomBar

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIButton* cachedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _cachedButton = cachedButton;
    [cachedButton setTitle:@"已缓存" forState:(UIControlStateNormal)];
    [cachedButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    cachedButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:cachedButton];
    [cachedButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton* collectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _collectButton = collectButton;
    //99 99 99 已收藏
    [collectButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    [collectButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    collectButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:collectButton];
    [collectButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton* freeReadButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _freeReadButton = freeReadButton;
    [freeReadButton setTitle:@"免费阅读全文" forState:(UIControlStateNormal)];
    [freeReadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    freeReadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [freeReadButton setBackgroundImage:[UIImage imageNamed:@"novel_bottom_button"] forState:UIControlStateNormal];
    [self addSubview:freeReadButton];
    [freeReadButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIView* topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:topLineView];
    

    UIView* bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:bottomLineView];
    
    UIImageView* buttonLineView = [[UIImageView alloc] init];
    buttonLineView.image = [UIImage imageNamed:@"top_button_line_view"];
    [self addSubview:buttonLineView];
    
    WeakSelf(that);
    [cachedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(that.mas_width).multipliedBy(0.25);
        make.height.equalTo(that.mas_height);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right);
        make.width.equalTo(that.mas_width).multipliedBy(0.25);
        make.height.equalTo(that.mas_height);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [freeReadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cachedButton.mas_right);
        make.right.equalTo(collectButton.mas_left);
        make.height.equalTo(that.mas_height);
        make.centerY.equalTo(that.mas_centerY);
    }];
    

    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.mas_top);
    }];
    
    
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(that.mas_bottom);
    }];
    
    [buttonLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(freeReadButton.mas_right).offset(4);
        make.left.equalTo(freeReadButton.mas_left).offset(-4);
        make.height.equalTo(@(2.5));
        make.top.equalTo(freeReadButton.mas_top).offset(-2);
    }];
    
}



- (void)handleTouchEvent:(UIButton*)sender {
    
    if (!_block) {
        return;
    }
    
    if (sender == _cachedButton) {
        _block(@"0");
    }
    else if (sender == _freeReadButton) {
        _block(@"1");
    }
    else if (sender == _collectButton) {
        _block(@"2");
    }

}




- (void)setCacheText:(NSString*)text {
    [_cachedButton setTitle:text forState:(UIControlStateNormal)];
    if([text isEqualToString:@"已缓存"]) {
        [_cachedButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    }
    else {
        [_cachedButton setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:UIControlStateNormal];
    }
}


- (void)enableCachedButton:(BOOL)isCached {
    _cachedButton.userInteractionEnabled = isCached;
}

- (void)updateFavouriteName:(NSString*)text {
    [_collectButton setTitle:text forState:(UIControlStateNormal)];
    
    if ([text isEqualToString:@"已收藏"]) {
        _collectButton.userInteractionEnabled = NO;
        [_collectButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    }
    else {
        _collectButton.userInteractionEnabled = YES;
    }
}


- (BOOL)isButtonEnable {
    return _cachedButton.userInteractionEnabled;
}



@end
