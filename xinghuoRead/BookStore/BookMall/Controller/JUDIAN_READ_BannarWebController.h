//
//  JUDIAN_READ_BannarWebController.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/13.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseViewController.h"
#import "JUDIAN_READ_AbstractViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BannarWebController : JUDIAN_READ_AbstractViewController

@property (nonatomic,strong) NSString  *url;
- (void)loadData;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
