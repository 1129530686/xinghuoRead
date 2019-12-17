//
//  JUDIAN_READ_MoreItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_MoreItem.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_MoreItem ()
@property(nonatomic, strong)UIImageView* imageView;
@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UIView* lineView;
@end


@implementation JUDIAN_READ_MoreItem

- (instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName bottomLine:(BOOL)bottomLine {
    
    self = [super init];
    if (self) {
        [self addViews:title imageName:imageName bottomLine:bottomLine];
    }
    
    return self;
}


- (void)addViews:(NSString*)title imageName:(NSString*)imageName bottomLine:(BOOL)bottomLine {
    
    _imageView = [[UIImageView alloc]init];
    _imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:_imageView];
    
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = title;
    
    _titleLabel.textColor = READER_TAB_BAR_TEXT_COLOR;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLabel];
    
    
    WeakSelf(that);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.mas_left).offset(30);
    }];
    
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@30);
        make.height.equalTo(@13);

        make.centerY.equalTo(that.mas_centerY);
        make.left.equalTo(that.imageView.mas_right).offset(12);
        
    }];
    
    
    if (bottomLine) {
        UIView* lineView = [[UIView alloc]init];
        _lineView = lineView;
        lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.6);
            make.left.equalTo(that.mas_left).offset(4);
            make.right.equalTo(that.mas_right).offset(-4);
            make.bottom.equalTo(that.mas_bottom).offset(-0.6);
        }];
    }
    
}



- (void)setViewStyle:(NSString*)imageName nightMode:(BOOL)nightMode {
    
    _imageView.image = [UIImage imageNamed:imageName];
    
    if (nightMode) {
        _titleLabel.textColor = READER_NAVIGATION_BAR_NIGHT_TEXT_COLOR;
    }
    else {
        _titleLabel.textColor = READER_TAB_BAR_TEXT_COLOR;
    }
    
    if (nightMode) {
        _lineView.backgroundColor = RGB(0x33, 0x33, 0x33);
    }
    else {
        _lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    }
}






@end
