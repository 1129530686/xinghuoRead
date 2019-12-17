//
//  JUDIAN_READ_CustomBackgroundViewCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/11.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_CustomBackgroundViewCell.h"

@implementation JUDIAN_READ_CustomBackgroundViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = RGB(0xee, 0xee, 0xee);
        self.selectedBackgroundView = v;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
