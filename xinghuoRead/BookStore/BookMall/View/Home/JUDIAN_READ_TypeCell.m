//
//  JUDIAN_READ_TypeCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_TypeCell.h"
#import "JUDIAN_READ_CategoryModel.h"

@implementation JUDIAN_READ_TypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.typeLab doBorderWidth:0 color:nil cornerRadius:5];
    self.typeLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:5];
}


- (void)setPlatFormDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = model[indexPath.row];
    self.typeLab.backgroundColor = kBackColor;
    [self.typeLab doBorderWidth:0 color:nil cornerRadius:0];
    [self.typeLab setText:dic[@"company"] titleFontSize:14 titleColot:kColor51];
}


- (void)setTypeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    if ([model count] > indexPath.row) {
        JUDIAN_READ_CategoryModel *info  = model[indexPath.row];
        self.typeLab.text = info.name;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_h_image"]];
    }else{
        self.typeLab.text = @"更多分类";
        self.iconView.image = [UIImage imageNamed:@"Bookcity_classification"];
    }
}

@end
