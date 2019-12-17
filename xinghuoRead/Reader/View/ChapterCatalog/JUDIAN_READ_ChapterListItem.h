//
//  JUDIAN_READ_ChapterListItem.h
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterListItem : UIControl
@property(nonatomic, assign)NSInteger clickIndex;
- (void)realoadData:(NSArray*)array;
- (void)scrollToTop:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
