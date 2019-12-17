//
//  JUDIAN_READ_UserBriefItemCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserBriefItemCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_UserBriefItemCell ()

@property(nonatomic, weak)UILabel* itemName;
@property(nonatomic, weak)UILabel* itemContent;
@property(nonatomic, weak)UIView* lineView;

@end



@implementation JUDIAN_READ_UserBriefItemCell

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
    [self.contentView addSubview:itemName];
    
    UILabel* itemContent = [[UILabel alloc]init];
    _itemContent = itemContent;
    itemContent.textAlignment = NSTextAlignmentRight;
    itemContent.font = [UIFont systemFontOfSize:12];
    itemContent.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:itemContent];
 
    UIImageView* rightArrowImageView = [[UIImageView alloc]init];
    rightArrowImageView.image = [UIImage imageNamed:@"list_next"];
    [self.contentView addSubview:rightArrowImageView];
    
    UIView* lineView = [[UIView alloc] init];
    _lineView = lineView;
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
        make.width.equalTo(@(0));
        make.height.equalTo(@(14));
        make.left.equalTo(that.contentView.mas_left).offset(10);
        make.centerY.equalTo(rightArrowImageView.mas_centerY);
    }];
    
    
    [itemContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemName.mas_right).offset(10);
        make.height.equalTo(@(12));
        make.right.equalTo(rightArrowImageView.mas_right).offset(-10);
        make.centerY.equalTo(rightArrowImageView.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}




- (void)updateCell:(NSString*)name content:(NSString*)content bottomLine:(BOOL)bottomLine {
    _itemName.text = name;
    _itemContent.text = content;
    
    CGFloat width = [_itemName getTextWidth:14];
    width = ceil(width);
    [_itemName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    _lineView.hidden = !bottomLine;
}



@end
