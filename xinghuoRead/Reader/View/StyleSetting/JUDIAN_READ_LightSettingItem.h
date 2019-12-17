//
//  JUDIAN_READ_LightSettingItem.h
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_TextStyleModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_LightSettingItem : UIControl
- (void)setButtonStyle;
- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel*)model;
- (void)setTitleStyle;
@end

NS_ASSUME_NONNULL_END
