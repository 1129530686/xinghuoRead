//
//  JUDIAN_READ_DiscoveryLeadIconCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_DiscoveryLeadIconCell.h"
#import "JUDIAN_READ_ArticleListModel.h"

@implementation JUDIAN_READ_DiscoveryLeadIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconVIew doBorderWidth:0 color:nil cornerRadius:0];
    [self.topLab doBorderWidth:0.5 color:kThemeColor cornerRadius:3];
    self.iconWidth.constant = (SCREEN_WIDTH-30-20)/3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDiscoveryDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ArticleListModel *info = model[indexPath.row];
    [self.iconVIew sd_setImageWithURL:[NSURL URLWithString:info.img_list.firstObject] placeholderImage:[UIImage imageNamed:@"default_h2_image"]];
    self.titleLab.text = info.title;
    self.readCountLab.text = [NSString stringWithFormat:@"%@次阅读",info.read_number];
    self.nameLab.text = info.source;
    self.topLab.hidden = info.sort.intValue == 1 ? NO : YES;
    self.leadSpace.constant = info.sort.intValue == 1 ? 45 : 13;
}

@end
