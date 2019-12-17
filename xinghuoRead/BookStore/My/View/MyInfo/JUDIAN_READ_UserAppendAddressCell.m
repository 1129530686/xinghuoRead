//
//  JUDIAN_READ_UserAppendAddressCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppendAddressCell.h"
#import "UILabel+JUDIAN_READ_Label.h"

@implementation JUDIAN_READ_UserAppendAddressCell

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
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"append_address_tip"];
    [self.contentView addSubview:imageView];
    
    UILabel* addTipLabel = [[UILabel alloc] init];
    addTipLabel.textColor =RGB(0x33, 0x33, 0x33);
    addTipLabel.font = [UIFont systemFontOfSize:14];
    addTipLabel.text = @"添加收货地址";
    [self.contentView addSubview:addTipLabel];
    
    
    UIImageView* rightArrowImageView = [[UIImageView alloc]init];
    rightArrowImageView.image = [UIImage imageNamed:@"list_next"];
    [self.contentView addSubview:rightArrowImageView];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(7));
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-12);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(17));
        make.height.equalTo(@(17));
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [addTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(14));
        make.left.equalTo(imageView.mas_right).offset(7);
        make.right.equalTo(rightArrowImageView.mas_right).offset(-14);
        make.centerY.equalTo(imageView.mas_centerY);
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



@end




#pragma mark JUDIAN_READ_UserEditedAddressCell

@interface JUDIAN_READ_UserEditedAddressCell ()
@property(nonatomic, weak)UILabel* nameLabel;
@property(nonatomic, weak)UILabel* telephoneLabel;
@property(nonatomic, weak)UILabel* defaultTipLabel;
@property(nonatomic, weak)UILabel* addressLabel;
@end



@implementation JUDIAN_READ_UserEditedAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UIImageView* rightArrowImageView = [[UIImageView alloc]init];
    rightArrowImageView.image = [UIImage imageNamed:@"list_next"];
    [self.contentView addSubview:rightArrowImageView];
    
    
    UILabel* nameLabel = [[UILabel alloc] init];
    _nameLabel = nameLabel;
    nameLabel.textColor =RGB(0x33, 0x33, 0x33);
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"";
    [self.contentView addSubview:nameLabel];
    
    
    UILabel* telephoneLabel = [[UILabel alloc] init];
    _telephoneLabel = telephoneLabel;
    telephoneLabel.textColor =RGB(0x99, 0x99, 0x99);
    telephoneLabel.font = [UIFont systemFontOfSize:12];
    telephoneLabel.text = @"";
    [self.contentView addSubview:telephoneLabel];
    
    
    UILabel* defaultTipLabel = [[UILabel alloc] init];
    _defaultTipLabel = defaultTipLabel;
    defaultTipLabel.layer.cornerRadius = 3;
    defaultTipLabel.layer.borderWidth = 0.5;
    defaultTipLabel.layer.borderColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR.CGColor;
    defaultTipLabel.layer.masksToBounds = YES;
    defaultTipLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    defaultTipLabel.font = [UIFont systemFontOfSize:10];
    defaultTipLabel.text = @"默认";
    defaultTipLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:defaultTipLabel];
    
    
    UILabel* addressLabel = [[UILabel alloc] init];
    _addressLabel = addressLabel;
    addressLabel.textColor =RGB(0x33, 0x33, 0x33);
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.text = @"";
    [self.contentView addSubview:addressLabel];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    WeakSelf(that);
    [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(7));
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-12);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(0));
        make.top.equalTo(that.contentView.mas_top).offset(17);
        make.height.equalTo(@(14));
    }];
    
    [telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(6);
        make.right.equalTo(rightArrowImageView.mas_left).offset(-14).priority(980);
        make.height.equalTo(@(12));
        make.bottom.equalTo(nameLabel.mas_bottom);
    }];
    

    [defaultTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.width.equalTo(@(27));
        make.height.equalTo(@(12));
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-17);
    }];
    

    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(defaultTipLabel.mas_right).offset(6);
        make.right.equalTo(rightArrowImageView.mas_left).offset(-14).priority(980);;
        make.height.equalTo(@(12));
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-17);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.mas_bottom);
    }];
}


- (void)updateCell:(JUDIAN_READ_UserDeliveryAddressModel*)model {
    
    _nameLabel.text = model.user_name;
    _telephoneLabel.text = model.phone_no;

    NSString* province = model.privince;
    NSString* city = model.city;
    NSString* area = model.area;
    NSString* detailAddress = model.detailed_addr;
    if (province.length <= 0) {
        province = @"";
    }
    
    if (city.length <= 0) {
        city = @"";
    }
    
    if (area.length <= 0) {
        area = @"";
    }
    
    if (detailAddress.length <= 0) {
        detailAddress = @"";
    }
    
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",province, city, area, detailAddress];
    
    if (!model.default_addr.intValue) {
        [_defaultTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0));
        }];
        
        WeakSelf(that);
        [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(that.defaultTipLabel.mas_right).offset(0);
        }];
    }

    CGFloat nameWidth = [_nameLabel getTextWidth:14];
    nameWidth = ceil(nameWidth);
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(nameWidth));
    }];
    
}



@end
