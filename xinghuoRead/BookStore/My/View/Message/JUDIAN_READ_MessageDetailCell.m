//
//  JUDIAN_READ_MessageDetailCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MessageDetailCell.h"

@implementation JUDIAN_READ_MessageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backView doBorderWidth:0 color:nil cornerRadius:8];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.contentView.backgroundColor = kBackColor;
    if (indexPath.section == 0) {
        self.sepView.hidden = YES;
        self.detailLab.hidden = YES;
        self.nextImg.hidden = YES;
        self.heightDetail.constant = 0;
    }else{
        self.sepView.hidden = NO;
        self.detailLab.hidden = NO;
        self.nextImg.hidden = NO;
        self.heightDetail.constant = 30;
    }
}

@end
