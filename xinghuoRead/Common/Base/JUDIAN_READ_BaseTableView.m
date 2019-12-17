//
//  BaseTableView.m
//  Health
//
//  Created by 胡建波 on 2018/4/12.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "JUDIAN_READ_BaseTableView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "JUDIAN_READ_AppDelegate.h"

@interface JUDIAN_READ_BaseTableView ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UIImage  *noitceImage;
@property (nonatomic, assign) BOOL isBadNetOperation;
@end

@implementation JUDIAN_READ_BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BadNetOperation) name:@"BadNet" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNoDataView) name:@"NoNewData" object:nil];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 80;
        self.rowHeight = UITableViewAutomaticDimension;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = kColorWhite;
        self.verticalSpace = 0;
    }
    return self;
}


#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.verticalSpace;
}


- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.contentOffset = CGPointZero;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.noitceImage;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.noticeTitle];
    [attStr addAttributes:@{NSForegroundColorAttributeName:kColor100,NSFontAttributeName:kFontSize14} range:NSMakeRange(0, self.noticeTitle.length)];
    return attStr;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.noitceDetailTitle) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.noitceDetailTitle];
        [attStr addAttributes:@{NSForegroundColorAttributeName:kColor153,NSFontAttributeName:kFontSize12} range:NSMakeRange(0, self.noticeTitle.length)];

        return attStr;
        
    }
    return nil;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.isBadNetOperation) {
        return [UIImage imageNamed:@"default_button_reload"];
    }else if(self.noitceOperateImage){
        return [UIImage imageNamed:self.noitceOperateImage];
    }
    return nil;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self reload];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self reload];
}

- (void)reload{
    if (self.emptyCallBack) {
        if (self.isBadNetOperation) {
            self.emptyCallBack(1);
        }else{
            self.emptyCallBack(2);
        }
    }
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark 加载空白视图
#pragma mark 加载空白视图
- (void)addNoDataView{
    self.isBadNetOperation = NO;
    if (!self.noticeTitle || [self.noticeTitle isEqualToString:APP_NO_NETWORK_TIP]) {
        self.noticeTitle = APP_NO_RECORD_TIP;
    }
    if (self.noitceImageName) {
        self.noitceImage = [UIImage imageNamed:self.noitceImageName];
    }else{
        self.noitceImage = [UIImage imageNamed:@"default_no_record"];
    }
    [self operation];
    
}


- (void)BadNetOperation{
    self.isBadNetOperation = YES;
    self.noticeTitle = APP_NO_NETWORK_TIP;
    self.noitceImage = [UIImage imageNamed:@"default_wifi"];
    [self operation];
}

- (void)operation{
    if (self.isBadNetOperation && self.window) { //无网提示
        [MBProgressHUD showMessage:APP_NO_NETWORK_TIP];
    }
    if (self.mj_footer.isRefreshing) {//如果上拉加载
        [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        if (self.window) {
            self.emptyDataSetSource = self;
            self.emptyDataSetDelegate = self;
        }
    }
    
    if (self.mj_header.isRefreshing || self.mj_footer.isRefreshing) {
        [self.mj_header endRefreshing];
    }
   
    [self reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isHaveNet && self.isBadNetOperation) {
        self.isBadNetOperation = NO;
        [self.mj_footer resetNoMoreData];
    }
    
    if (self.needSimulate) {
        return YES;
    }
    return NO;
    
}

@end
