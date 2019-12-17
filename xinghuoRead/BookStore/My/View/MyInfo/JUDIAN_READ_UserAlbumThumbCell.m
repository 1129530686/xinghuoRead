//
//  JUDIAN_READ_UserAlbumThumbCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAlbumThumbCell.h"

@interface JUDIAN_READ_UserAlbumThumbCell ()
@property(nonatomic, weak)UIImageView* imageView;
@end



@implementation JUDIAN_READ_UserAlbumThumbCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}



- (void)addViews {
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"default_v_image"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    
    _imageView = imageView;
    [self.contentView addSubview:imageView];
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(that.contentView.mas_width);
        make.height.equalTo(that.contentView.mas_height);
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
    }];
}



- (void)updateImage:(UIImage*)image {
    _imageView.image = image;
}



@end
