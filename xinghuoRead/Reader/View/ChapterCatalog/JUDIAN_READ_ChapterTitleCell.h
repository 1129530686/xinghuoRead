//
//  JUDIAN_READ_ChapterTitleCell.h
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_ChapterTitleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterTitleCell : UITableViewCell
@property(nonatomic, assign)BOOL isClicked;

- (void)setTitleWithModel:(JUDIAN_READ_ChapterTitleModel*)model;

- (void)setViewStyle;
- (void)setDefaultStyle;

@end

NS_ASSUME_NONNULL_END
