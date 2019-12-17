//
//  JUDIAN_READ_UserDayEarningsTipCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserDayEarningsTipCell.h"

@implementation JUDIAN_READ_UserDayEarningsTipCell

- (void)awakeFromNib {
    [super awakeFromNib];

}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addTipView];
        //[self addBottomLine];
    }
    
    return self;
}




- (void)addTipView {
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:17];
    tipLabel.textColor = RGB(0x33, 0x33, 0x33);
    tipLabel.text = @"日常元宝任务";
    [self.contentView addSubview:tipLabel];
    
    WeakSelf(that);
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-13);
        make.height.equalTo(@(17));
    }];
}




- (void)addBottomLine {
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    WeakSelf(that);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(0);
        make.right.equalTo(that.contentView.mas_right).offset(0);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
