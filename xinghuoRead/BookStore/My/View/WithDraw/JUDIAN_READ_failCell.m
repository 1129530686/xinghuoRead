//
//  JUDIAN_READ_failCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_failCell.h"

@implementation JUDIAN_READ_failCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.processLab doBorderWidth:0.5 color:kColor204 cornerRadius:2];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithDrawDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath{
}

@end
