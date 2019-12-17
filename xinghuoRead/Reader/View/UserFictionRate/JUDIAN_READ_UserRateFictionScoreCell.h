//
//  JUDIAN_READ_UserRateFictionScoreCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserRateFictionScoreCell : UITableViewCell
- (NSString*)getScore;
- (void)updateCell:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
