//
//  JUDIAN_READ_ContentFeedbackCatagoryItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentFeedbackCatagoryItem.h"
#import "JUDIAN_READ_FeedbackCatagoryButton.h"


@implementation JUDIAN_READ_ContentFeedbackCatagoryItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
    JUDIAN_READ_FeedbackCatagoryButton* chapterErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    chapterErrorButton.tag = kChapterErrorTag;
    chapterErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [chapterErrorButton setTitle:@"章节乱序" forState:(UIControlStateNormal)];
    chapterErrorButton.isClicked = FALSE;
    [chapterErrorButton changeButtonStyle];
    [chapterErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:chapterErrorButton];
    
    
    JUDIAN_READ_FeedbackCatagoryButton* contentErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    contentErrorButton.tag = kContentErrorTag;
    contentErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [contentErrorButton setTitle:@"正文乱码" forState:(UIControlStateNormal)];
    [contentErrorButton changeButtonStyle];
    [contentErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:contentErrorButton];
    
    
    JUDIAN_READ_FeedbackCatagoryButton* layoutErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    layoutErrorButton.tag = kLayoutErrorTag;
    layoutErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [layoutErrorButton setTitle:@"排版错误" forState:(UIControlStateNormal)];
    [layoutErrorButton changeButtonStyle];
    [layoutErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:layoutErrorButton];
    
    JUDIAN_READ_FeedbackCatagoryButton* sexErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    sexErrorButton.tag = kSexErrorTag;
    sexErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [sexErrorButton setTitle:@"不良内容" forState:(UIControlStateNormal)];
    [sexErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [sexErrorButton changeButtonStyle];
    [self addSubview:sexErrorButton];
    
    
    JUDIAN_READ_FeedbackCatagoryButton* copyRightErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    copyRightErrorButton.tag = kCopyRightErrorTag;
    copyRightErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [copyRightErrorButton setTitle:@"内容侵权" forState:(UIControlStateNormal)];
    [copyRightErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [copyRightErrorButton changeButtonStyle];
    [self addSubview:copyRightErrorButton];
    
    JUDIAN_READ_FeedbackCatagoryButton* designErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    designErrorButton.tag = kAppDesignErrorTag;
    designErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [designErrorButton setTitle:@"提产品建议" forState:(UIControlStateNormal)];
    [designErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [designErrorButton changeButtonStyle];
    [self addSubview:designErrorButton];
    
    
    JUDIAN_READ_FeedbackCatagoryButton* otherErrorButton = [JUDIAN_READ_FeedbackCatagoryButton buttonWithType:(UIButtonTypeCustom)];
    otherErrorButton.tag = kOtherErrorTag;
    otherErrorButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [otherErrorButton setTitle:@"其他问题" forState:(UIControlStateNormal)];
    [otherErrorButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [otherErrorButton changeButtonStyle];
    [self addSubview:otherErrorButton];
    

    WeakSelf(that);
    [chapterErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(67));
        make.height.equalTo(@(30));
        make.left.equalTo(that.mas_left).offset(14);
        make.top.equalTo(that.mas_top);
    }];
    
    
    [contentErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(67));
        make.height.equalTo(@(30));
        make.left.equalTo(chapterErrorButton.mas_right).offset(10);
        make.top.equalTo(that.mas_top);
        
    }];
    
    
    [layoutErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(67));
        make.height.equalTo(@(30));
        make.left.equalTo(contentErrorButton.mas_right).offset(10);
        make.top.equalTo(that.mas_top);
        
    }];
    
    
    [sexErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(67));
        make.height.equalTo(@(30));
        make.left.equalTo(layoutErrorButton.mas_right).offset(10);
        make.top.equalTo(that.mas_top);
        
    }];
    
    
    [copyRightErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(67));
        make.height.equalTo(@(30));
        make.left.equalTo(that.mas_left).offset(14);
        make.top.equalTo(chapterErrorButton.mas_bottom).offset(10);
        
    }];
    

    [otherErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(67));
        make.height.equalTo(@(30));
        make.left.equalTo(copyRightErrorButton.mas_right).offset(10);
        make.top.equalTo(chapterErrorButton.mas_bottom).offset(10);
        
    }];
    
    [designErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(79));
        make.height.equalTo(@(30));
        make.left.equalTo(otherErrorButton.mas_right).offset(10);
        make.top.equalTo(chapterErrorButton.mas_bottom).offset(10);
        
    }];
    
}



- (void)handleTouchEvent:(JUDIAN_READ_FeedbackCatagoryButton*)sender {
#if 0
    for (NSInteger index = 0; index < 5; index++) {
        JUDIAN_READ_FeedbackCatagoryButton* button = [self viewWithTag:kChapterErrorTag + index];
        button.isClicked = FALSE;
        [button changeButtonStyle];
    }
#endif

    sender.isClicked = !sender.isClicked;
    [sender changeButtonStyle];

}


- (NSString*)getClickedButton {
    
    NSString* clickedString = @"";
    for (NSInteger index = 0; index < 7; index++) {
        JUDIAN_READ_FeedbackCatagoryButton* button = [self viewWithTag:kChapterErrorTag + index];
        
        if (button.isClicked) {
            clickedString = [clickedString stringByAppendingString:[NSString stringWithFormat:@"%ld,", index + 1]];
        }
        
        [button changeButtonStyle];
    }
    
    if (clickedString.length <= 0) {
        return @"";
    }
    
    clickedString = [clickedString substringWithRange:NSMakeRange(0, clickedString.length - 1)];
    return clickedString;
}




@end
