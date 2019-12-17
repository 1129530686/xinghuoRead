//
//  JUDIAN_READ_FictionCoverImageCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionCoverImageCell.h"
#import "UIImage+JUDIAN_READ_Blur.h"

#define AD_CONTENT_EDGE_LEFT 20
#define AD_CONTENT_EDGE_TOP 20


@interface JUDIAN_READ_FictionCoverImageCell ()
@property(nonatomic, weak)UIImageView* imageView;
@end



@implementation JUDIAN_READ_FictionCoverImageCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = TRUE;
    imageView.frame = CGRectMake(AD_CONTENT_EDGE_LEFT, AD_CONTENT_EDGE_TOP, CGRectGetWidth(frame) - 2 * AD_CONTENT_EDGE_LEFT, CGRectGetHeight(frame) - 2 * AD_CONTENT_EDGE_TOP);
    [imageView clipCorner:CGSizeMake(6, 6) corners:UIRectCornerAllCorners];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}



- (void)updateImage:(NSString*)imageUrl {
    UIImage* defaultImage = [UIImage imageNamed:@"default_advertise_tip"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage];
}


@end
