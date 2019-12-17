//
//  BaseView.h
//  JYDoc
//
//  Created by mymac on 2018/11/13.
//  Copyright © 2018年 Hu. All rights reserved.
//
typedef NS_ENUM(NSUInteger, CustomDirection) {
    fromTop,
    fromLeft,
    fromBottom,
    fromRight
};

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_BaseView : UIView

- (void)dismissWithChangeAlphaAnimation;


//暂时实现从下往上和从右往左效果
- (void)popWithChangePositionAnimationDirection:(CustomDirection)direction;

@end
