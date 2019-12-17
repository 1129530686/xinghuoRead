//
//  JUDIAN_READ_NovelShareLogoItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelShareLogoItem.h"
#import "JUDIAN_READ_ShareLogo.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_NovelShareLogoItem ()
@property(nonatomic, weak)UIScrollView* scrollview;

@end


@implementation JUDIAN_READ_NovelShareLogoItem


- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self addButtonToScrollView];
    }

    return self;
}



- (instancetype)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        if (index == 0) {
            [self add4Views];
        }
        else {
            [self add2Views];
        }
        
    }
    return self;
}


- (void)add4Views {
    
    JUDIAN_READ_ShareLogo* weixinView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"weixin_logo" title:@"微信" height:50];
    weixinView.tag = kWeixinTag;
    [self addSubview:weixinView];
    [weixinView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];

    JUDIAN_READ_ShareLogo* friendView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"weixin_friend_logo" title:@"朋友圈" height:50];
    friendView.tag = kFriendTag;
    [self addSubview:friendView];
    [friendView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    JUDIAN_READ_ShareLogo* qqView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"qq_logo" title:@"QQ好友" height:50];
    qqView.tag = kQQTag;
    [self addSubview:qqView];
    [qqView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    JUDIAN_READ_ShareLogo* qqZoneView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"qq_zone_logo" title:@"QQ空间" height:50];
    qqZoneView.tag = kQQZoneTag;
    [self addSubview:qqZoneView];
    [qqZoneView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    

    WeakSelf(that);

    // 计算间隔距离
    CGFloat padding = (SCREEN_WIDTH - 50 * 4 - 27 * 2) / 3;
    
    [weixinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(that.mas_left).offset(27);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [friendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(weixinView.mas_right).offset(padding);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(friendView.mas_right).offset(padding);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [qqZoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(qqView.mas_right).offset(padding);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
}



- (void)add2Views {
  
    JUDIAN_READ_ShareLogo* weiboView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"weibo_logo" title:@"微博" height:50];
    weiboView.tag = kWeiboTag;
    [self addSubview:weiboView];
    [weiboView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    JUDIAN_READ_ShareLogo* copyLinkView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"copy_link_logo" title:@"复制链接" height:50];
    copyLinkView.tag = kCopyLinkTag;
    [self addSubview:copyLinkView];
    [copyLinkView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];

    WeakSelf(that);
    
    // 计算间隔距离
    CGFloat padding = (SCREEN_WIDTH - 50 * 4 - 27 * 2) / 3;
    
    [weiboView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(that.mas_left).offset(27);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [copyLinkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(that.mas_height);
        make.left.equalTo(weiboView.mas_right).offset(padding);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
}




- (void)addButtonToScrollView {

    UIScrollView* scrollview = [[UIScrollView alloc]init];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    
    NSInteger leftMargin = 34;
    CGFloat padding = [self getButtonPadding];
    
    _scrollview = scrollview;
    NSInteger width = 5 * padding + 40 * 6 + 2 * leftMargin;
    scrollview.contentSize = CGSizeMake(width, 122);
    [self addSubview:scrollview];
    
    
    UIView* bottomLineView = [[UIView alloc]init];
    _bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self addSubview:bottomLineView];
    

    JUDIAN_READ_ShareLogo* weixinView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"weixin_logo" title:@"微信" height:40];
    weixinView.tag = kWeixinTag;
    [scrollview addSubview:weixinView];
    [weixinView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    JUDIAN_READ_ShareLogo* friendView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"weixin_friend_logo" title:@"朋友圈" height:40];
    friendView.tag = kFriendTag;
    [scrollview addSubview:friendView];
    [friendView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    JUDIAN_READ_ShareLogo* qqView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"qq_logo" title:@"QQ好友" height:40];
    qqView.tag = kQQTag;
    [scrollview addSubview:qqView];
    [qqView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    JUDIAN_READ_ShareLogo* qqZoneView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"qq_zone_logo" title:@"QQ空间" height:40];
    qqZoneView.tag = kQQZoneTag;
    [scrollview addSubview:qqZoneView];
    [qqZoneView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    JUDIAN_READ_ShareLogo* weiboView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"weibo_logo" title:@"微博" height:40];
    weiboView.tag = kWeiboTag;
    [scrollview addSubview:weiboView];
    [weiboView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    JUDIAN_READ_ShareLogo* copyLinkView = [[JUDIAN_READ_ShareLogo alloc]initWithImage:@"copy_link_logo" title:@"复制链接" height:40];
    copyLinkView.tag = kCopyLinkTag;
    [scrollview addSubview:copyLinkView];
    [copyLinkView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    

    WeakSelf(that);
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(122));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.mas_bottom).offset(-0.5);
    }];
    
    // 计算间隔距离
    CGFloat buttonWidth = 40;
    CGFloat buttonHeight = 70;
    CGFloat top = 34;
    
    
    
    [weixinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.equalTo(scrollview.mas_left).offset(leftMargin);
        make.top.equalTo(scrollview.mas_top).offset(top);
    }];
    
    
    [friendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.equalTo(weixinView.mas_right).offset(padding);
        make.top.equalTo(scrollview.mas_top).offset(top);
    }];
    
    
    [qqView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.equalTo(friendView.mas_right).offset(padding);
        make.top.equalTo(scrollview.mas_top).offset(top);
    }];
    
    
    [qqZoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.equalTo(qqView.mas_right).offset(padding);
        make.top.equalTo(scrollview.mas_top).offset(top);
    }];
    

    [weiboView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.equalTo(qqZoneView.mas_right).offset(padding);
        make.top.equalTo(scrollview.mas_top).offset(top);
    }];
    
    
    [copyLinkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.left.equalTo(weiboView.mas_right).offset(padding);
        make.top.equalTo(scrollview.mas_top).offset(top);
    }];
    
}



- (NSInteger)getButtonPadding {
    
    if (iPhone5 || iPhone6) {
        return 40;
    }
    
    if (iPhone6Plus) {
        return 34;
    }
    
    return 40;

}


- (void)handleTouchEvent:(UIControl*)sender {
    
    if (_block) {
        _block(@(sender.tag));
    }
    
}


- (void)setViewStyle {
    UIView* parentView = self;
    if (_scrollview) {
        parentView = _scrollview;
    }
    
    for (NSInteger index = 0; index < 6; index++) {
        JUDIAN_READ_ShareLogo* logoView = [parentView viewWithTag:kWeixinTag + index];
        [logoView setViewStyle];
    }
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _bottomLineView.backgroundColor = RGB(0x66, 0x66, 0x66);
    }
    else {
        _bottomLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    }

}





@end
