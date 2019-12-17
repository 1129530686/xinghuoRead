//
//  JUDIAN_READ_UserCurrentLocationCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserCurrentLocationCell.h"

@interface JUDIAN_READ_UserCurrentLocationCell ()
@property(nonatomic, weak)UILabel* userLocationLabel;
@end



@implementation JUDIAN_READ_UserCurrentLocationCell

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
    
    UIImageView* locationImageView = [[UIImageView alloc] init];
    locationImageView.image = [UIImage imageNamed:@"my_location_tip"];
    [self.contentView addSubview:locationImageView];
    
    UILabel* locationTipLabel = [[UILabel alloc] init];
    locationTipLabel.text = @"当前位置";
    locationTipLabel.textColor = RGB(0x99, 0x99, 0x99);
    locationTipLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:locationTipLabel];
    
    
    UILabel* userLocationLabel = [[UILabel alloc] init];
    _userLocationLabel = userLocationLabel;
    userLocationLabel.text = @"";
    userLocationLabel.textColor = RGB(0x33, 0x33, 0x33);
    userLocationLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:userLocationLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.top.equalTo(that.contentView.mas_top).offset(16);
        make.width.equalTo(@(8));
        make.height.equalTo(@(10));
    }];
    
    
    [locationTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(3);
        make.centerY.equalTo(locationImageView.mas_centerY);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(12));
    }];
    
    
    [userLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-16);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
}



- (void)updateLocation:(NSString*)name {
    _userLocationLabel.text = name;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
