//
//  JUDIAN_READ_FontSizeSettingItem.h
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_TextStyleModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FontSizeSettingItem : UIControl
- (void)setDefaultStyle;
- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel* _Nullable)model;
- (void)setTitleStyle;
@end

@interface JUDIAN_READ_TurnPageStyleSettingItem : UIControl
- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel* _Nullable)model;
- (void)setButtonStyle;
- (void)setTitleStyle;
@end


NS_ASSUME_NONNULL_END
