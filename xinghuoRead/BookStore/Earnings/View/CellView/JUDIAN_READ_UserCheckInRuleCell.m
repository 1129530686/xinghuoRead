//
//  JUDIAN_READ_UserCheckInRuleCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserCheckInRuleCell.h"
#import "UILabel+JUDIAN_READ_Label.h"



@interface JUDIAN_READ_UserCheckInRuleCell ()
@property(nonatomic, weak)UILabel* ruleLabel;
@end


@implementation JUDIAN_READ_UserCheckInRuleCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UILabel* ruleLabel = [[UILabel alloc] init];
    _ruleLabel = ruleLabel;
    ruleLabel.numberOfLines = 0;
    ruleLabel.text = @"签到规则:\n\n1.签到之前需先登录；\n\n2.签到采用连续签到，如果其中一天没签到，则从第二天凌晨重新开始；签到满七天则重新开始累积；\n\n3.签到获取的元宝，可以在福利商城兑换商品；\n\n4.如遇网络延迟等状况，会导致完成任务后延迟发放，请耐心等待；\n\n5.最终解释权归追书宝官方所有。";
    ruleLabel.font = [UIFont systemFontOfSize:12];
    ruleLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:ruleLabel];
    
    WeakSelf(that);
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.contentView.mas_top).offset(33);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-33);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
}




- (NSInteger)getCellHeight {
    NSInteger width = SCREEN_WIDTH - 2 * 14;
    CGFloat height = [_ruleLabel getTextHeight:width];
    height = ceil(height) + 2 * 33;
    return height;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
