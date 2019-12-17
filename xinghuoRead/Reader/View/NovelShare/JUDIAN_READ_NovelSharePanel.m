//
//  JUDIAN_READ_NovelShareView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelSharePanel.h"
#import "JUDIAN_READ_NovelShareTipItem.h"
#import "JUDIAN_READ_NovelShareLogoItem.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_NovelShareCancelItem.h"


#define CONTAINER_HEIGHT (250 + 60)


@interface JUDIAN_READ_NovelSharePanel ()
@property(nonatomic, strong)UIControl* container;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, weak)UIControl* emptyView;
@end

@implementation JUDIAN_READ_NovelSharePanel

- (instancetype)initWithId:(NSString*)bookId {
    self = [super init];
    if (self) {
        _bookId = bookId;
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIControl* emptyView = [[UIControl alloc]init];
    _emptyView = emptyView;
    emptyView.backgroundColor = [UIColor whiteColor];
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
    
    JUDIAN_READ_NovelShareTipItem* tipItem = [[JUDIAN_READ_NovelShareTipItem alloc]init];
    [_container addSubview:tipItem];
    
    
    [tipItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(33));
        make.top.equalTo(that.container.mas_top);
    }];
    
    
    JUDIAN_READ_NovelShareLogoItem* logoItemRow1 = [[JUDIAN_READ_NovelShareLogoItem alloc]initWithIndex:0];
    [logoItemRow1 setViewStyle];
    [_container addSubview:logoItemRow1];
    logoItemRow1.block = ^(id  _Nonnull cmd) {
        [that excuteShareCmd:cmd];
    };
    
    [logoItemRow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(75));
        make.top.equalTo(tipItem.mas_bottom).offset(27);
    }];
    
    
    JUDIAN_READ_NovelShareLogoItem* logoItemRow2 = [[JUDIAN_READ_NovelShareLogoItem alloc]initWithIndex:1];
    [logoItemRow2 setViewStyle];
    [_container addSubview:logoItemRow2];
    
    logoItemRow2.block = ^(id  _Nonnull cmd) {
        [that excuteShareCmd:cmd];
    };
    
    
    
    [logoItemRow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(75));
        make.top.equalTo(logoItemRow1.mas_bottom).offset(20);
    }];
    
    
    
    JUDIAN_READ_NovelShareCancelItem* cancelItem = [[JUDIAN_READ_NovelShareCancelItem alloc]init];
    [_container addSubview:cancelItem];
    
    [cancelItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(60));
        make.top.equalTo(logoItemRow2.mas_bottom).offset(20);
    }];
    
    [cancelItem addTarget:self action:@selector(removeSelf) forControlEvents:(UIControlEventTouchUpInside)];
    
    [tipItem setViewStyle];
    [cancelItem setViewStyle];
    [self setViewStyle];
}


- (void)setViewStyle {
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _container.backgroundColor = RGB(0x33, 0x33, 0x33);
    }
    else {
        _container.backgroundColor = [UIColor whiteColor];
    }
    
    _emptyView.backgroundColor = _container.backgroundColor;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_container clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
}



- (void)addToKeyWindow:(UIView*)container {
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [container addSubview:self];
}



- (void)excuteShareCmd:(id  _Nonnull) cmd {
    
    NSString* bookId = self.bookId;
    if (self.bookId.length <= 0) {
        bookId = @"";
    }
    
    NSDictionary* dictionary =  @{
                                  @"cmd":cmd,
                                  @"value":bookId
                                  };
    
    NSNotification* notification = [[NSNotification alloc]initWithName:@"" object:dictionary userInfo:nil];
    [JUDIAN_READ_Reader_FictionCommandHandler shareNovelToOther:notification];
    [self removeSelf];
    
}



- (void)showView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, -CONTAINER_HEIGHT);
    }completion:^(BOOL finished) {
        
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeSelf];
}


- (void)removeSelf {
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, CONTAINER_HEIGHT);
    }completion:^(BOOL finished) {
        [that  removeFromSuperview];
    }];
}



@end
