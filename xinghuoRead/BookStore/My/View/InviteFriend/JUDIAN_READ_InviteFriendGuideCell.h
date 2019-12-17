//
//  JUDIAN_READ_InviteFriendGuideCell.h
//  universalRead
//
//  Created by judian on 2019/7/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_InviteFriendGuideCell : UITableViewCell

@property(nonatomic, copy)touchBlock block;

- (void)updateCell:(NSString*)coinCount friendCount:(NSString*)friendCount;
- (NSInteger)getCellHeight;

@end

NS_ASSUME_NONNULL_END
