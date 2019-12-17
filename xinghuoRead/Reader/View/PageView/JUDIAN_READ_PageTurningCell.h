//
//  JUDIAN_READ_PageTurningCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    kPageTurningShareCmd,
    kPageTurningForwardCmd,
    kPageTurningNextCmd,
    kPageTurningCatalogCmd,
    kPageTurningSuggestCmd,
} PageTurningCmd;

typedef void(^pageTurningBlock)(id args);

@interface JUDIAN_READ_PageTurningCell : UICollectionViewCell
@property(nonatomic, copy)pageTurningBlock block;
- (void)setViewStyle;
@end

NS_ASSUME_NONNULL_END
