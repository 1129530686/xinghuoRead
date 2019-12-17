//
//  JUDIAN_READ_BaseViewController.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic,assign) BOOL  isCanNotBack;
@property (nonatomic,assign) BOOL  isPullDown;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) BOOL  hideBar;

@end
