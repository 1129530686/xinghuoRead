//
//  JUDIAN_READ_PayLoadView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/10.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_PayLoadView.h"


@implementation JUDIAN_READ_PayLoadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)showPayLoading{
    CGRect frame = CGRectMake((SCREEN_WIDTH-80)/2, (SCREEN_HEIGHT-80)/2, 80, 80);
    
    static JUDIAN_READ_PayLoadView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[JUDIAN_READ_PayLoadView alloc]initWithFrame:frame];
    });
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < 6; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading_tip_%d",i]];
        [arr addObject:img];
    }
    
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.center = view.center;
    imgV.animationImages = arr;
    imgV.animationDuration = 1;
    imgV.animationRepeatCount = INFINITY;
    [imgV startAnimating];
    [view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@34);
    }];
    
    [kKeyWindow addSubview:view];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [ super initWithFrame:frame]) {
        [self doBorderWidth:0 color:nil cornerRadius:5];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return self;
}

- (void)hiddenPayLoading{
    UIImageView *imgV = self.subviews.firstObject;
    [imgV stopAnimating];
    [self removeFromSuperview];
}


@end
