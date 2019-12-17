//
//  JUDIAN_READ_FastSearchCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_FastSearchCell.h"
#import "JUDIAN_READ_FastSearchModel.h"

@implementation JUDIAN_READ_FastSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.leadBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath keyWords:(NSString *)keywords{
    JUDIAN_READ_FastSearchModel *info = model[indexPath.row];
    NSString *title = [info.title stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange range = [title rangeOfString:keywords options:NSCaseInsensitiveSearch];
    [att setAttributes:@{NSFontAttributeName:kFontSize14,NSForegroundColorAttributeName:kThemeColor} range:range];
    [self.leadBtn setTitle:info.kname forState:UIControlStateNormal];
    if ([info.ktype isEqualToString:@"book"]) {
        [self.leadBtn setImage:[UIImage imageNamed:@"search_icon_books"] forState:UIControlStateNormal];
    }else{
        [self.leadBtn setImage:[UIImage imageNamed:@"search_icon_people"] forState:UIControlStateNormal];
    }
    self.trailLab.attributedText = att;
}
@end
