//
//  JUDIAN_READ_AbstractViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AbstractViewController : UIViewController

@property(nonatomic, weak)UIView* noDataView;

- (void)showTipView:(NoDataTypeEnum)type;
- (void)hideTipView;

- (NSInteger)getTipViewTop;
- (NSInteger)getTipViewBottom;

- (void)notificationHandler:(NSNotification*)obj;

@end


NS_ASSUME_NONNULL_END
