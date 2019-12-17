//
//  JUDIAN_READ_FictionStateCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/20.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionStateCell.h"

@interface JUDIAN_READ_FictionStateCell ()
@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UILabel* countLabel;
@property(nonatomic, strong)UILabel* updateInfoLabel;
@property(nonatomic, strong)UILabel* sloganLabel;
@end


@implementation JUDIAN_READ_FictionStateCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:_countLabel];
    
    
    _updateInfoLabel = [[UILabel alloc] init];
    _updateInfoLabel.font = [UIFont systemFontOfSize:12];
    _updateInfoLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:_updateInfoLabel];
    
    
    _sloganLabel = [[UILabel alloc] init];
    _sloganLabel.font = [UIFont systemFontOfSize:12];
    _sloganLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:_sloganLabel];
    
    WeakSelf(that);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.contentView.mas_top).offset(14);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(17));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(14));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    
    [_updateInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.countLabel.mas_bottom).offset(17);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    
    [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.updateInfoLabel.mas_bottom).offset(8);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
}



- (void)updateFictionInfo:(NSString*)title count:(NSString*)count updateInfo:(NSString*)updateInfo slogan:(NSString*)slogan {
    _titleLabel.text = title;
    _countLabel.text = count;
    _updateInfoLabel.text = updateInfo;
    _sloganLabel.text = slogan;
}





@end


@implementation JUDIAN_READ_NoChapterCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"default_no_book"];
    [self.contentView addSubview:imageView];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    titleLabel.text = @"抱歉，当前书籍已被下架";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        make.top.equalTo(that.contentView.mas_top).offset(51);
        make.centerX.equalTo(that.contentView.mas_centerX);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.top.equalTo(imageView.mas_bottom).offset(17);
    }];
}




@end
