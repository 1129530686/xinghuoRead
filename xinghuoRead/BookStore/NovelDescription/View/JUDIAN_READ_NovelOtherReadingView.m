//
//  JUDIAN_READ_NovelOtherReadingView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelOtherReadingView.h"

@interface JUDIAN_READ_NovelOtherReadingView ()
@property(nonatomic, weak)UILabel* titleLabel;
@end


@implementation JUDIAN_READ_NovelOtherReadingView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
   
    UILabel* titleLabel = [[UILabel alloc]init];
    _titleLabel = titleLabel;
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    titleLabel.text = @"";
    [self.contentView addSubview:titleLabel];
    
    WeakSelf(that);
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(200));
        make.height.equalTo(@(16));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
}

- (void)updateCell:(NSString*)title {
    _titleLabel.text = title;
}

@end
