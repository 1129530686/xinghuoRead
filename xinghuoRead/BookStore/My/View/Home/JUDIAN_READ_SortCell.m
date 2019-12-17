//
//  JUDIAN_READ_SortCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SortCell.h"
#import "JUDIAN_READ_ReadRankModel.h"

@implementation JUDIAN_READ_SortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:20];
    [self.coinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setSortDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ReadRankModel *info = model[indexPath.row];
    [self.sortBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.sortBtn setTitle:info.rankYesterday forState:UIControlStateNormal];
    [self.coinBtn setImage:[UIImage imageNamed:@"welfare_wing"] forState:UIControlStateNormal];
    self.coinBtn.hidden = YES;
    
    if (indexPath.row < 3) {
        self.coinBtn.hidden = NO;
        self.widthConstant.constant = 55;
    }else{
        self.widthConstant.constant = 0;
    }
    if (indexPath.row == 0) {
        [self.sortBtn setImage:[UIImage imageNamed:@"time_icon_1"] forState:UIControlStateNormal];
        [self.sortBtn setTitle:@"" forState:UIControlStateNormal];
        [self.coinBtn setTitle:[NSString stringWithFormat:@"+%@",info.rewardGolds] forState:UIControlStateNormal];
    }
    if (indexPath.row == 1) {
        [self.sortBtn setImage:[UIImage imageNamed:@"time_icon_2"] forState:UIControlStateNormal];
        [self.sortBtn setTitle:@"" forState:UIControlStateNormal];
        [self.coinBtn setTitle:[NSString stringWithFormat:@"+%@",info.rewardGolds] forState:UIControlStateNormal];


    }
    if (indexPath.row == 2) {
        [self.sortBtn setImage:[UIImage imageNamed:@"time_icon_3"] forState:UIControlStateNormal];
        [self.sortBtn setTitle:@"" forState:UIControlStateNormal];
        [self.coinBtn setTitle:[NSString stringWithFormat:@"+%@",info.rewardGolds] forState:UIControlStateNormal];

    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.headImg] placeholderImage:[UIImage imageNamed:@"head_big"]];
    self.nameLab.text = info.nickname;
    if (!info.readingDuration.length) {
        return;
    }
    self.timeLab.attributedText = [self changeTimeLabUI:info.readingDuration];
    
}


- (NSMutableAttributedString *)changeTimeLabUI:(NSString *)text{
    
    NSCharacterSet *nonDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    NSArray *arr = [text componentsSeparatedByCharactersInSet:nonDigitCharacterSet];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text];
    for (NSString *str in arr) {
        NSRange rang = [text rangeOfString:str];
        [att addAttributes:@{NSFontAttributeName : kFontSize12} range:rang];
    }

    return att;
}




@end
