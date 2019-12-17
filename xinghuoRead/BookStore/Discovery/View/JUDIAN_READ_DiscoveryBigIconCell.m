//
//  JUDIAN_READ_DiscoveryBigIconCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_DiscoveryBigIconCell.h"
#import "JUDIAN_READ_ArticleListModel.h"

@implementation JUDIAN_READ_DiscoveryBigIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:0];
    [self.topLab doBorderWidth:0.5 color:kThemeColor cornerRadius:3];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBigDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ArticleListModel *info = model[indexPath.row];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.img_list.firstObject] placeholderImage:[UIImage imageNamed:@"default_h_image"]];
    self.titleLab.text = info.title;
    self.readcountLab.text = [NSString stringWithFormat:@"%@次阅读",info.read_number];
    self.nameLab.text = info.source;
    
    self.topLab.hidden = info.sort.intValue == 1 ? NO : YES;
    self.leadSpace.priority = info.sort.intValue == 1 ? 250 : 751;
    
}

@end
