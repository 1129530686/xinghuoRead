//
//  JUDIAN_READ_SearchColCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SearchColCell.h"

@implementation JUDIAN_READ_SearchColCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVipDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.titleLab.text  = [NSString stringWithFormat:@"%@立即开通",model];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.backgroundColor = kColor82;
}

- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    NSMutableArray *arr = model[indexPath.section];
    NSString *str =  indexPath.section == 0 ? [arr[indexPath.row] title] : arr[indexPath.row];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    self.titleLab.text = str1;
    [self.titleLab setTextAlignment:NSTextAlignmentLeft];
    
}
@end
