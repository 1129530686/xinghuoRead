//
//  JUDIAN_READ_NovelDescriptionViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelDescriptionViewController : JUDIAN_READ_BaseViewController
+ (void)enterDescription:(UINavigationController*)sourceViewController bookId:(NSString*)bookId bookName:(NSString*)bookName viewName:(NSString*)viewName;
@end

NS_ASSUME_NONNULL_END
