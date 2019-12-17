//
//  JUDIAN_READ_RewardSuccessView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

typedef void(^payResultBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_RewardSuccessView : UIControl

@property(nonatomic, weak)UIViewController* viewController;
@property(nonatomic, copy)payResultBlock block;

- (instancetype)initWithType:(BOOL)isSuccess;

@end

NS_ASSUME_NONNULL_END
