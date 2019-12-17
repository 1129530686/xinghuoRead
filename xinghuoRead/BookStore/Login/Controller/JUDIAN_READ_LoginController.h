//
//  JUDIAN_READ_LoginController.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/28.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_LoginController : JUDIAN_READ_BaseViewController

@property (nonatomic,assign) BOOL  isPhoneLogin;
@property (nonatomic,assign) BOOL  isBind;
@property (nonatomic,copy) VoidBlock  bindSuccess;
@property (nonatomic,assign) BOOL  isFromweChatLogin;

@property (nonatomic,strong) id  vcString;

@end

NS_ASSUME_NONNULL_END
