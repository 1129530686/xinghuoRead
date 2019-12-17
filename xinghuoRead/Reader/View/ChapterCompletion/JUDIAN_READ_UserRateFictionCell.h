//
//  JUDIAN_READ_UserRateFictionCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^rateBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserRateFictionCell : UICollectionViewCell
@property(nonatomic, copy)rateBlock block;
@end

NS_ASSUME_NONNULL_END
