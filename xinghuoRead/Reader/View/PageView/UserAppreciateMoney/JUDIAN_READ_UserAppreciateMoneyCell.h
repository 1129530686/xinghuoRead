//
//  JUDIAN_READ_UserAppreciateMoneyCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/31.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_MoneyChoicePanel.h"


typedef void(^touchBlock)(_Nullable id args);


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAppreciateMoneyCell : UITableViewCell
@property(nonatomic, copy)touchBlock block;
@property(nonatomic, weak)JUDIAN_READ_MoneyChoicePanel* choicePanel;
@end

NS_ASSUME_NONNULL_END
