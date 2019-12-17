//
//  JUDIAN_READ_APIRequest.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_MainViewController.h"
#import "JUDIAN_READ_BaseNavgationController.h"
#import "JUDIAN_READ_HDeviceIdentifier.h"

@interface JUDIAN_READ_APIRequest ()<CustomAlertViewDelegate>

@end

@implementation JUDIAN_READ_APIRequest

+ (void)POST:(NSString *)path params:(NSDictionary *)params isNeedNotification:(BOOL)isNeed completion:(void (^)(NSDictionary *response, NSError *error))completion{
    
#if 0
    dispatch_async(dispatch_get_main_queue(), ^{
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!app.isHaveNet) {
            if (isNeed) {
                [MBProgressHUD hideHUD];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BadNet" object:self];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:APP_NO_NETWORK_TIP toView:kKeyWindow];
            }
        }else{
            [self reachManagerPOST:path params:params completion:completion];
        }
    });
#endif
    
    [self reachManagerPOST:path params:params completion:completion];

}


+ (void)reachManagerPOST:(NSString *)path params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    
    NSInteger timeout = 20;
    if ([path containsString:@"iap-update"] || [path containsString:@"iap-update-reward"]) {
        timeout = 40;
    }
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeout;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    
    NSMutableString *requestPath = [NSMutableString stringWithString:API_HOST_NAME];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [self configManager:manager requestpath: requestPath path:path paras:parDic params:params];
    
    [manager POST:requestPath parameters:parDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSInteger code = [responseObject[@"status"] integerValue];
        if (code == YES) {
            if ([responseObject[@"data"] count]) {
                NSDictionary *data = responseObject[@"data"][@"list"];
                NSDictionary *data1 = responseObject[@"data"][@"info"];
                NSInteger count1 = 10;
                NSInteger count2 = 10;
                if ([data1 respondsToSelector:@selector(count)]) {
                    count1 = [data1 count];
                }
                if ([data respondsToSelector:@selector(count)]) {
                    count2 = [data count];
                }
                if ((!count1 && count2 == 10) || (!count2 && count1 == 10) )  {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:self];
                    completion(responseObject, nil);
                    return;
                }
            }
            completion(responseObject, nil);
        }else {
            NSInteger status = [responseObject[@"err_code"] integerValue];
            if (status == 107) {//token失效
                NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:status userInfo:@{@"NSLocalizedDescription":responseObject[@"err_msg"]}];
                completion(nil, error);
                [self loginAgain];
                return;
            }
            if (status == 109) {//手机号已被绑定
                NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:status userInfo:@{@"NSLocalizedDescription":responseObject[@"err_msg"]}];
                completion(nil, error);
                return;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:self];
            if (responseObject[@"err_msg"]) {
                [MBProgressHUD showError:responseObject[@"err_msg"] toView:kKeyWindow];
                NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:code userInfo:@{@"NSLocalizedDescription":responseObject[@"err_msg"]}];
                completion(nil, error);
            }else{
                [MBProgressHUD showError:@"系统繁忙，请稍后重试" toView:kKeyWindow];
                NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:code userInfo:@{@"NSLocalizedDescription":@"系统繁忙，请稍后再试"}];
                completion(nil, error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        completion(nil,error);
        //NSString* message = error.userInfo[@"NSLocalizedDescription"];
        //if ([message containsString:@"断开"] || [message containsString:@"offline"])
        if(error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BadNet" object:@{
                                                                                              @"cmd":@"netError"
                                                                                              }];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:nil];
            });
        }
    }];
}




