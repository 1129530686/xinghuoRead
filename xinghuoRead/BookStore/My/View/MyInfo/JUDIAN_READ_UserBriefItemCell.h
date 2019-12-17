//
//  JUDIAN_READ_UserBriefItemCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_CustomBackgroundViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserBriefItemCell : JUDIAN_READ_CustomBackgroundViewCell
- (void)updateCell:(NSString*)name content:(NSString*)content bottomLine:(BOOL)bottomLine;
@end

NS_ASSUME_NONNULL_END
