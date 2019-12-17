//
//  JUDIAN_READ_ScrollReusableView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/21.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ScrollReusableView.h"

@implementation JUDIAN_READ_ScrollReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        self.cycleView = [[JUDIAN_READ_CycleVerticalView alloc]initWithFrame:CGRectMake(15, 0, self.width-30, self.height)];
        [self addSubview:self.cycleView];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = KSepColor;
        [self addSubview:view];
            
        self.cycleView.direction = ZBCycleVerticalViewScrollDirectionUp;
        WeakSelf(obj);
        self.cycleView.block = ^(NSInteger index) {
            if (obj.touchBlock) {
                obj.touchBlock(index);
            }
        };
    }
    return self;
}



- (void)setArr:(NSMutableArray *)arr{
    _arr = arr;
    self.cycleView.dataArray = arr;
}

@end
