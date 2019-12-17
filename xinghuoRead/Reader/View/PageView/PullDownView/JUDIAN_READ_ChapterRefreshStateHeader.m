//
//  JUDIAN_READ_ChapterRefreshStateHeader.m
//  xinghuoRead
//
//  Created by judian on 2019/5/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterRefreshStateHeader.h"

@implementation JUDIAN_READ_ChapterRefreshStateHeader

- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    [self setTitle:@"下拉可以加载上一章" forState:MJRefreshStateIdle];
    [self setTitle:@"松开立即加载上一章" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];

    //self.stateLabel;
    //self.lastUpdatedTimeLabel;
}

@end
