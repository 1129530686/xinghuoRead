//
//  JUDIAN_READ_ChildCategoryController.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseViewController.h"
@class JUDIAN_READ_CategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChildCategoryController : JUDIAN_READ_BaseViewController

@property (nonatomic,strong)JUDIAN_READ_CategoryModel   *category;
@property (nonatomic,assign) BOOL  isPublish;


@end

NS_ASSUME_NONNULL_END
