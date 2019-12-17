//
//  JUDIAN_READ_APIRequest.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_APIRequest : NSObject

/*
    继承Basetableview or BaseCollectionview的网络请求需设置通知为YES，显示无网环境下的提示UI
 
 */
 + (void)POST:(NSString *)path params:(NSDictionary *)params isNeedNotification:(BOOL)isNeed completion:(void (^)(NSDictionary *response, NSError *error))completion;

+ (void)downloadFile:(NSString*)downloadUrl path:(NSString*)path  progress:(void (^)(CGFloat progress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))handler;

+ (NSString*)makePath:(NSString*)pathName;

+ (void)uploadImage:(NSString *)path params:(NSDictionary *)params image:(id)image completion:(void (^)(NSDictionary *responseObject, NSError *error))completio;

@end

NS_ASSUME_NONNULL_END
