//
//  JUDIAN_READ_UserAppreciateAvatarCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAppreciateAvatarCell : UICollectionViewCell
- (void)reloadAvatar:(NSArray*)array;
- (void)setViewStyle;
- (void)setDefaultStyle;
@end

NS_ASSUME_NONNULL_END