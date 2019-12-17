//
//  JUDIAN_READ_VipColCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_VipColCell.h"
#import "JUDIAN_READ_VipModel.h"

@interface JUDIAN_READ_VipColCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopConstant;


@end

@implementation JUDIAN_READ_VipColCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= [model count]) {
        return;
    }
    JUDIAN_READ_VipModel *info = model[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"¥%@%@",info.price,info.title];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    UIFont *font = [UIFont systemFontOfSize:kAutoFontSize24_26];
    NSRange rang = [str rangeOfString:info.price];
    [att addAttributes:@{NSFontAttributeName:font} range:rang];
    self.moneyLab.attributedText = att;
    if (info.isSelected) {
        self.backImage.image = [UIImage imageNamed:@"members_wireframe_sel"];
    }else{
        self.backImage.image = [UIImage imageNamed:@"members_wireframe"];
    }
    
    self.nameLab.text = info.title;
    
    
}


- (void)setRechageDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= [model count]) {
        return;
    }
    self.topConstant.constant = 4;
    self.nameTopConstant.constant = 0;
    JUDIAN_READ_VipModel *info = model[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@元",info.price];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    UIFont *font = [UIFont systemFontOfSize:kAutoFontSize24_26];
    NSRange rang = [str rangeOfString:info.price];
    [att addAttributes:@{NSFontAttributeName:font} range:rang];
    self.moneyLab.attributedText = att;
    self.nameLab.text = info.title;
    
    UIColor *color = info.isSelected ? kThemeColor : kColor51;
    UIColor *color1 = info.isSelected ? kThemeColor : kColor153;
    self.moneyLab.textColor = color;
    self.nameLab.textColor = color1;
    self.backImage.image = nil;
    [self.backImage doBorderWidth:0.5 color:KSepColor cornerRadius:3];
    self.backImage.backgroundColor = info.isSelected ? RGBA(255, 241, 245, 1) : kColorWhite;
    
}


@end
