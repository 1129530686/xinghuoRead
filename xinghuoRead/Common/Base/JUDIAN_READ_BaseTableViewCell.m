//
//  BaseTableViewCell.m
//
//  Created by hu on 16/6/1.
//  Copyright © 2016年. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

@implementation JUDIAN_READ_BaseTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)setDataWithBaseModel:(JUDIAN_READ_BaseModel*)model{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //样式设置
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = kColor82;
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = kColor153;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
