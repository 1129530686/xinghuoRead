//
//  JUDIAN_READ_FictionNavigationView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callback)(ReaderTextStyleCmd cmd);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FictionNavigationView : UIControl
@property(nonatomic, copy)callback handleTouchEvent;
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, assign)BOOL isShow;
- (void)setDayStyle;
- (void)setViewStyle;
- (void)hideButton:(BOOL)canShare;

@end

NS_ASSUME_NONNULL_END
