//
//  JUDIAN_READ_MoneyChoicePanel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_AppreciateAmountModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MoneyChoicePanel : UIView
@property(nonatomic, copy)modelBlock block;
- (void)updateAmount:(NSArray*)array;
- (JUDIAN_READ_AppreciateAmountModel*)getSelectedModel;
@end

NS_ASSUME_NONNULL_END
