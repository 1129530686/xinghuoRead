//
//  JUDIAN_READ_UserBriefEmptyCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserBriefEmptyCell.h"

@implementation JUDIAN_READ_UserBriefEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
