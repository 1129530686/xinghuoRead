//
//  JUDIAN_READ_ChapterTitleItem.h
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterTitleItem : UIView
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UILabel* cacheCountLabel;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, weak)UIButton* cacheButton;

- (void)updateProgress:(NSString*)text;
- (void)setViewStyle;

@end

NS_ASSUME_NONNULL_END
