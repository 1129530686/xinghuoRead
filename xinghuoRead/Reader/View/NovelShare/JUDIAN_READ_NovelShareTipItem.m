//
//  JUDIAN_READ_NovelShareTipItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelShareTipItem.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_NovelShareTipItem ()
@property(nonatomic, weak)UILabel* titleLabel;
@end


@implementation JUDIAN_READ_NovelShareTipItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}


- (void)addViews {
    UILabel* titleLabel = [[UILabel alloc]init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(27);
        make.height.equalTo(@(17));
        make.right.equalTo(that.mas_right).offset(-10);
        make.bottom.equalTo(that.mas_bottom);
    }];
    
}


- (void)setViewStyle {
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
    else {
        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    }
    
}


@end
