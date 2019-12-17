//
//  JUDIAN_READ_BuyRecordCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/30.
//  Copyright © 2019年 judian. All rights reserved.
//
#import "JUDIAN_READ_BuyRecordModel.h"
#import "JUDIAN_READ_BuyRecordCell.h"

@implementation JUDIAN_READ_BuyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moneyLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_BuyRecordModel *info = model[indexPath.row];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",info.vip_type_price]];
    [att addAttribute:NSFontAttributeName value:kFontSize12 range:NSMakeRange(0, 1)];
    self.moneyLab.attributedText = att;
    self.nameLab.text = info.vip_type_name;
    self.timeLab.text = info.create_time;
    self.typeLab.text = info.pay_title;
//    self.typeLab.text = @"appPay";

}

@end
