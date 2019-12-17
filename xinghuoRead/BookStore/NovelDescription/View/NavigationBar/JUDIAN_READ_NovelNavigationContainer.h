//
//  JUDIAN_READ_NovelNavigationBar.h
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_NovelNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelNavigationContainer : UIView

@property(nonatomic, weak)JUDIAN_READ_NovelNavigationBar* navigationBar;
@property(nonatomic, weak)UIView* lineView;

- (void)setTitleFont:(NSInteger)size;
- (void)setTitle:(NSString*)title;
- (void)changeBarTransparent:(CGFloat)alpha;
- (void)showShareButton:(BOOL)visible;



@end

NS_ASSUME_NONNULL_END
