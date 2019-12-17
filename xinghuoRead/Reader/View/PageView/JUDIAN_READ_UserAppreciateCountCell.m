//
//  JUDIAN_READ_UserAppreciateCountCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppreciateCountCell.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_UserAppreciateCountCell ()
@property(nonatomic, strong)UILabel* appreciateCountLabel;
@end



@implementation JUDIAN_READ_UserAppreciateCountCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    _appreciateCountLabel = [[UILabel alloc]init];
    _appreciateCountLabel.font = [UIFont systemFontOfSize:12];
    _appreciateCountLabel.textColor = RGB(0x99, 0x99, 0x99);
    _appreciateCountLabel.text = @"";
    [self.contentView addSubview:_appreciateCountLabel];
    
    
    UIView* leftLineView = [[UIView alloc]init];
    leftLineView.backgroundColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:leftLineView];
    
    UIView* rightLineView = [[UIView alloc]init];
    rightLineView.backgroundColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:rightLineView];

    
    WeakSelf(that);
    [_appreciateCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.height.equalTo(@(12));
        make.width.equalTo(@(0));
        make.bottom.equalTo(that.contentView.mas_bottom);
        //make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(20));
        make.height.equalTo(@(0.5));
        make.centerY.equalTo(that.appreciateCountLabel.mas_centerY);
        make.right.equalTo(that.appreciateCountLabel.mas_left).offset(-7);
    }];
    
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(20));
        make.height.equalTo(@(0.5));
        make.centerY.equalTo(that.appreciateCountLabel.mas_centerY);
        make.left.equalTo(that.appreciateCountLabel.mas_right).offset(7);
    }];
    
    
}



- (void)setAppreciateCount:(NSString*)count {
    _appreciateCountLabel.text = [NSString stringWithFormat:@"已有%@人打赏", count];
    CGFloat width = [_appreciateCountLabel getTextWidth:12];
    [_appreciateCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.contentView.backgroundColor = [style getBgColor];
    
    _appreciateCountLabel.textColor = RGB(0x99, 0x99, 0x99);
    if ([style isNightMode]) {
        _appreciateCountLabel.textColor = RGB(0x66, 0x66, 0x66);
    }
    
}


- (void)setDefaultStyle {
    self.contentView.backgroundColor = [UIColor whiteColor];
    _appreciateCountLabel.textColor = RGB(0x99, 0x99, 0x99);
}




@end
