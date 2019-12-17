//
//  JUDIAN_READ_AppreciateMoneyViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^refreshBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AppreciateMoneyViewController : JUDIAN_READ_BaseViewController
@property(nonatomic, copy)refreshBlock block;
@property(nonatomic, copy)NSString* source;
+ (void)enterAppreciateMoneyViewController:(UINavigationController*)navigation bookId:(NSString*)bookId chapterId:(NSString*)chapterId source:(NSString*)source block:(refreshBlock)block;
@end

NS_ASSUME_NONNULL_END
