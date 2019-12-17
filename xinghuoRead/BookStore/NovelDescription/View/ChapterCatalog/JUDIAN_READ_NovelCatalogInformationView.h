//
//  JUDIAN_READ_NovelCatalogInformationView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_NovelSummaryModel.h"

typedef void(^sortBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelCatalogInformationView : UIControl
@property(nonatomic, copy)sortBlock block;
- (void)setTextWithModel:(JUDIAN_READ_NovelSummaryModel*)model;
@end

NS_ASSUME_NONNULL_END
