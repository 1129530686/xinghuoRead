//
//  JUDIAN_READ_TextStyleSettingPanel.m
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_TextStyleSettingPanel.h"
#import "JUDIAN_READ_LineSpaceSettingItem.h"
#import "JUDIAN_READ_BackgroundSettingItem.h"
#import "JUDIAN_READ_FontSizeSettingItem.h"
#import "JUDIAN_READ_LightSettingItem.h"
#import "JUDIAN_READ_TextStyleManager.h"

//237+55
#define CONTAINER_HEIGHT 237


@interface JUDIAN_READ_TextStyleSettingPanel ()
@property(nonatomic, strong)UIControl* container;

@property(nonatomic, strong)JUDIAN_READ_LineSpaceSettingItem* lineSpaceItem;
@property(nonatomic, strong)JUDIAN_READ_BackgroundSettingItem* bgItem;
@property(nonatomic, strong)JUDIAN_READ_FontSizeSettingItem* fontItem;
@property(nonatomic, strong)JUDIAN_READ_LightSettingItem* lightItem;
@property(nonatomic, strong)JUDIAN_READ_TurnPageStyleSettingItem* pageStyleSettingItem;
@property(nonatomic, strong)UIControl* emptyView;
@end




@implementation JUDIAN_READ_TextStyleSettingPanel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_container clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
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
    [self addSubview:_container];

    JUDIAN_READ_TurnPageStyleSettingItem* pageStyleSettingItem = [[JUDIAN_READ_TurnPageStyleSettingItem alloc] init];
    [_container addSubview:pageStyleSettingItem];
    _pageStyleSettingItem = pageStyleSettingItem;
    pageStyleSettingItem.hidden = NO;

    JUDIAN_READ_LineSpaceSettingItem* lineSpaceItem = [[JUDIAN_READ_LineSpaceSettingItem alloc]init];
    [_container addSubview:lineSpaceItem];
    _lineSpaceItem = lineSpaceItem;

    JUDIAN_READ_BackgroundSettingItem* bgItem = [[JUDIAN_READ_BackgroundSettingItem alloc]init];
    [_container addSubview:bgItem];
    _bgItem = bgItem;
    
    JUDIAN_READ_FontSizeSettingItem* fontItem = [[JUDIAN_READ_FontSizeSettingItem alloc]init];
    [_container addSubview:fontItem];
    _fontItem = fontItem;
    
    JUDIAN_READ_LightSettingItem* lightItem = [[JUDIAN_READ_LightSettingItem alloc]init];
    [_container addSubview:lightItem];
    _lightItem = lightItem;
    
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
    
#if 1
    [pageStyleSettingItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@55);
        make.bottom.equalTo(that.container.mas_bottom);
    }];
    

    [lineSpaceItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@55);
        make.bottom.equalTo(pageStyleSettingItem.mas_top);
    }];
#else
    [lineSpaceItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@55);
        make.bottom.equalTo(that.container.mas_bottom);
    }];
#endif
    
    [bgItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@55);
        make.bottom.equalTo(lineSpaceItem.mas_top);
    }];
    
    
    
    [fontItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@55);
        make.bottom.equalTo(bgItem.mas_top);
    }];
    
    
    [lightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@72);
        make.bottom.equalTo(fontItem.mas_top);
    }];
    
    
    
}



- (void)adjustButtonStyle:(JUDIAN_READ_TextStyleModel*)model {
    
    [_lineSpaceItem setButtonStyle:model];
    [_bgItem setButtonStyle:model];
    [_lightItem setButtonStyle:model];
    [_fontItem setButtonStyle:model];
    [_pageStyleSettingItem setButtonStyle:model];
}



- (void)setViewStyle {

    UIColor* bgColor = nil;
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        bgColor = RGB(0x33, 0x33, 0x33);
    }
    else {
        bgColor = [UIColor whiteColor];
    }

    _pageStyleSettingItem.backgroundColor = bgColor;
    _lineSpaceItem.backgroundColor = bgColor;
    _bgItem.backgroundColor = bgColor;
    _lightItem.backgroundColor = bgColor;
    _fontItem.backgroundColor = bgColor;
    _emptyView.backgroundColor = bgColor;
    
    
    [_pageStyleSettingItem setTitleStyle];
    [_pageStyleSettingItem setButtonStyle];
    
    [_lineSpaceItem setTitleStyle];
    [_lineSpaceItem setButtonStyle];
    
    [_bgItem setTitleStyle];
    [_bgItem setButtonStyle];
    
    [_lightItem setTitleStyle];
    [_lightItem setButtonStyle];
    
    [_fontItem setTitleStyle];
    [_fontItem setDefaultStyle];
    

}





- (void)showView {

    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, -CONTAINER_HEIGHT);
    }completion:^(BOOL finished) {

    }];
}



- (void)addToKeyWindow:(UIView*)container {
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [container addSubview:self];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}


- (void)hideView {
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, CONTAINER_HEIGHT);
    }completion:^(BOOL finished) {
        [that removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                             @"cmd":@(kArchiveSettingCmd),
                                                                                             @"value":@(0)
                                                                                             }];
    }];
}


@end
