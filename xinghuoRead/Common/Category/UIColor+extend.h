//
//  UIColor+extend.h
//  DealExtreme
//
//  Created by hu on 10-8-30.
//  Copyright 2015 epro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 扩展UIColor类
@interface UIColor(extend)

// 将十六进制的颜色值转为objective-c的颜色
+ (UIColor *)getColor:(NSString *) hexColor;

@end