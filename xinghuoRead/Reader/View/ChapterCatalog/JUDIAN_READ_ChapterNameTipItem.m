//
//  JUDIAN_READ_ChapterNameTipItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterNameTipItem.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_ChapterNameTipItem ()
@property(nonatomic, weak)UILabel* titleLabel;
@end

@implementation JUDIAN_READ_ChapterNameTipItem

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}


- (void)addViews {
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"目录";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];

    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(50));
        make.height.equalTo(@(17));
        //make.bottom.equalTo(that.mas_bottom);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
}



- (void)setViewStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
    }
    else {
        _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    }

}



@end
