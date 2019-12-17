//
//  JUDIAN_READ_StyleSettingItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_StyleSettingItem.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "UILabel+JUDIAN_READ_Label.h"

@interface JUDIAN_READ_StyleSettingItem ()
@property(nonatomic, weak)UIImageView* imageView;
@property(nonatomic, weak)UILabel* titleLabel;
@end



@implementation JUDIAN_READ_StyleSettingItem

- (instancetype)initWithImage:(NSString*)imageName title:(NSString*)title {
    self = [super init];
    if (self) {
        [self addViews:imageName title:title];
    }
    return self;
}


- (void)addViews:(NSString*)imageName title:(NSString*)title {
    
    UIImageView* imageView = [[UIImageView alloc]init];
    _imageView = imageView;
    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [self addSubview:titleLabel];
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imageView.image.size.width));
        make.height.equalTo(@(imageView.image.size.height));
        make.left.equalTo(that.mas_left);
        make.top.equalTo(that.mas_top).offset(0);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(0);
        make.width.equalTo(@(imageView.image.size.width + 10));
        make.height.equalTo(@(11));
        make.centerX.equalTo(imageView.mas_centerX);
    }];
    
    
}


- (void)updateMargin:(CGFloat)imageTop textTop:(CGFloat)textTop {
    
    WeakSelf(that);
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.mas_top).offset(imageTop);
    }];
    
    
    NSInteger width = [_titleLabel getTextWidth:11];
    width = ceil(width);
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.imageView.mas_bottom).offset(textTop);
        make.width.equalTo(@(width));
    }];
}


- (void)setViewStyle:(NSString*)imageName {
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        NSString* name = [NSString stringWithFormat:@"%@_n", imageName];
        _titleLabel.textColor = RGB(0x99, 0x99, 0x99);
        _imageView.image = [UIImage imageNamed:name];
    }
    else {
        _imageView.image = [UIImage imageNamed:imageName];
        _titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    }
    
}


@end
