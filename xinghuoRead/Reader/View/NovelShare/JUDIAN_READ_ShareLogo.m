//
//  JUDIAN_READ_ShareLogo.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ShareLogo.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_ShareLogo ()
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, assign)NSInteger height;
@end



@implementation JUDIAN_READ_ShareLogo

- (instancetype)initWithImage:(NSString*)imageName title:(NSString*)title height:(NSInteger)height {
    self = [super init];
    if (self) {
        _height = height;
        [self addViews:imageName title:title];
    }
    return self;
}


- (void)addViews:(NSString*)imageName title:(NSString*)title {
    
    UIImageView* imageView = [[UIImageView alloc]init];
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
        make.width.height.equalTo(@(that.height));
        make.left.equalTo(that.mas_left);
        make.top.equalTo(that.mas_top);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.width.equalTo(@(imageView.image.size.width + 10));
        make.height.equalTo(@(11));
        make.centerX.equalTo(imageView.mas_centerX);
    }];
    
    
}


- (void)setViewStyle {
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
    else {
        _titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    }
}



@end
