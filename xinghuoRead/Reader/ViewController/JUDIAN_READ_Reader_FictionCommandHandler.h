//
//  JUDIAN_READ_Reader_FictionCommandHandler.h
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_ContentBrowseController.h"

#import <UMShare/UMShare.h>
#import <UMCommon/UMConfigure.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_Reader_FictionCommandHandler : NSObject

+ (void)handleCommand:(NSNotification*)obj viewController:(__weak JUDIAN_READ_ContentBrowseController*)viewController type:(NSInteger)type;

+ (void)handleCommand:(NSNotification*)obj viewController:(__weak JUDIAN_READ_FictionReadingViewController*)viewController;
+ (void)shareNovelToOther:(NSNotification*)obj;

+ (void)shareQrcodePicture:(UMSocialPlatformType)platformType shareImage:(_Nullable id)shareImage thumbImage:(_Nullable id)thumbImage;

+ (void)addChuanShanJiaAdEvent:(NSString*)action index:(NSInteger)index;
+ (void)addGdtAdEvent:(NSString*)action index:(NSInteger)index;
+ (void)addVedioAdEvent:(NSString*)action;

+ (void)addChuanShanJiaAdEventEx:(NSString*)action index:(NSInteger)index;

+ (void)addSingleAdEvent:(NSString*)action source:(NSString*)source;
+ (void)shareFriendLink:(NSString*)cmd url:(NSString*)url slogan:(NSString*)slogan;
@end

NS_ASSUME_NONNULL_END
