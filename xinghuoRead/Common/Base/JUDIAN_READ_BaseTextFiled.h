//
//  BaseTextFiled.h
//  JYDoc
//
//  Created by mymac on 2018/8/21.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_BaseTextFiled : UITextField

@property (nonatomic, copy) void (^searchAction) (NSString *text);//右图标搜索事件

@property (nonatomic,copy) NSString *leftImage; //设置左边图标

@property (nonatomic,assign) CGFloat  paddingLeft;//默认无，有左图标不需要设置文字左边距



//imageName 右图标
//radius  圆角
- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeText textFont:(UIFont *)font searchImage:(NSString *)imageName;


@end
