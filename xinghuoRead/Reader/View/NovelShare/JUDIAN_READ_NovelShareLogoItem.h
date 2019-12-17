//
//  JUDIAN_READ_NovelShareLogoItem.h
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonClickBlock)(_Nonnull id cmd);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelShareLogoItem : UIView
@property(nonatomic, weak)UIView* bottomLineView;
@property(nonatomic, copy)buttonClickBlock block;
- (instancetype)initWithIndex:(NSInteger)index;
- (void)setViewStyle;
@end

NS_ASSUME_NONNULL_END
