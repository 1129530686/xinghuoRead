//
//  MainViewController.h
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BookStoreController : JUDIAN_READ_BaseViewController

@property (nonatomic,strong) UIScrollView  *scrView;
@property (nonatomic,assign) NSInteger  selectItem;


- (void)loadParentDataFromBottom:(BOOL)isYES;

- (NSString *)getSelectPage:(BOOL)isAdd isReset:(BOOL)isRestSet;

@end

NS_ASSUME_NONNULL_END
