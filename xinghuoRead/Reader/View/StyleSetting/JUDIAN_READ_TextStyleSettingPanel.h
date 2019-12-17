//
//  JUDIAN_READ_TextStyleSettingPanel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_TextStyleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TextStyleSettingPanel : UIControl
- (void)addToKeyWindow:(UIView*)container;
- (void)showView;
- (void)adjustButtonStyle:(JUDIAN_READ_TextStyleModel*)model;
- (void)setViewStyle;
- (void)hideView;

@end

NS_ASSUME_NONNULL_END
