//
//  JUDIAN_READ_NovelShareCancelItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelShareCancelItem.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_NovelShareCancelItem ()
@property(nonatomic, weak)UIView* emptyView;
@property(nonatomic, weak)UILabel* cancelLabel;
@end


@implementation JUDIAN_READ_NovelShareCancelItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UIView* emptyView = [[UIView alloc]init];
    _emptyView = emptyView;
    emptyView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [self addSubview:emptyView];
    
    
    UILabel* cancelLabel = [[UILabel alloc]init];
    _cancelLabel = cancelLabel;
    cancelLabel.backgroundColor = [UIColor whiteColor];
    cancelLabel.text = @"取消";
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    cancelLabel.textColor = RGB(0x33, 0x33, 0x33);
    cancelLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:cancelLabel];
    
    WeakSelf(that);
    [cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(50));
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(10));
        make.bottom.equalTo(cancelLabel.mas_top);
    }];
    
}


- (void)setViewStyle {
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _emptyView.backgroundColor = RGB(0x44, 0x44, 0x44);
        _cancelLabel.backgroundColor = RGB(0x33, 0x33, 0x33);
        _cancelLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
    else {
        _emptyView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
        _cancelLabel.backgroundColor = [UIColor whiteColor];
        _cancelLabel.textColor = RGB(0x33, 0x33, 0x33);
    }
}



@end
