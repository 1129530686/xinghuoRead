//
//  JUDIAN_READ_VersionModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_VersionModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *force_update;


/**
 
 "data":{
 "info":{
 "content":"1.修复bug\n2.Ui界面升级\n3.增加分享功能",
 "version":"1.0.0",
 "url":"https://wnzsapp.oss-cn-shanghai.aliyuncs.com/apk/1.0.0.apk",
 "force_update":0
 }
 
 */


@end

NS_ASSUME_NONNULL_END
