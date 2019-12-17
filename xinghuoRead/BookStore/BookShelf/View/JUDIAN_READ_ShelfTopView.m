//
//  JUDIAN_READ_ShelfTopView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/14.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ShelfTopView.h"

@interface JUDIAN_READ_ShelfTopView ()

@property (nonatomic,strong) UIButton  *btn;
@property (nonatomic,strong) UILabel  *lab;

@end

@implementation JUDIAN_READ_ShelfTopView

- (instancetype)initWithFrame:(CGRect)frame imagesName:(NSString *)imagesName title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIButton *imgV = [UIButton buttonWithType:UIButtonTypeCustom];
        imgV.frame = CGRectMake(0, 12, frame.size.width, 40);
        if (imagesName) {
            [imgV setImage: [UIImage imageNamed:imagesName] forState:UIControlStateNormal];
        }
        imgV.contentMode = UIViewContentModeCenter;
        imgV.userInteractionEnabled = NO;
        self.btn = imgV;
        [self addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 52, frame.size.width, frame.size.height-57)];
        [lab setText:title titleFontSize:12 titleColot:kColor51];
        lab.textAlignment = NSTextAlignmentCenter;
        self.lab = lab;
        [self addSubview:lab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setTopTitle:(NSString *)topTitle{
    [self.btn setText:topTitle titleFontSize:17 titleColot:kColor51];
}

- (void)setBottomTextColor:(UIColor *)bottomTextColor{
    self.lab.textColor = bottomTextColor;
}

- (void)setBottomTextFont:(UIFont *)bottomTextFont{
    self.lab.font = bottomTextFont;
}

- (void)setImgName:(NSString *)imgName{
    if ([imgName containsString:@"http"] || !imgName.length) {
        [self.btn sd_setImageWithURL:[NSURL URLWithString:imgName] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default_big"]];
        
    }else{
        [self.btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];

    }
}

- (void)setTitle:(NSString *)title{
    [self.lab setText:title];
}


- (void)touchAction{
    if (self.touchBlock) {
        self.touchBlock();
    }
}

- (void)changeTopViewFrame:(CGRect)frame bottomFrame:(CGRect)frame1{
    self.btn.frame = frame; 
    self.lab.frame = frame1;
}

@end
