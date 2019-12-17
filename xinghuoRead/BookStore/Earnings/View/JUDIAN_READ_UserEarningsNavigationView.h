//
//  JUDIAN_READ_UserEarningsNavigationView.h
//  xinghuoRead
//
//  Created by judian on 2019/6/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBlock)(_Nonnull id sender);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserEarningsNavigationView : UIView
@property(nonatomic, copy)touchBlock block;
- (void)updateEarningsNavigation:(NSString*)title rightTitle:(NSString*)rightTitle;
- (void)updateUserBriefNavigation:(NSString*)title rightTitle:(NSString*)rightTitle;
- (void)updateTitle:(NSString*)title rightTitle:(NSString*)rightTitle;
@end

NS_ASSUME_NONNULL_END
