//
//  JUDIAN_READ_AppreciatedAvatarCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AppreciatedAvatarCell.h"

@interface JUDIAN_READ_AppreciatedAvatarCell ()
@property(nonatomic, strong)UIImageView* avatarImageView;
@end

@implementation JUDIAN_READ_AppreciatedAvatarCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.image = [UIImage imageNamed:@"head_small"];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = 13;
    _avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImageView];

    WeakSelf(that);
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.width.equalTo(that.mas_width);
        make.height.equalTo(that.mas_height);
    }];
    
}


- (void)setHeadImage:(NSString*)url {
    UIImage* image = [UIImage imageNamed:@"head_small"];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
}



@end
