//
//  JUDIAN_READ_ArticlePositiveView.h
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_FictionEmbeddedAdManager.h"
#import "JUDIAN_READ_ChapterContentModel.h"
#import "JUDIAN_READ_ContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ArticlePositiveViewController : UIViewController
@property(nonatomic, weak)JUDIAN_READ_ContentView* contentView;
@property(nonatomic, strong)JUDIAN_READ_ChapterContentModel* model;
- (instancetype)initWith:(NSInteger)pageIndex adManager:(JUDIAN_READ_FictionEmbeddedAdManager*)adManager model:(JUDIAN_READ_ChapterContentModel*)model bookId:(NSString*)bookId;

- (NSInteger)getPageIndex;
- (void)setPageIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
