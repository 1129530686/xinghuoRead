//
//  JUDIAN_READ_ShelfView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"
@class JUDIAN_READ_NovelSummaryModel;

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ShelfView : JUDIAN_READ_BaseView

@property (nonatomic,assign) NSInteger  selectItem;
@property (nonatomic,strong) UIView  *selectItemView;
@property (nonatomic,strong) UIScrollView  *supScrView;
@property (nonatomic,strong) UIView *scrHeadView;
@property (nonatomic,strong) JUDIAN_READ_NovelSummaryModel  *model;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UITableView  *currentScrView;
@property (nonatomic,strong) UIView  *lineView;


@property (nonatomic,copy) CompletionBlock  selectBlcok;

- (void)loadData:(BOOL)isReset;
- (void)loadDataLike:(BOOL)isReset;

- (void)willDismiss:(BOOL)isYES;


@end

NS_ASSUME_NONNULL_END
