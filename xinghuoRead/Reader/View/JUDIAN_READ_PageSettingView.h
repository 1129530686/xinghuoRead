//
//  JUDIAN_READ_PageNavigationView.h
//  xinghuoRead
//
//  Created by judian on 2019/4/24.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_PageNavigationView.h"

typedef void(^callblock)(BOOL isShow);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_PageSettingView : UIView

@property(nonatomic, copy) modelBlock block;
@property(nonatomic, weak)UIButton* favoritesButton;

- (void)setTitleText:(NSString*)text;

- (void)addToKeyWindow:(UIView*)container;
- (void)showBarView;
- (void)showMenu;

- (void) hideView;
- (void)removeBarView;

- (BOOL)isShow;

- (void)setViewStyle;
- (void)updateBookInfo:(NSString*)bookName chapterName:(NSString*)chapterName;

@end

NS_ASSUME_NONNULL_END