+ (void)configManager:(AFHTTPSessionManager *)manager requestpath:(NSMutableString *)requestPath path:(NSString *)path paras:(NSMutableDictionary *)parDic params:(NSDictionary *)params{
    //设置路径
    [requestPath appendString:path];
    
    //https请求策略设置
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    [manager setSecurityPolicy:securityPolicy];
    
    //添加参数
    NSString *token = [JUDIAN_READ_Account currentAccount].token;
    NSString *auth = [NSString stringWithFormat:@"%@",token];
    if (auth.length && ![auth isEqualToString:@"(null)"]) {
        [parDic setObject:auth forKey:@"token"];
    }
    
    NSString *deviceIdentifier = [JUDIAN_READ_HDeviceIdentifier deviceIdentifier];
    if (deviceIdentifier) {
        [parDic setObject:deviceIdentifier forKey:@"device_id"];
    }
    
    [parDic setObject:@"3" forKey:@"version"];
    [parDic setObject:@"appstore" forKey:@"publish_channel"];
    
    if (params.count) {
        [parDic addEntriesFromDictionary:params];
    }
    
}





+ (void)downloadFile:(NSString*)downloadUrl path:(NSString*)path  progress:(void (^)(CGFloat progress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))handler {
    
    NSString* completePath = [[self class] makePath:path];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //开始请求下载
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress.fractionCompleted * 100);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString* cachePath = [completePath stringByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:cachePath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        if(handler) {
            handler(response, filePath, error);
        }
    }];
    
    [downloadTask resume];
}



+ (NSString*)makePath:(NSString*)pathName {
    
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // 在Document目录下创建文件夹
    NSString *newPath = [documentPath stringByAppendingPathComponent:pathName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isPath = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:newPath isDirectory:&isPath];
    if (!(isPath && existed)) {
        // 在Document目录下创建一个目录
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return newPath;
}



+ (void)loginAgain{
    if (![JUDIAN_READ_Account currentAccount].token) {
        return;
    }
    JUDIAN_READ_CustomAlertView *view = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:@"下线通知" message:@"您的账号在另一设备登录，您被迫下线。" leftButtonTitle:@"重新登录" rightButtonTitle:@"确定"];
    [JUDIAN_READ_Account deleteCurrentAccount];
//    [JUDIAN_READ_Account currentAccount].token = nil;
    view.textAlignment = NSTextAlignmentLeft;
    view.messageColor = kColor100;
    JUDIAN_READ_APIRequest *re = [[JUDIAN_READ_APIRequest alloc]init];
    view.strongDelegate = re;
}

- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index{
    if (index == 0) {
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        JUDIAN_READ_MainViewController *root =  (JUDIAN_READ_MainViewController *)app.window.rootViewController;
        
        if ([root isKindOfClass:[JUDIAN_READ_MainViewController class]]) {
            UINavigationController *navc = root.selectedViewController;
            JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
            [navc pushViewController:loginVC animated:YES];
        }
    }else{
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        JUDIAN_READ_MainViewController *root =  (JUDIAN_READ_MainViewController *)app.window.rootViewController;
        [root.navigationController popViewControllerAnimated:YES];
        if ([root isKindOfClass:[JUDIAN_READ_MainViewController class]] && root.viewControllers.count > 2) {
            root.selectedIndex = 2;
        }
    }
}


+ (void)getImageFileSize:(UIImage *)image {
    NSData *data =nil;
    data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
}


+ (void)uploadImage:(NSString *)path params:(NSDictionary *)params image:(id)image completion:(void (^)(NSDictionary *responseObject, NSError *error))completio {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableString *requestPath;
    requestPath = [NSMutableString stringWithString:API_HOST_NAME];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [self configManager:manager requestpath: requestPath path:path paras:parDic params:params];
    

    [manager POST:requestPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString* mineType = @"image/jpeg";
        NSString* extName = @"jpg";
        NSData * data = UIImageJPEGRepresentation(image, 0.5);
        if (!data) {//不是jpg，就是png
            data = UIImagePNGRepresentation(image);
            mineType = @"image/png";
            extName = @"png";
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", str, extName];

        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mineType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"上传成功 %@", responseObject);
        if (completio) {
            completio(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"上传失败 %@", error);
        if (completio) {
            completio(nil, error);
        }
    }];
    
}








@end

