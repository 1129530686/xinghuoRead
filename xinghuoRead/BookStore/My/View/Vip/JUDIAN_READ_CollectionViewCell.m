//
//  JUDIAN_READ_CollectionViewCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/1.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CollectionViewCell.h"

@implementation JUDIAN_READ_CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVipDataWithModel:(nullable id)model model2:(nullable id)model1 model3:(nullable id)model2 indexPath:(NSIndexPath *)indexPath{
    self.iconView.image = [UIImage imageNamed:model[indexPath.row]];
    self.centerLab.text = model1[indexPath.row];
    self.bottomLab.text = model2[indexPath.row];
}
@end
