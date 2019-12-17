//
//  JUDIAN_READ_NovelNavigationBar.h
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchEventBlock)(_Nonnull id sender);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelNavigationBar : UIView

@property(nonatomic, copy)touchEventBlock block;
@property(nonatomic, weak) UILabel* titleLabel;

- (void)changeBarStyle:(BOOL)isTransparent;
- (void)showShareButton:(BOOL)visible;

@end

NS_ASSUME_NONNULL_END
