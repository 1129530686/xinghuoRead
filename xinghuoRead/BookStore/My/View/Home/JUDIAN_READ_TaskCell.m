//
//  JUDIAN_READ_TaskCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_TaskCell.h"
#import "JUDIAN_READ_TaskModel.h"

@implementation JUDIAN_READ_TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)trailAction:(id)sender {
    
}

- (void)setDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_TaskModel *info = model[indexPath.row];
    self.nameLab.text = info.title;
    self.smallNameLab.text = info.desc;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.image] placeholderImage:[UIImage imageNamed:@"welfare_list_watch"]];
    
}

@end
