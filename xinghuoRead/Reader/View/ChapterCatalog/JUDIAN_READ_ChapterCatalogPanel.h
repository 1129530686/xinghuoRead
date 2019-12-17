//
//  JUDIAN_READ_ChapterCatalogPanel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_ChapterTitleItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterCatalogPanel : UIView

@property(nonatomic, strong)JUDIAN_READ_ChapterTitleItem* titleItem;

- (instancetype)initWithViewController:(UIViewController*)viewController;

- (void)addToKeyWindow:(UIView*)container;

- (void)showView;

- (void)reloadData:(NSArray*)array clickIndex:(NSInteger)clickIndex;
- (void)removeSelf;
- (void)scrollToTop:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
