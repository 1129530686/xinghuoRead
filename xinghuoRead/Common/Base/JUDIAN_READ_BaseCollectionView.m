//
//  BaseCollectionView.m
//  Health
//
//  Created by mymac on 2018/5/11.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "JUDIAN_READ_AppDelegate.h"

@interface JUDIAN_READ_BaseCollectionView ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,copy) UIImage  *noitceImage;
@property (nonatomic,assign) BOOL isBadNetOperation;
@end

@implementation JUDIAN_READ_BaseCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        [self setBackgroundColor:kColorWhite];
        self.yOffset = 0.0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BadNetOperation) name:@"BadNet" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNoDataView) name:@"NoNewData" object:nil];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.contentOffset = CGPointZero;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.noitceImage;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.noticeTitle];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.noticeTitle.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:kColor153 range:NSMakeRange(0, self.noticeTitle.length)];
    return attStr;
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

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.yOffset;
}


//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
//    UIView *view = [[UIView alloc]initWithFrame:scrollView.bounds];
//    view.backgroundColor = kThemeColor;
//    UIImageView *imgV = [[UIImageView alloc]initWithImage:self.noitceImage];
//    imgV.center = CGPointMake(self.center.x, self.origin.y - 25);
//    [view addSubview:imgV];
//
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame) + 12, SCREEN_WIDTH, 15)];
//    [lab setText:self.noticeTitle titleFontSize:14 titleColot:kColor100];
//    lab.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:lab];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = nil;
//    if (self.isBadNetOperation) {
//        img = [UIImage imageNamed:@"default_button_reload"];
//    }else if(self.noitceOperateImage){
//        img = [UIImage imageNamed:self.noitceOperateImage];
//    }
//    [btn setImage:img forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = CGRectMake(0,CGRectGetMaxY(lab.frame)+13, SCREEN_WIDTH, 30);
//    btn.contentMode = UIViewContentModeCenter;
//    [view addSubview:btn];
//
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (self.isBadNetOperation) {
//        [btn1 setText:@"设置网络" titleFontSize:12 titleColot:RGBA(85, 157, 255, 1)];
//        btn1.frame = CGRectMake(0, view.height - 33 - 12, SCREEN_WIDTH, 12);
//        [btn1 addTarget:self action:@selector(setOPerateAction) forControlEvents:UIControlEventTouchUpInside];
//        [btn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//        [view addSubview:btn1];
//    }else{
//        [btn1 removeFromSuperview];
//    }
//    return view;
//}
//
//- (void)setOPerateAction{
//
//}

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
    [MBProgressHUD hideHUDForView:self];
    
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
