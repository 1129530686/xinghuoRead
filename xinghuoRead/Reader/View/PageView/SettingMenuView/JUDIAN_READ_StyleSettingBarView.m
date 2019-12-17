//
//  JUDIAN_READ_StyleSettingBarView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_StyleSettingBarView.h"
#import "JUDIAN_READ_StyleSettingItem.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_StyleSettingBarView ()
@property(nonatomic, weak)JUDIAN_READ_StyleSettingItem* settingView;
@property(nonatomic, weak)JUDIAN_READ_StyleSettingItem* introductionView;
@property(nonatomic, weak)JUDIAN_READ_StyleSettingItem* errorReportView;
@end



@implementation JUDIAN_READ_StyleSettingBarView


- (instancetype)init {
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
   JUDIAN_READ_StyleSettingItem* settingView = [[JUDIAN_READ_StyleSettingItem alloc]initWithImage:@"reader_style_setting" title:@"设置"];
    settingView.tag = kStyleSettingCmd;
    _settingView = settingView;
    [self addSubview:settingView];
    [settingView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    settingView.hidden = YES;
    
    JUDIAN_READ_StyleSettingItem* introductionView = [[JUDIAN_READ_StyleSettingItem alloc]initWithImage:@"reader_novel_introduction_tip" title:@"简介"];
    introductionView.tag = kMenuItemIntroductionCmd;
    _introductionView = introductionView;
    [self addSubview:introductionView];
    [introductionView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    introductionView.hidden = NO;
    
    
    JUDIAN_READ_StyleSettingItem* errorReportView = [[JUDIAN_READ_StyleSettingItem alloc]initWithImage:@"reader_chapter_error_tip" title:@"报错及投诉"];
    errorReportView.tag = kMenuItemFeedbackCmd;
    _errorReportView = errorReportView;
    [self addSubview:errorReportView];
    [errorReportView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    errorReportView.hidden = YES;
    
    
    
    WeakSelf(that);
    [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(that.mas_top).offset(32);
        make.left.equalTo(that.mas_left).offset(38);
        make.width.equalTo(@(31));
        make.height.equalTo(@(49));
        
    }];
    
    
    
    [introductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(that.mas_top).offset(29);
        //make.left.equalTo(settingView.mas_right).offset(45);
        make.left.equalTo(that.mas_left).offset(38);
        make.width.equalTo(@(26));
        make.height.equalTo(@(52));
        
    }];
    
    
    [errorReportView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(that.mas_top).offset(28);
        make.left.equalTo(introductionView.mas_right).offset(45);
        make.width.equalTo(@(29));
        make.height.equalTo(@(52));
        
    }];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_settingView updateMargin:0 textTop:16];
    [_introductionView updateMargin:0 textTop:12];
    [_errorReportView updateMargin:0 textTop:12];
}



- (void)setViewStyle {
    
    [_settingView setViewStyle:@"reader_style_setting"];
    [_introductionView setViewStyle:@"reader_novel_introduction_tip"];
    [_errorReportView setViewStyle:@"reader_chapter_error_tip"];
}









- (void)handleTouchEvent:(UIControl*)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(sender.tag),
                                                                                         @"value":@(0)
                                                                                         }];
    
    
}



@end
