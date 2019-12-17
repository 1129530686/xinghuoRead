//
//  JUDIAN_READ_UserAreaItemCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAreaItemCell.h"

@interface JUDIAN_READ_UserAreaItemCell ()
@property(nonatomic, weak)UILabel* itemName;
@property(nonatomic, weak)UIImageView* rightArrowImageView;
@end


@implementation JUDIAN_READ_UserAreaItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    UILabel* itemName = [[UILabel alloc]init];
    _itemName = itemName;
    itemName.font = [UIFont systemFontOfSize:14];
    itemName.textColor = RGB(0x33, 0x33, 0x33);
    itemName.textAlignment = NSTextAlignmentLeft;
    itemName.text = @"";
    [self.contentView addSubview:itemName];
    

    UIImageView* rightArrowImageView = [[UIImageView alloc]init];
    _rightArrowImageView = rightArrowImageView;
    rightArrowImageView.image = [UIImage imageNamed:@"list_next"];
    [self.contentView addSubview:rightArrowImageView];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.hidden = YES;
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(7));
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-12);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(14));
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(rightArrowImageView.mas_right).offset(-14);
        make.centerY.equalTo(rightArrowImageView.mas_centerY);
    }];
    

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];

}


- (void)updateArea:(NSString*)areaName isRightArrow:(BOOL)isRightArrow {
    _itemName.text = areaName;
    _rightArrowImageView.hidden = !isRightArrow;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
