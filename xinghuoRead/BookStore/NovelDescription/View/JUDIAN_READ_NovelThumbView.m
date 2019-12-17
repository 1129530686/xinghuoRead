//
//  JUDIAN_READ_NovelCoverView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelThumbView.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"
#import "UIImage+JUDIAN_READ_Blur.h"


@interface JUDIAN_READ_NovelThumbView ()
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UIImageView* imageView;
@end



@implementation JUDIAN_READ_NovelThumbView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_v_image"];
    imageView.layer.cornerRadius = 3;
    imageView.layer.borderColor = RGB(0xee, 0xee, 0xee).CGColor;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.masksToBounds = YES;
    
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView = imageView;
    [self.contentView addSubview:imageView];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* titleLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    _titleLabel = titleLabel;
    titleLabel.alignmentStyle = TextInTop;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"";
    [self.contentView addSubview:titleLabel];
    
#if 0
    UIImageView* freeImageView = [[UIImageView alloc]init];
    freeImageView.image = [UIImage imageNamed:@"label_free"];
    [self addSubview:freeImageView];
#endif
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(that.contentView.mas_width);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-47);
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(that.contentView.mas_top);
    }];
    

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(imageView.mas_bottom).offset(9);
        make.height.equalTo(@(38));
    }];
    
#if 0
    [freeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //16 24
        make.left.equalTo(that.contentView.mas_left).offset(7);
        make.top.equalTo(that.contentView.mas_top).offset(-1);
        make.width.equalTo(@(16));
        make.height.equalTo(@(24));
    }];
#endif
    
}



- (void)setThumbWithModel:(JUDIAN_READ_NovelThumbModel*)model {

#if 0
    WeakSelf(that);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        that.imageView.image = [image createCornerImage:CGSizeMake(10, 10)];
    }];
#else
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_v_image"]];
#endif
    
    _titleLabel.text = model.bookname;
}


@end
