//
//  JUDIAN_READ_NovelChapterCatalogViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_NovelSummaryModel.h"


typedef void(^selectItemBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelChapterCatalogView : UIControl
@property(nonatomic, copy)selectItemBlock block;
- (instancetype)initWithModel:(JUDIAN_READ_NovelSummaryModel*)model controller:(UIViewController*)viewController;
- (void)showView;
@end

NS_ASSUME_NONNULL_END
