//
//  JUDIAN_READ_AppreciatedChapterListViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/9/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AppreciatedChapterListViewController : JUDIAN_READ_BaseViewController
+ (void)enterUserListViewController:(UINavigationController*)naviagtionViewController bookId:(NSString*)bookId chapterId:(NSString*)chapterId;
@end

NS_ASSUME_NONNULL_END
