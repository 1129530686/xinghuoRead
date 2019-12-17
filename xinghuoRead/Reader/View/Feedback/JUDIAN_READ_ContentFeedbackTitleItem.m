//
//  JUDIAN_READ_ContentFeedbackTitleItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentFeedbackTitleItem.h"

@implementation JUDIAN_READ_ContentFeedbackTitleItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    return self;
}


- (void)addViews {
    
    NSInteger fontSize = 14;
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    titleLabel.text = @"";
    //titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    
    [self addSubview:titleLabel];
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(15);
        make.right.equalTo(that.mas_right).offset(-15);
        make.height.equalTo(@(fontSize));
        make.centerY.equalTo(that.mas_centerY);
    }];
}


@end
