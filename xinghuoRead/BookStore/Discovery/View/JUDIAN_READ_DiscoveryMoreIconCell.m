//
//  JUDIAN_READ_DiscoveryMoreIconCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_DiscoveryMoreIconCell.h"
#import "JUDIAN_READ_ArticleListModel.h"

@implementation JUDIAN_READ_DiscoveryMoreIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView1 doBorderWidth:0 color:nil cornerRadius:0];
    [self.iconView2 doBorderWidth:0 color:nil cornerRadius:0];
    [self.iconView3 doBorderWidth:0 color:nil cornerRadius:0];
    [self.topLab doBorderWidth:0.5 color:kThemeColor cornerRadius:3];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMoreDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ArticleListModel *info = model[indexPath.row];
    self.titleLab.text = info.title;
    self.readCountLab.text = [NSString stringWithFormat:@"%@次阅读",info.read_number];
    self.nameLab.text = info.source;
    
    
    if (info.sort.intValue == 1) {
        self.titleLab.numberOfLines = 2;
        self.topLab.hidden = NO;
        self.leadingSpace.priority = 250;
        self.iconView1.hidden = YES ;
        self.iconView2.hidden = YES;
        self.iconView3.hidden = YES;
        self.nameLabSpace.priority = 751;
    }else{
        self.titleLab.numberOfLines = 2;
        self.topLab.hidden = YES;
        self.leadingSpace.priority = 751;
        self.iconView1.hidden = NO;
        self.iconView2.hidden = NO;
        self.iconView3.hidden = NO;
        self.nameLabSpace.priority = 250;
        [self.iconView1 sd_setImageWithURL:[NSURL URLWithString:info.img_list.firstObject] placeholderImage:[UIImage imageNamed:@"default_h2_image"]];
        if (info.img_list.count >= 2) {
            [self.iconView2 sd_setImageWithURL:[NSURL URLWithString:info.img_list[1]] placeholderImage:[UIImage imageNamed:@"default_h2_image"]];
        }
        if (info.img_list.count == 3) {
            [self.iconView3 sd_setImageWithURL:[NSURL URLWithString:info.img_list.lastObject] placeholderImage:[UIImage imageNamed:@"default_h2_image"]];
        }
    }

}

@end
