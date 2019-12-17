//
//  JUDIAN_READ_UserShareCodeMenu.m
//  universalRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserShareCodeMenu.h"
#import "JUDIAN_READ_InviteFriendBottomView.h"


#define ITEM_HEIGHT 47

#define BUTTON_CANCEL_TAG 102


@interface JUDIAN_READ_UserShareCodeMenu ()
@property(nonatomic, weak)UIView* container;
@end

@implementation JUDIAN_READ_UserShareCodeMenu

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
    UIView* container = [[UIView alloc] init];
    _container = container;
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    
    
    UIButton* cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelButton.tag = BUTTON_CANCEL_TAG;
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [container addSubview:cancelButton];
    
    
    UIView* seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [container addSubview:seperatorView];
    
    
    JUDIAN_READ_InviteFriendBottomView* barView = [[JUDIAN_READ_InviteFriendBottomView alloc] init];
    _barView = barView;
    WeakSelf(that);
    barView.block = ^(id  _Nullable args) {
        if (that.block) {
            that.block(args);
            [that hideView];
        }
    };
    
    [container addSubview:barView];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:titleLabel];
    

    NSInteger height = [self getContainerHeight];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(height));
        make.bottom.equalTo(that.mas_bottom).offset(height);
    }];
    
    NSInteger bottomOffset = [self getBottomOfffset];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(ITEM_HEIGHT));
        make.bottom.equalTo(container.mas_bottom).offset(-bottomOffset);
    }];
    
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(7));
        make.bottom.equalTo(cancelButton.mas_top);
    }];
    
    
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.bottom.equalTo(seperatorView.mas_top);
        make.height.equalTo(@(67));
    }];
    

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(10);
        make.height.equalTo(@(17));
        make.right.equalTo(that.mas_right).offset(-10);
        make.top.equalTo(container.mas_top).offset(20);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_container clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
}


- (NSInteger)getContainerHeight {
    
    NSInteger height = ITEM_HEIGHT + 7 + 67 + 34 + 20;
    return height + [self getBottomOfffset];
}


- (NSInteger)getBottomOfffset {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    return bottomOffset;
    
    
}



- (void)showView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, -[that getContainerHeight]);
    }completion:^(BOOL finished) {
        
    }];
}




- (void)hideView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, [that getContainerHeight]);
    }completion:^(BOOL finished) {
        [that removeFromSuperview];
    }];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}




- (void)handleTouchEvent:(UIButton*)sender {
    [self hideView];
    
    
    if (sender.tag == BUTTON_CANCEL_TAG) {
        return;
    }
    
}


@end
