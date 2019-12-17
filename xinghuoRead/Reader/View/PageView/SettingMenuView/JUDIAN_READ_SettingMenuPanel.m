//
//  JUDIAN_READ_SettingMenuPanel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_SettingMenuPanel.h"
#import "JUDIAN_READ_NovelShareTipItem.h"
#import "JUDIAN_READ_NovelShareCancelItem.h"
#import "JUDIAN_READ_NovelShareLogoItem.h"
#import "JUDIAN_READ_StyleSettingBarView.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_TextStyleManager.h"


#define CONTAINER_HEIGHT (235 + 60)
#define SHARE_VIEW_HEIGHT (122 + 60)


@interface JUDIAN_READ_SettingMenuPanel ()

@property(nonatomic, strong)UIControl* container;
@property(nonatomic, weak)UIControl* emptyView;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, weak)JUDIAN_READ_NovelShareCancelItem* cancelItem;
@property(nonatomic, weak)JUDIAN_READ_StyleSettingBarView* settingView;
@property(nonatomic, weak)JUDIAN_READ_NovelShareLogoItem* logoItem;

@property(nonatomic, weak)UIView* topBarView;
@property(nonatomic, weak)UILabel* titleLabel;

@property(nonatomic, assign)BOOL isShareItem;

@end


@implementation JUDIAN_READ_SettingMenuPanel

- (instancetype)initWithId:(NSString*)bookId {
    self = [super init];
    if (self) {
        _bookId = bookId;
        _isShareItem = FALSE;
        [self addViews];
    }
    return self;
}


- (instancetype)initShareView:(NSString*)bookId {
    self = [super init];
    if (self) {
        _bookId = bookId;
        _isShareItem = TRUE;
        [self addShareItem];
    }
    return self;
}




- (void)addViews {
    
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIControl* emptyView = [[UIControl alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    _emptyView = emptyView;
    [self addSubview:emptyView];
    
    _container = [[UIControl alloc]init];
    _container.backgroundColor = [UIColor whiteColor];
    [self addSubview:_container];
    
    
    WeakSelf(that);
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(bottomOffset));
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(CONTAINER_HEIGHT));
        make.bottom.equalTo(that.mas_bottom).offset(CONTAINER_HEIGHT - bottomOffset);
    }];
    

    JUDIAN_READ_NovelShareLogoItem* logoItem = [[JUDIAN_READ_NovelShareLogoItem alloc]init];
    _logoItem = logoItem;
    [_container addSubview:logoItem];
    logoItem.block = ^(id  _Nonnull cmd) {
        [that excuteShareCmd:cmd];
    };
    
    [logoItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(122));
        make.top.equalTo(that.container.mas_top);
    }];
    
    
    
    JUDIAN_READ_StyleSettingBarView* settingView = [[JUDIAN_READ_StyleSettingBarView alloc]init];
    _settingView = settingView;
    [_container addSubview:settingView];
    
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(113));
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.top.equalTo(logoItem.mas_bottom);
    }];
    

    JUDIAN_READ_NovelShareCancelItem* cancelItem = [[JUDIAN_READ_NovelShareCancelItem alloc]init];
    _cancelItem = cancelItem;
    [_container addSubview:cancelItem];
    
    [cancelItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(60));
        make.bottom.equalTo(that.container.mas_bottom);
    }];
    
    [cancelItem addTarget:self action:@selector(removeSelf) forControlEvents:(UIControlEventTouchUpInside)];
    
}




- (void)addShareItem {
    
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIControl* emptyView = [[UIControl alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    _emptyView = emptyView;
    [self addSubview:emptyView];
    
    _container = [[UIControl alloc]init];
    _container.backgroundColor = [UIColor whiteColor];
    [self addSubview:_container];
    
    
    UIView* topBarView = [[UIView alloc]init];
    topBarView.backgroundColor = [UIColor whiteColor];
    _topBarView = topBarView;
    [_container addSubview:topBarView];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"分享到：";
    _titleLabel = titleLabel;
    [_container addSubview:titleLabel];
    
    

    WeakSelf(that);
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(bottomOffset));
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(SHARE_VIEW_HEIGHT));
        make.bottom.equalTo(that.mas_bottom).offset(SHARE_VIEW_HEIGHT - bottomOffset);
    }];
    
    
    JUDIAN_READ_NovelShareLogoItem* logoItem = [[JUDIAN_READ_NovelShareLogoItem alloc]init];
    logoItem.bottomLineView.hidden = YES;
    _logoItem = logoItem;
    [_container addSubview:logoItem];
    logoItem.block = ^(id  _Nonnull cmd) {
        [that excuteShareCmd:cmd];
    };
    
    [logoItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(122));
        make.top.equalTo(that.container.mas_top);
    }];
    
    
    JUDIAN_READ_NovelShareCancelItem* cancelItem = [[JUDIAN_READ_NovelShareCancelItem alloc]init];
    _cancelItem = cancelItem;
    [_container addSubview:cancelItem];
    
    [cancelItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(60));
        make.bottom.equalTo(that.container.mas_bottom);
    }];
    
    [cancelItem addTarget:self action:@selector(removeSelf) forControlEvents:(UIControlEventTouchUpInside)];
    
    [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(that.container.mas_top);
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(20));
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBarView.mas_top).offset(17);
        make.left.equalTo(that.container.mas_left).offset(34);
        make.height.equalTo(@(14));
        make.right.equalTo(that.container.mas_right);
    }];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    //[_topBarView clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [_topBarView clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight frame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    if (_topBarView) {
        return;
    }
    [_container clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
}



- (void)addToKeyWindow:(UIView*)container {
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [container addSubview:self];
}



- (void)excuteShareCmd:(id  _Nonnull) cmd {
    
    if (!_fromView) {
        _fromView = @"";
    }

    NSString* bookId = self.bookId;
    if (self.bookId.length <= 0) {
        bookId = @"";
    }
    
    NSDictionary* dictionary =  @{
                                  @"cmd": cmd,
                                  @"value" : bookId,
                                  @"fromView" : _fromView
                                  };
    
    NSNotification* notification = [[NSNotification alloc]initWithName:@"" object:dictionary userInfo:nil];
    [JUDIAN_READ_Reader_FictionCommandHandler shareNovelToOther:notification];
    [self removeSelf];

    
}



- (void)showView {
    
    NSInteger height = CONTAINER_HEIGHT;
    if (_isShareItem) {
        height = SHARE_VIEW_HEIGHT;
    }
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, -height);
    }completion:^(BOOL finished) {
        
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeSelf];
}


- (void)removeSelf {
    WeakSelf(that);
    
    NSInteger height = CONTAINER_HEIGHT;
    if (_isShareItem) {
        height = SHARE_VIEW_HEIGHT;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, height);
    }completion:^(BOOL finished) {
        [that  removeFromSuperview];
    }];
}




- (void)setViewStyle {
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _emptyView.backgroundColor = RGB(0x33, 0x33, 0x33);
        _container.backgroundColor = RGB(0x33, 0x33, 0x33);
        _topBarView.backgroundColor = RGB(0x33, 0x33, 0x33);
        
        _titleLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
    else {
        _emptyView.backgroundColor = [UIColor whiteColor];
        _container.backgroundColor = [UIColor whiteColor];
        _topBarView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    }
    
    [_cancelItem setViewStyle];
    [_settingView setViewStyle];
    [_logoItem setViewStyle];
}









@end
