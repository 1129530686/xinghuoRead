//
//  BaseTextFiled.m
//  JYDoc
//
//  Created by mymac on 2018/8/21.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "JUDIAN_READ_BaseTextFiled.h"

@interface JUDIAN_READ_BaseTextFiled()

@property (nonatomic,strong) UIView *paddingLeftView;


@end

@implementation JUDIAN_READ_BaseTextFiled


- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeText textFont:(UIFont *)font searchImage:(NSString *)imageName{
    self = [super initWithFrame:frame];
    if (self) {
        //搜索框
        if (imageName) {
            CGFloat width = self.height == 0 ? 37 : self.height;
            UIView *parentV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
            UIButton *imageV = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageV setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [imageV addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
            imageV.frame = CGRectMake(0, 0, width, width);
            imageV.contentMode = UIViewContentModeCenter;
            [parentV addSubview:imageV];
            self.rightView = parentV;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
        self.tintColor = kColor100;
        self.placeholder = placeText;
        self.backgroundColor = [UIColor whiteColor];
        [self doBorderWidth:0 color:nil cornerRadius:0];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.font = font;
        
        self.textColor = kColor100;
        [self setValue:kColor153 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return self;
}

- (void)setLeftImage:(NSString *)leftImage{
    _leftImage = leftImage;
    self.paddingLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    UIButton *imageV1 = [UIButton buttonWithType:UIButtonTypeCustom];
    imageV1.frame = CGRectMake(0, 0, self.height, self.height);
    [imageV1 setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
    [imageV1 addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    imageV1.contentMode = UIViewContentModeCenter;
    [self.paddingLeftView addSubview:imageV1];
    self.leftView = self.paddingLeftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft{
    _paddingLeft = paddingLeft;
    self.paddingLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, paddingLeft, self.height)];
    self.leftView = self.paddingLeftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}



- (void)search{
    if (self.searchAction) {
        self.searchAction(self.text);
    }
}



@end
