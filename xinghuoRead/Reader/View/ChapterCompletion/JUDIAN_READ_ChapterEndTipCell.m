//
//  JUDIAN_READ_ChapterEndTipCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/27.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterEndTipCell.h"

@interface JUDIAN_READ_ChapterEndTipCell ()
@property(nonatomic, weak)UIButton* shareButton;
@end


@implementation JUDIAN_READ_ChapterEndTipCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"chapter_end_tip"];
    [self.contentView addSubview:imageView];
    
    UILabel* tipLabel = [[UILabel alloc]init];
    _tipLabel = tipLabel;
    tipLabel.textColor = RGB(0x66, 0x66, 0x66);
    tipLabel.text = @"";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tipLabel];
    
    UIButton* bookMallButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bookMallButton.layer.cornerRadius = 3;
    bookMallButton.layer.masksToBounds = YES;
    bookMallButton.layer.borderWidth = 1;
    bookMallButton.layer.borderColor = RGB(0xFF, 0xB2, 0xB2).CGColor;
    [bookMallButton setTitle:@"返回书城" forState:(UIControlStateNormal)];
    bookMallButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [bookMallButton setTitleColor:RGB(0xFF, 0xB0, 0xB1) forState:UIControlStateNormal];
    [self.contentView addSubview:bookMallButton];
    [bookMallButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    

    
    UIButton* shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _shareButton = shareButton;
    shareButton.layer.cornerRadius = 3;
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.borderWidth = 1;
    shareButton.layer.borderColor = RGB(0xFF, 0xB2, 0xB2).CGColor;
    shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareButton setTitle:@"分享出去" forState:(UIControlStateNormal)];
    [shareButton setTitleColor:RGB(0xFF, 0xB0, 0xB1) forState:UIControlStateNormal];
    [self.contentView addSubview:shareButton];
    [shareButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    WeakSelf(that);
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(120));
        make.height.equalTo(@(120));
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(that.mas_top).offset(72);
    }];
    
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.top.equalTo(imageView.mas_bottom).offset(17);
    }];
    
    
    NSInteger buttonWidth = 87;
    NSInteger edge = (SCREEN_WIDTH - buttonWidth * 2 - 13) / 2;
    
    [bookMallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView).offset(edge);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(30));
        make.top.equalTo(tipLabel.mas_bottom).offset(13);
    }];
    
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.contentView).offset(-edge);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(30));
        make.top.equalTo(tipLabel.mas_bottom).offset(13);
    }];

    
}



- (void)handleTouchEvent:(UIButton*)sender {
    
    if (_block) {
        if (sender == _shareButton) {
            _block(@"share");
        }
        else {
            _block(@"back");
        }
    }
}





@end
