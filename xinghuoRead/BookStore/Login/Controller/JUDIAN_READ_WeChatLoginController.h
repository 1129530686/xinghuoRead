//
//  JUDIAN_READ_WeChatLoginController.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/15.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_WeChatLoginController : JUDIAN_READ_BaseViewController

@property (nonatomic,strong) NSString  *vcString;
@property (nonatomic,copy) VoidBlock  loginSuccess;

@end

NS_ASSUME_NONNULL_END
