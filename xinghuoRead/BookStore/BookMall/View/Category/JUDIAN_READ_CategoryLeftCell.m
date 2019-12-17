//
//  JUDIAN_READ_CategoryLeftCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CategoryLeftCell.h"

@implementation JUDIAN_READ_CategoryLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setLeftDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = model[indexPath.row];
    self.leftLab.text = dic[@"name"];
    if ([dic[@"color"] isEqualToString:@"red"]) {
        self.leftLab.textColor = kColorRed;
        self.iconView.hidden = NO;
        self.backgroundColor = kColorWhite;
    }else{
        self.leftLab.textColor = kColor51;
        self.iconView.hidden = YES;
        self.backgroundColor = kBackColor;
    }
}

@end
