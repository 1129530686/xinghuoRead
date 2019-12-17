//
//  JUDIAN_READ_HowBrowseFictionView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/28.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^touchBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_HowBrowseFictionView : UIView
@property(nonatomic, copy)touchBlock block;
@end

NS_ASSUME_NONNULL_END
