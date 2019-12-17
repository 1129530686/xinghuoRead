//
//  ZBCycleView.m
//  CycleVerticalView
//
//  Created by 周博 on 2019/1/8.
//  Copyright © 2019 EL. All rights reserved.
//

#import "JUDIAN_READ_CycleView.h"
@interface JUDIAN_READ_CycleView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *leftImg;
@property (strong, nonatomic) UIImageView *rightImg;


@end

@implementation JUDIAN_READ_CycleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = kColor51;
        [self addSubview:_titleLabel];
        
        _leftImg = [[UIImageView alloc] init];
        _leftImg.contentMode = UIViewContentModeLeft;
        [self addSubview:_leftImg];

        _rightImg = [[UIImageView alloc] init];
        _rightImg.contentMode =  UIViewContentModeCenter;
        [self addSubview:_rightImg];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(27, 0, self.frame.size.width-27-10, self.frame.size.height);
    _leftImg.frame = CGRectMake(0, 0, 27, self.frame.size.height);
    _rightImg.frame = CGRectMake(self.frame.size.width-7, 0, 7, self.frame.size.height);
   
    
}

- (void)setDicData:(NSDictionary *)dicData{
    _dicData = dicData;
    _titleLabel.text = dicData[@"title"];
    _leftImg.image = [UIImage imageNamed:dicData[@"leftImg"]];
    _rightImg.image = [UIImage imageNamed:dicData[@"rightImg"]];
}

@end
