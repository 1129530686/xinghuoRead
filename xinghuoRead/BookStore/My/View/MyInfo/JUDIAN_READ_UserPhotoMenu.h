//
//  JUDIAN_READ_UserPhotoMenu.h
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^touchBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserPhotoMenu : UIView

@property(nonatomic, copy)touchBlock block;

- (void)showView;
- (void)hideView;
@end

NS_ASSUME_NONNULL_END
