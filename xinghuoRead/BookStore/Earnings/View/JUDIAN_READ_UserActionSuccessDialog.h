//
//  JUDIAN_READ_UserActionSuccessDialog.h
//  xinghuoRead
//
//  Created by judian on 2019/7/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserActionSuccessDialog : UIView
+ (void)createPromptView:(UIView*)container count:(NSString*)count title:(NSString*)title block:(modelBlock)block;
@end

NS_ASSUME_NONNULL_END
