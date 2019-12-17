//
//  JUDIAN_READ_UserReceiveGoldCoinCell.h
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JUDIAN_READ_UserDurationRewardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserReceiveGoldCoinCell : UITableViewCell
@property(nonatomic, copy)modelBlock block;
- (void)updateCell:(NSArray*)array duration:(NSString*)duration;
@end


@interface JUDIAN_READ_UserGoldCoinProgressView : UIView
@property(nonatomic, copy)modelBlock block;
- (void)updateView:(NSArray*)array duration:(NSString*)duration;
@end




NS_ASSUME_NONNULL_END
