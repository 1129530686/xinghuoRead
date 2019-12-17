//
//  JUDIAN_READ_UserProfileThumbCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserProfileThumbCell.h"
#import "UIView+Common.h"

@interface JUDIAN_READ_UserProfileThumbCell ()
@property(nonatomic, weak)UIButton* profileButton;
@end

@implementation JUDIAN_READ_UserProfileThumbCell

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
    UIButton* profileButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    profileButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _profileButton = profileButton;
    UIImage* image = [UIImage imageNamed:@"head_big"];
    [profileButton setImage:image forState:(UIControlStateNormal)];
    [profileButton addTarget:self action:@selector(handleTouchEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:profileButton];
    
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"edit_head_image_tip"];
    [self.contentView addSubview:imageView];
    
    
    WeakSelf(that);
    [profileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(67));
        make.height.equalTo(@(67));
        make.centerX.equalTo(that.contentView);
        make.centerY.equalTo(that.contentView);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileButton.mas_left).offset(2);
        make.right.equalTo(profileButton.mas_right).offset(-2);
        make.height.equalTo(@(25));
        make.bottom.equalTo(profileButton.mas_bottom);
    }];
    
}



- (void)handleTouchEvent {
    if (_block) {
        _block(nil);
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_profileButton.frame.size.width > 0) {
        [_profileButton clipCorner:CGSizeMake(33, 33) corners:UIRectCornerAllCorners];
    }
}



- (void)updateImageWithUrl:(NSString*)imageUrl {
    UIImage* defaultImage = [UIImage imageNamed:@"head_big"];
    [_profileButton sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:defaultImage];
}


- (void)updateImage:(UIImage*)image {
    if (image) {
        [_profileButton setImage:image forState:UIControlStateNormal];
    }
    else {
        UIImage* defaultImage = [UIImage imageNamed:@"head_big"];
        [_profileButton setImage:defaultImage forState:UIControlStateNormal];
    }
    
    
}


@end
