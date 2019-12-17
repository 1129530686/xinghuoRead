//
//  JUDIAN_READ_UserShareCodeMenu.h
//  universalRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_InviteFriendBottomView.h"
typedef void(^touchBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserShareCodeMenu : UIView
@property(nonatomic, weak)JUDIAN_READ_InviteFriendBottomView* barView;
@property(nonatomic, copy)touchBlock block;
- (void)showView ;
@end

NS_ASSUME_NONNULL_END
