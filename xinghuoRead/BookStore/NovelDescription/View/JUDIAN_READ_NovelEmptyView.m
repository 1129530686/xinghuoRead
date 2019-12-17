//
//  JUDIAN_READ_NovelEmptyView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelEmptyView.h"

@implementation JUDIAN_READ_NovelEmptyView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    self.contentView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
}


@end
