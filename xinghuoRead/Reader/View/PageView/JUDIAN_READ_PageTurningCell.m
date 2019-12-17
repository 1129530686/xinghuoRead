//
//  JUDIAN_READ_PageTurningCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PageTurningCell.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_TextStyleModel.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_PageTurningCell ()
@property(nonatomic, weak)UIButton* shareButton;
@property(nonatomic, weak)UIButton* forwardChapterButton;
@property(nonatomic, weak)UIButton* nextChapterButton;
@property(nonatomic, weak)UIButton* catalogButton;
@end


@implementation JUDIAN_READ_PageTurningCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIButton* nextChapterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextChapterButton.layer.cornerRadius = 3;
    nextChapterButton.layer.masksToBounds = YES;
    nextChapterButton.tag = kPageTurningNextCmd;
    [nextChapterButton setTitle:@"下一章" forState:(UIControlStateNormal)];
    [nextChapterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextChapterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextChapterButton setBackgroundImage:[UIImage imageNamed:@"novel_bottom_button"] forState:UIControlStateNormal];
    [self.contentView addSubview:nextChapterButton];
    [nextChapterButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    

    UIButton* shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _shareButton = shareButton;
    shareButton.layer.cornerRadius = 3;
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
    shareButton.layer.borderWidth = 0.5;
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [shareButton setTitle:@"上一章" forState:(UIControlStateNormal)];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    [self.contentView addSubview:shareButton];
    shareButton.tag = kPageTurningForwardCmd;
    [shareButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton* forwardChapterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _forwardChapterButton = forwardChapterButton;
    forwardChapterButton.layer.cornerRadius = 3;
    forwardChapterButton.layer.masksToBounds = YES;
    forwardChapterButton.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
    forwardChapterButton.layer.borderWidth = 0.5;
    
    forwardChapterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forwardChapterButton setTitle:@"目录" forState:(UIControlStateNormal)];
    [forwardChapterButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    [self.contentView addSubview:forwardChapterButton];
    forwardChapterButton.tag = kPageTurningCatalogCmd;
    [forwardChapterButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton* catalogButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _catalogButton = catalogButton;
    catalogButton.layer.cornerRadius = 3;
    catalogButton.layer.masksToBounds = YES;
    catalogButton.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
    catalogButton.layer.borderWidth = 0.5;
    
    catalogButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [catalogButton setTitle:@"意见反馈" forState:(UIControlStateNormal)];
    [catalogButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    [self.contentView addSubview:catalogButton];
    catalogButton.tag = kPageTurningSuggestCmd;
    [catalogButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    NSInteger buttonWidth = (SCREEN_WIDTH - 2 * 20 - 2 * 10) / 3;

    NSInteger nextButtonHeight = 33;
    if (iPhone6Plus) {
        nextButtonHeight = 40;
    }
    
    WeakSelf(that);
    [forwardChapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(33));
        //make.centerY.equalTo(that.contentView.mas_centerY);
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-27);
    }];
    
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(33));
        
        make.left.equalTo(that.contentView.mas_left).offset(20);
        //make.centerY.equalTo(that.contentView.mas_centerY);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-27);
    }];
    
    [catalogButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(33));
        
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        //make.centerY.equalTo(that.contentView.mas_centerY);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-27);
    }];
    
    
    [nextChapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(20);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.height.equalTo(@(nextButtonHeight));
        make.bottom.equalTo(forwardChapterButton.mas_top).offset(-13);
    }];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}




- (void)handleTouchEvent:(UIButton*)sender {
    if (_block) {
        _block(@(sender.tag));
    }
}



- (void)setViewStyle {
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.backgroundColor = [style getBgColor];
    
    UIColor* textColor = RGB(0x33, 0x33, 0x33);
    UIColor* borderColor = RGB(0xcc, 0xcc, 0xcc);
    NSString* imageName = @"reader_small_share_tip";
    if([style isNightMode]) {
        imageName = @"reader_small_share_tip_n";
        textColor = RGB(0x88, 0x88, 0x88);
        borderColor = RGB(0x33, 0x33, 0x33);
    }

    if (style.bgColorIndex == kLightYellowIndex || style.bgColorIndex == kLightGreenIndex) {
       borderColor = RGB(0x99, 0x99, 0x99);
    }
    
    _shareButton.layer.borderColor = borderColor.CGColor;
    [_shareButton setTitleColor:textColor forState:(UIControlStateNormal)];
    //[_shareButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    _forwardChapterButton.layer.borderColor = borderColor.CGColor;
    [_forwardChapterButton setTitleColor:textColor forState:(UIControlStateNormal)];
    
    _nextChapterButton.layer.borderColor = borderColor.CGColor;
    [_nextChapterButton setTitleColor:textColor forState:(UIControlStateNormal)];
    
    _catalogButton.layer.borderColor = borderColor.CGColor;
    [_catalogButton setTitleColor:textColor forState:(UIControlStateNormal)];
}



@end
