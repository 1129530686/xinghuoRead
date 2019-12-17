//
//  JDImageLabelColCell.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import "JUDIAN_READ_ImageLabelColCell.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_CategoryModel.h"

@implementation JUDIAN_READ_ImageLabelColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.freeLabel.hidden = YES;
    [self.iconView doBorderWidth:0 color:nil cornerRadius:3];
    // Initialization code
}

- (void)setRightDataWithModel:(id)model icons:(NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = model;
    self.titleLab.text = arr[indexPath.row];
    self.heightConstant.constant = 40;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = kColor100;
    self.iconView.image = [UIImage imageNamed:icons[indexPath.row]];
    self.iconView.contentMode = UIViewContentModeCenter;
}


- (void)setTypeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.heightConstant.constant = 35;
    NSDictionary *dic = model[indexPath.row];
    [self.titleLab setText:dic[@"name"] titleFontSize:11 titleColot:kColor100];
    self.iconView.image = [UIImage imageNamed:dic[@"cover"]];
    self.iconView.contentMode = UIViewContentModeCenter;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}

- (void)setCategoryRightDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_CategoryModel *info = model[indexPath.row];
    self.heightConstant.constant = (SCREEN_WIDTH-80-32)/4.0;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_h_image"]];
    [self.titleLab setText:info.name titleFontSize:16 titleColot:kColor51];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}


- (void)setRewardDataWithModel:(id)model icons:(NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = model;
    self.titleLab.text = arr[indexPath.row];
    self.heightConstant.constant = 50;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = kColor100;
    self.iconView.image = [UIImage imageNamed:icons[indexPath.row]];
    self.iconView.contentMode = UIViewContentModeCenter;
    
}

- (void)setShelfDataWithModel:(id)model icons:(nullable NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath{
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.heightConstant.constant = 50;
    self.titleLab.text = @"元宝送大礼";
    self.iconView.backgroundColor = KSepColor;

}


- (void)setBookHomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    
    NSArray* array = model;
    NSInteger row = indexPath.row;
    if (row >= array.count) {
        return;
    }
    
    self.heightConstant.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
    self.titleLab.font = kFontSize14;
    JUDIAN_READ_ReadListModel *info = model[row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.titleLab.text = info.bookname;
}

- (void)setBookHomeLikeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    
    NSArray* array = model;
    NSInteger row = indexPath.row;
    if (row >= array.count) {
        return;
    }
    
    self.heightConstant.constant = 1.35*(SCREEN_WIDTH-30-10*4)/5;
    self.titleLab.font = kFontSize12;
    JUDIAN_READ_ReadListModel *info = model[row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
    self.titleLab.text = info.bookname;
    
}
@end
