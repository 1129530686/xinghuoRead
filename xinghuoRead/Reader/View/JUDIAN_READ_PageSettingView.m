//
//  JUDIAN_READ_PageNavigationView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/24.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PageSettingView.h"
#import "JUDIAN_READ_PageNavigationView.h"
#import "JUDIAN_READ_PageTabBarView.h"
#import "JUDIAN_READ_MoreMenu.h"


#define FAVOURITE_BUTTON_WIDTH 88
#define FAVOURITE_BUTTON_HEIGHT 42

@interface JUDIAN_READ_PageSettingView ()

@property(nonatomic, strong)JUDIAN_READ_PageTabBarView* bottomBarView;
@property(nonatomic, strong)JUDIAN_READ_MoreMenu* moreMenu;
@property(nonatomic, strong)JUDIAN_READ_PageNavigationView* topBarView;
@property(nonatomic, assign)BOOL isShow;

@end


@implementation JUDIAN_READ_PageSettingView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
        self.backgroundColor = [UIColor clearColor];
        _isShow = FALSE;
        [self addViews];
        [self addFavoritesButton];
    }
    return self;
}


- (void)addViews {
    

    _topBarView = [[JUDIAN_READ_PageNavigationView alloc]init];
    _topBarView.frame = CGRectMake(0, -[self getNavigationBarHeight], WIDTH_SCREEN, [self getNavigationBarHeight]);
    [self addSubview:_topBarView];
    
    _bottomBarView = [[JUDIAN_READ_PageTabBarView alloc]init];
    
    _bottomBarView.frame = CGRectMake(0, HEIGHT_SCREEN, WIDTH_SCREEN, [self getBottomBarHeight]);
    [self addSubview:_bottomBarView];
    
    _moreMenu = [[JUDIAN_READ_MoreMenu alloc]init];
    _moreMenu.frame = CGRectMake(SCREEN_WIDTH - kReaderMoreMenuWidth - 4, -[self getNavigationBarHeight], kReaderMoreMenuWidth, kReaderMoreMenuHeight);
    [self addSubview:_moreMenu];
    
    
    _topBarView.hidden = YES;
    _bottomBarView.hidden = YES;
    _moreMenu.hidden = YES;

}

- (void)addFavoritesButton {
    
    UIButton* favoritesButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [favoritesButton addTarget:self action:@selector(handleFavoritesTouch) forControlEvents:(UIControlEventTouchUpInside)];
    _favoritesButton = favoritesButton;
    [favoritesButton setBackgroundImage:[UIImage imageNamed:@"reader_book_favourites"] forState:(UIControlStateNormal)];
    [self addSubview:favoritesButton];
    
    NSInteger top = [self getNavigationHeight];
    top += 40;
    
    NSInteger width = FAVOURITE_BUTTON_WIDTH;
    NSInteger height = FAVOURITE_BUTTON_HEIGHT;
    
    WeakSelf(that);
    [favoritesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(@(top));
        make.right.equalTo(that.mas_right).offset(width);
    }];
    
}


- (void)updateBookInfo:(NSString*)bookName chapterName:(NSString*)chapterName {
    _topBarView.bookName = bookName;
    _topBarView.chapterName = chapterName;
}

- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}


- (void)showBarView {
    
    _topBarView.hidden = NO;
    _bottomBarView.hidden = NO;
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.topBarView.transform = CGAffineTransformMakeTranslation(0, [that getNavigationBarHeight]);
        that.bottomBarView.transform = CGAffineTransformMakeTranslation(0, -[that getBottomBarHeight]);
            NSInteger width = FAVOURITE_BUTTON_WIDTH;
            that.favoritesButton.transform = CGAffineTransformMakeTranslation(-width, 0);
    }];
    
}


- (void)setTitleText:(NSString*)text {
    _topBarView.titleLabel.text = text;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}



- (void) hideView {
    
    _isShow = FALSE;
    WeakSelf(that);
    
    [UIView animateWithDuration:0.3 animations:^{
        that.topBarView.transform = CGAffineTransformMakeTranslation(0, -[that getNavigationBarHeight]);
        that.bottomBarView.transform = CGAffineTransformMakeTranslation(0, [that getBottomBarHeight]);
        that.moreMenu.transform = CGAffineTransformMakeTranslation(0, -[that getNavigationBarHeight]);
        
        NSInteger width = FAVOURITE_BUTTON_WIDTH;
        that.favoritesButton.transform = CGAffineTransformMakeTranslation(width, 0);
        
    }completion:^(BOOL finished) {
        that.topBarView.hidden = YES;
        that.bottomBarView.hidden = YES;
        that.moreMenu.hidden = YES;
        
        [that removeFromSuperview];
        
        if(that.block != nil) {
            that.block(@"");
        }
    }];
    
}



- (void)removeBarView {
    [self removeFromSuperview];
}


- (void)addToKeyWindow:(UIView*)container {
    _isShow = TRUE;
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [container addSubview:self];
}


- (BOOL)isShow {
    return _isShow;
}



- (void)showMenu {
    _moreMenu.hidden = NO;
    [_moreMenu setViewStyle];
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.moreMenu.transform = CGAffineTransformMakeTranslation(0, kReaderMoreMenuHeight);
    }];
    
}



- (void)setViewStyle {
    [_topBarView setViewStyle];
    [_bottomBarView setViewStyle];
}



- (CGFloat)getNavigationBarHeight {
    
    if(iPhoneX) {
        return kReaderNavigationBarHeight + 44;
    }
    else {
        return kReaderNavigationBarHeight + 20;
    }
    
}




- (CGFloat)getBottomBarHeight {
    NSInteger bottomOffset = 0;
    if(iPhoneX) {
        bottomOffset = 34;
    }
    
    return kReaderBottomBarHeight + bottomOffset;
}

- (void)handleFavoritesTouch {

    if(self.block != nil) {
        self.block(@"collect");
    }

}

@end
