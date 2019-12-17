//
//  JUDIAN_READ_ChapterEndTipCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/27.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBlock)(_Nullable id args);


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterEndTipCell : UICollectionViewCell
@property(nonatomic, weak)UILabel* tipLabel;
@property(nonatomic, copy)touchBlock block;
@end

NS_ASSUME_NONNULL_END
