//
//  BaseView.m
//  JYDoc
//
//  Created by mymac on 2018/11/13.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

@implementation JUDIAN_READ_BaseView

- (void)dismissWithChangeAlphaAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alpha = 1;
    }];
}



- (void)popWithChangePositionAnimationDirection:(CustomDirection)direction{
    
//
//    if (direction == fromBottom) {
//        self.origin = CGPointMake(0, SCREEN_HEIGHT);
//    }
//    if (direction == fromRight) {
//        self.origin = CGPointMake(SCREEN_WIDTH, 0);
//    }
//    [kKeyWindow addSubview:self];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        self.origin = CGPointMake(0, 0);
//    } completion:^(BOOL finished) {
//
//    }];

   
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =kBackColor;
    }
    return self;
}


@end
