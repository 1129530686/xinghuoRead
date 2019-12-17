//
//  JUDIAN_READ_SettingMenuPanel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SettingMenuPanel : UIControl

@property(nonatomic, copy)NSString* fromView;

- (instancetype)initWithId:(NSString*)bookId;
- (instancetype)initShareView:(NSString*)bookId;

- (void)addToKeyWindow:(UIView*)container;
- (void)showView;
- (void)removeSelf;

- (void)setViewStyle;

@end

NS_ASSUME_NONNULL_END
