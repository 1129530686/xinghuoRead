//
//  JUDIAN_READ_CoinCell.m
//  universalRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CoinCell.h"
#import "JUDIAN_READ_GoldCoinModel.h"
#import "JUDIAN_READ_GoldCoinListModel.h"

@implementation JUDIAN_READ_CoinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoinDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_GoldCoinListModel *infolist = model[indexPath.section];
    JUDIAN_READ_GoldCoinModel *info = infolist.list[indexPath.row];
    self.leadTopLab.text = info.title;
    self.trailTopLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    if ([info.incomeAmount containsString:@"-"]) {
        self.trailTopLab.textColor = kColor51;
        self.trailTopLab.text = [NSString stringWithFormat:@"%@",info.incomeAmount];
    }else{
        self.trailTopLab.text = [NSString stringWithFormat:@"+%@",info.incomeAmount];
        self.trailTopLab.textColor = kThemeColor;
    }
    self.trailBotLab.text = info.createDate;
}

- (void)setIncomeDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath{
    
}
@end
