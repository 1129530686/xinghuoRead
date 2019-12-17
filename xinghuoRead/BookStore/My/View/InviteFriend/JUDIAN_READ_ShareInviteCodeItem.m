//
//  JUDIAN_READ_ShareInviteCodeItem.m
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ShareInviteCodeItem.h"


@interface JUDIAN_READ_ShareInviteCodeItem ()
@property(nonatomic, weak)UIImageView* imageView;
@property(nonatomic, weak)UILabel* titleLabel;
@end


@implementation JUDIAN_READ_ShareInviteCodeItem


- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {

    UIImageView* imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self addSubview:imageView];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(33));
        make.height.equalTo(@(33));

        make.centerX.equalTo(that.mas_centerX);
        make.top.equalTo(that.mas_top).offset(10);
    }];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(10));
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    

}



- (void)updateItem:(NSString*)title imageName:(NSString*)imageName {
    _titleLabel.text = title;
    _imageView.image = [UIImage imageNamed:imageName];
}



@end
