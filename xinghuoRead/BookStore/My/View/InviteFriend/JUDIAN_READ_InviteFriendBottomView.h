//
//  JUDIAN_READ_InviteFriendBottomViewl.h
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^touchEventBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_InviteFriendBottomView : UIView
@property(nonatomic, copy)touchEventBlock block;
- (void)hidePictureButton;
@end

NS_ASSUME_NONNULL_END
