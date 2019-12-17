//
//  JUDIAN_READ_TagCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/11.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_TagCell.h"
#import "JUDIAN_READ_TagModel.h"

@implementation JUDIAN_READ_TagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTagDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_TagModel *info = model[indexPath.row];
    if (info.is_checkd.intValue) {
        [self.leadLab setText:info.title titleFontSize:14 titleColot:kThemeColor];
        self.trailBtn.hidden = NO;
    }else{
        [self.leadLab setText:info.title titleFontSize:14 titleColot:kColor100];
        self.trailBtn.hidden = YES;
    }
    
}

@end
