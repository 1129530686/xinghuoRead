//
//  JUDIAN_READ_CategoryReusableView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CategoryReusableView.h"

@implementation JUDIAN_READ_CategoryReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCategoryRightDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = model[indexPath.section];
    self.centerLab.text = dic[@"name"];
}

@end
