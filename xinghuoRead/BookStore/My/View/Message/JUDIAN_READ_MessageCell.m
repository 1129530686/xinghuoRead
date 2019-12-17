//
//  JUDIAN_READ_MessageCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MessageCell.h"

@implementation JUDIAN_READ_MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:20];
    [self.countLab doBorderWidth:0 color:nil cornerRadius:8];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath{
    
}

@end
