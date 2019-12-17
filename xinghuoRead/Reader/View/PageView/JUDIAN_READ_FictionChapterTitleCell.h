//
//  JUDIAN_READ_FictionChapterTitleCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FictionChapterTitleCell : UICollectionViewCell
- (void)setTitleText:(NSString*)text;
- (NSInteger)getCellHeight:(BOOL)showAdvertise;
@end

NS_ASSUME_NONNULL_END
