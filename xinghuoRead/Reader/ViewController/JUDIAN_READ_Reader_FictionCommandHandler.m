//
//  JUDIAN_READ_Reader_FictionCommandHandler.m
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_ChapterTitleModel.h"
#import "JUDIAN_READ_BookDetailModel.h"
#import "JUDIAN_READ_APIRequest.h"
#import "MBProgressHUD+Read.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_SuggestView.h"
#import "JUDIAN_READ_AppDelegate.h"



@implementation JUDIAN_READ_Reader_FictionCommandHandler


+ (void)handleCommand:(NSNotification*)obj viewController:(__weak JUDIAN_READ_FictionReadingViewController*)viewController {
    
    NSNumber* cmd = obj.object[@"cmd"];
    
    if ([cmd intValue] == kBackCmd) {
        [viewController.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    if ([cmd intValue] == kDownloadCmd) {
        [viewController prepareDownload];
        return;
    }
    
    
    
    if ([cmd integerValue] == kAppreciateMoneyCmd) {
        [viewController prepareEnterAppreciateMoneyViewController];
        return;
    }
    
    if ([cmd integerValue] == kUserSugguestCmd) {
#if 0
        JUDIAN_READ_SuggestView* view = [[JUDIAN_READ_SuggestView alloc] initWithFrame:viewController.view.frame];
        view.commitBlock = ^(id _Nullable arg1, id _Nullable arg2) {
          
            [JUDIAN_READ_Reader_FictionCommandHandler publishUserSuggestion:arg1];
            
        };
        [viewController.view addSubview:view];
#endif
        return;
    }
    
    
    
    if ([cmd intValue] == kHideStatusViewCmd) {
        [viewController hideStatusView:YES];
        return;
    }
    
    if ([cmd intValue] == kArchiveSettingCmd) {
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
        [viewController hideStatusView:NO];
        return;
    }
    
    if ([cmd intValue] == kChapterContentCmd) {
        [viewController.catalogPanel removeFromSuperview];
        NSString* chapterId = obj.object[@"value"];
        [viewController getFictionChapterContent:chapterId bookId:viewController.bookId direction:DIRECTION_NONE];
        return;
    }
    
    
    if ([cmd intValue] == kToBookStoreCmd) {
        [viewController enterBookStoreViewController];
        return;
    }
    
    if ([cmd intValue] == kChapterSortCmd) {
        
        NSString* chapterId = @"1";
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.isHaveNet){
            NSDictionary* dictionary = [JUDIAN_READ_UserReadingModel getChapterId:viewController.bookId];
            if (dictionary) {
                chapterId = dictionary[@"chapterId"];
            }
        }
        else {
            chapterId = [JUDIAN_READ_UserReadingModel getOfflineChapterIndex:viewController.bookId];
            if (chapterId.length <= 0) {
                chapterId = @"1";
            }
        }
        
        NSString* sortType = obj.object[@"value"];
        NSInteger type = [sortType intValue];
        viewController.chapterList = [viewController.chapterList sortedArrayUsingFunction:compare context:&type];
        
        NSInteger index = 0;
        for (index = 0; index < viewController.chapterList.count; index++) {
            JUDIAN_READ_ChapterTitleModel* model = viewController.chapterList[index];
            if ([model.chapnum isEqualToString:chapterId]) {
                break;
            }
        }
        
        [viewController.catalogPanel reloadData:viewController.chapterList clickIndex:index];
        [viewController.catalogPanel scrollToTop:0];
        return;
    }
    
    
    if ([cmd intValue] == kCatalogCmd) {
        [JUDIAN_READ_Reader_FictionCommandHandler popupCatalogView:viewController];
        return;
    }
    
    
    
    if ([cmd intValue] == kNightCmd) {
        
        BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
        [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = !nightMode;
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
        [viewController updatePageViewController];
        [viewController hideStatusView:NO];
        return;
    }
    
    
    if ([cmd intValue] == kDayLightCmd) {
        [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = 0;
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
        [viewController updatePageViewController];
        [viewController hideStatusView:NO];
        return;
    }
    
    
    if ([cmd intValue] == kMoreCmd) {
        //[viewController.settingView showMenu];
        [viewController addSettingView];
        return;
    }
    
    if ([cmd intValue] == kMenuItemShareCmd) {
       // [viewController.settingView hideView];
       // [viewController.settingView removeBarView];
        
        
        viewController.sharePanel = [[JUDIAN_READ_NovelSharePanel alloc]initWithId:viewController.bookId];
        viewController.sharePanel.frame = viewController.view.bounds;
        [viewController.sharePanel addToKeyWindow:viewController.view];
        [viewController.sharePanel showView];
        
        return;
    }
    
    
    if ([cmd intValue] == kMenuItemIntroductionCmd) {
        [viewController enterFictionDescriptionViewController];
        return;
    }
    
    
    
    if ([cmd intValue] == kMenuItemFeedbackCmd) {
        
        NSString* bookName = obj.object[@"bookName"];
        NSString* chapterName = obj.object[@"chapterName"];
        
        [viewController.settingView removeSelf];
        
        viewController.feedbackPanel = [[JUDIAN_READ_ContentFeedbackPanel alloc]init];
        viewController.feedbackPanel.frame = viewController.view.bounds;
        [viewController.feedbackPanel addToKeyWindow:viewController.view];
        [viewController.feedbackPanel showView];
        [viewController.feedbackPanel setViewStyle];
        
        [viewController.feedbackPanel setFictionInfo:bookName chapterName:chapterName];
        return;
    }
    
    
    if ([cmd intValue] == kCancelFeedbackCmd) {
        [viewController.feedbackPanel removeSelf];
        return;
    }
    
    
    if ([cmd intValue] == kConfrimFeedbackCmd) {
        [JUDIAN_READ_Reader_FictionCommandHandler handleUserFeedback:obj.object];
        
        [viewController.feedbackPanel removeSelf];
        return;
    }
    
    
    
    if ([cmd intValue] == kStyleSettingCmd) {
        [viewController.settingView removeSelf];
        
        viewController.styleSettingPanel = [[JUDIAN_READ_TextStyleSettingPanel alloc]init];
        viewController.styleSettingPanel.frame = viewController.view.bounds;
        [viewController.styleSettingPanel addToKeyWindow:viewController.view];
        
        JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        [viewController.styleSettingPanel adjustButtonStyle:style];
        [viewController.styleSettingPanel showView];
        
        return;
    }
    
    
    if ([cmd intValue] == kLineSpaceCmd) {
        NSNumber* value = obj.object[@"value"];
        
        if ([value intValue] == kLineSpaceSmallTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel adjustSamllLineSpace];
        }
        else if ([value intValue] == kLineSpaceMiddleTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel adjustMiddleLineSpace];
        }
        else if ([value intValue] == kLineSpaceBigTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel adjustBigLineSpace];
        }
        [viewController updatePageViewController];
        return;
    }
    
    if ([cmd intValue] == kBrightnessCmd) {
        
        NSNumber* value = obj.object[@"value"];
        [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.brightness = [value floatValue];
        [viewController setMaskViewBackgroundColor];
        return;
    }
    
    if ([cmd intValue] == kFontSizeCmd) {
        
        NSNumber* value = obj.object[@"value"];
        if ([value intValue] == kSmallFontSizeTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel decreaseFontSize];
        }
        else if ([value intValue] == kBigFontSizeTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel increaseFontSize];
        }
        
        JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        [viewController.styleSettingPanel adjustButtonStyle:style];
        
        [viewController updatePageViewController];
        
        return;
    }
    
    if ([cmd intValue] == kBackgroudColorCmd) {
        
        NSNumber* value = obj.object[@"value"];
        if ([value intValue] == kProtectionEyeTag) {
            NSNumber*isClicked = obj.object[@"isClicked"];
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.eyeMode = [isClicked intValue];
            [viewController showProtectionEyeModeView];
            
            if ([isClicked intValue] > 0) {
                [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"model" value:@"打开"];
            }
            else {
                [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"model" value:@"关闭"];
            }
        }
        else if ([value intValue] == kLightGrayTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.bgColorIndex = kLightGrayIndex;
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = NO;
            [viewController.styleSettingPanel setViewStyle];
            
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"灰色"];
  
        }
        else if ([value intValue] == kLightYellowTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.bgColorIndex = kLightYellowIndex;
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = NO;
            [viewController.styleSettingPanel setViewStyle];
            
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"米黄色"];
            
        }
        else if ([value intValue] == kLightGreenTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.bgColorIndex = kLightGreenIndex;
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = NO;
            [viewController.styleSettingPanel setViewStyle];
            
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"浅绿色"];
        }
        
        
        [viewController updatePageViewController];
        
        return;
    }
    
}


+ (void)publishUserSuggestion:(NSString*)content {

    if (content.length <= 0) {
        return;
    }

    [MobClick event:@"click_setting_reader" attributes:@{@"catalogButton" : @"底部意见反馈按钮"}];
    [GTCountSDK trackCountEvent:@"click_setting_reader" withArgs:@{@"catalogButton" : @"底部意见反馈按钮"}];
    
    
#if 0
    NSString* type = @"7";
    [JUDIAN_READ_Reader_FictionCommandHandler handleUserFeedback:type content:content contact:@""];
#endif
}




+ (void)popupCatalogView:(__weak JUDIAN_READ_FictionReadingViewController*)viewController {

    if (!viewController.catalogPanel) {
        viewController.catalogPanel = [[JUDIAN_READ_ChapterCatalogPanel alloc]initWithViewController:viewController];
    }
    
    viewController.catalogPanel.titleItem.bookId = viewController.bookId;
    viewController.catalogPanel.titleItem.titleLabel.text = viewController.bookName;
    
    viewController.catalogPanel.frame = viewController.view.bounds;
    [viewController.catalogPanel addToKeyWindow:viewController.view];
    [viewController.catalogPanel showView];
    [viewController.catalogPanel.titleItem setViewStyle];
    
    NSString* chapterId = @"1";
    NSDictionary* dictionary = nil;
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isHaveNet){
        dictionary = [JUDIAN_READ_UserReadingModel getChapterId:viewController.bookId];
        if (dictionary) {
            chapterId = dictionary[@"chapterId"];
        }
    }
    else {
        chapterId = [JUDIAN_READ_UserReadingModel getOfflineChapterIndex:viewController.bookId];
        if (chapterId.length <= 0) {
            chapterId = @"1";
        }
    }

    if (viewController.chapterList.count <= 0) {
        
        [[JUDIAN_READ_NovelManager shareInstance] getNovelChapterList:viewController.bookId block:^(id  _Nonnull parameter) {
            viewController.chapterList = [parameter copy];
            [JUDIAN_READ_Reader_FictionCommandHandler updateCatalogueData:viewController chapterId:chapterId];
        } failure:^(id  _Nonnull parameter) {
            
        } isCache:YES];
    }
    else {
        
        [JUDIAN_READ_Reader_FictionCommandHandler updateCatalogueData:viewController chapterId:chapterId];
    }
}




+ (void)updateCatalogueData:(__weak JUDIAN_READ_FictionReadingViewController*)viewController chapterId:(NSString*)chapterId{
    
    NSString* sortType = @"0";
    __block NSInteger type = [sortType intValue];
    
    viewController.chapterList = [viewController.chapterList sortedArrayUsingFunction:compare context:&type];
    
    NSInteger index = 0;
    for (index = 0; index < viewController.chapterList.count; index++) {
        JUDIAN_READ_ChapterTitleModel* model = viewController.chapterList[index];
        if ([model.chapnum isEqualToString:chapterId]) {
            break;
        }
    }
    
    [viewController.catalogPanel reloadData:viewController.chapterList clickIndex:index];
    [viewController.catalogPanel scrollToTop:index];
}





+ (void)addClickEvent:(NSString*)key value:(NSString*)value {
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{key : value,
                                 @"device" : deviceName,
                                 @"sex" : sex
                                 };
    
    [MobClick event:@"click_setting_reader" attributes:dictionary];
    [GTCountSDK trackCountEvent:@"click_setting_reader" withArgs:dictionary];
}





+ (void)shareNovelToOther:(NSNotification*)obj {
    NSNumber* cmd = obj.object[@"cmd"];
    NSString* bookId = obj.object[@"value"];
    NSString* fromView = obj.object[@"fromView"];
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    
    if (!fromView) {
        fromView = @"";
    }
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{@"source" : fromView,
                                 @"device" : deviceName,
                                 @"sex" : sex
                                 };
    [MobClick event:click_share attributes:dictionary];
    [GTCountSDK trackCountEvent:click_share withArgs:dictionary];
    
    
    [JUDIAN_READ_BookMallTool shareBookWithParams:@{@"id" : bookId} completionBlock:^(id result, id error) {
        [JUDIAN_READ_Reader_FictionCommandHandler dispatchShareCmd:cmd model:result];
    }];
    
}



+ (void)dispatchShareCmd:(NSNumber*)cmd model:(JUDIAN_READ_BookDetailModel*)model {
    
    if ([cmd intValue] == kWeixinTag) {
        [MobClick event:@"pv_share_page" attributes:@{@"source":@"微信"}];
        [GTCountSDK trackCountEvent:@"pv_share_page" withArgs:@{@"source":@"微信"}];
        
        [JUDIAN_READ_Reader_FictionCommandHandler shareTextToPlatformType:UMSocialPlatformType_WechatSession model:model];
        return;
    }
    
    if ([cmd intValue] == kFriendTag) {
        [MobClick event:@"pv_share_page" attributes:@{@"source" : @"朋友圈"}];
        [GTCountSDK trackCountEvent:@"pv_share_page" withArgs:@{@"source" : @"朋友圈"}];
        
        [JUDIAN_READ_Reader_FictionCommandHandler shareTextToPlatformType:UMSocialPlatformType_WechatTimeLine model:model];
        return;
    }
    
    if ([cmd intValue] == kQQTag) {
        [MobClick event:@"pv_share_page" attributes:@{@"source":@"QQ好友"}];
        [GTCountSDK trackCountEvent:@"pv_share_page" withArgs:@{@"source" : @"QQ好友"}];
        
        [JUDIAN_READ_Reader_FictionCommandHandler shareTextToPlatformType:UMSocialPlatformType_QQ model:model];
        return;
    }
    
    if ([cmd intValue] == kQQZoneTag) {
        [MobClick event:@"pv_share_page" attributes:@{@"source":@"QQ空间"}];
        [GTCountSDK trackCountEvent:@"pv_share_page" withArgs:@{@"source" : @"QQ空间"}];
        
        [JUDIAN_READ_Reader_FictionCommandHandler shareTextToPlatformType:UMSocialPlatformType_Qzone model:model];
        return;
    }
    
    if ([cmd intValue] == kWeiboTag) {
        [MobClick event:@"pv_share_page" attributes:@{@"source":@"微博"}];
        [GTCountSDK trackCountEvent:@"pv_share_page" withArgs:@{@"source" : @"微博"}];
        
        [JUDIAN_READ_Reader_FictionCommandHandler shareTextToPlatformType:UMSocialPlatformType_Sina model:model];
        return;
    }
    
    if ([cmd intValue] == kCopyLinkTag) {
        [MobClick event:@"pv_share_page" attributes:@{@"source":@"链接"}];
        [GTCountSDK trackCountEvent:@"pv_share_page" withArgs:@{@"source" : @"链接"}];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = model.url;
        [MBProgressHUD showSuccess:@"复制成功"];
        return;
    }
    
    
    
}




+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType model:(JUDIAN_READ_BookDetailModel*)model{
    
    NSString* title = model.bookname;
    NSString* brief = model.brief;
    NSString* url = model.url;
    
    if (title.length <= 0 || brief.length <= 0 || url.length <= 0) {
        return;
    }
    
    if (platformType == UMSocialPlatformType_Sina) {
        title = [NSString stringWithFormat:@"推荐这本精彩的书《%@》——%@", title, brief];
    }
    else if (platformType == UMSocialPlatformType_WechatTimeLine) {
        title = brief;
    }
    
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:brief thumImage: model.cover];
    
    shareObject.webpageUrl = url;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            //UMSocialLogInfo(@"************Share fail with error %@*********",error);
            
            NSString* tip = error.userInfo[@"message"];
            if (tip.length > 0) {
                [MBProgressHUD showMessage:tip];
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                
                if (resp.message.length > 0) {
                    [MBProgressHUD showMessage:resp.message];
                }
                
                //分享结果消息
               // UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                //UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    
}






+ (void)shareQrcodePicture:(UMSocialPlatformType)platformType shareImage:(_Nullable id)shareImage thumbImage:(_Nullable id)thumbImage {

    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = thumbImage;
    [shareObject setShareImage:shareImage];
    messageObject.shareObject = shareObject;

    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            //UMSocialLogInfo(@"************Share fail with error %@*********",error);
            
            NSString* tip = error.userInfo[@"message"];
            if (tip.length > 0) {
                [MBProgressHUD showMessage:tip];
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                
                if (resp.message.length > 0) {
                    [MBProgressHUD showMessage:resp.message];
                }
                
                //分享结果消息
                // UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                //UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
                                          


+ (void)shareFriendLink:(NSString*)cmd url:(NSString*)url slogan:(NSString*)slogan {
    
    if (url.length <= 0 || slogan.length <= 0) {
        return;
    }
    
    UMSocialPlatformType platformType = 0;
    if ([cmd isEqualToString:@"weixin"]) {
        platformType = UMSocialPlatformType_WechatSession;
    }
    else {
        platformType = UMSocialPlatformType_WechatTimeLine;
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = slogan;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            //UMSocialLogInfo(@"************Share fail with error %@*********",error);
            
            NSString* tip = error.userInfo[@"message"];
            if (tip.length > 0) {
                [MBProgressHUD showMessage:tip];
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                
                if (resp.message.length > 0) {
                    [MBProgressHUD showMessage:resp.message];
                }
                
                //分享结果消息
                // UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                //UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                //UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    
}




+ (void)handleUserFeedback:(NSDictionary*)arg {
    
    //(NSString*)catagory content:(NSString*)content contact:(NSString*)contact
    //obj.object
    NSString* catagory = arg[@"type"];
    NSString* content = arg[@"content"];
    NSString* contact = arg[@"contact"];
   
    NSString* bookName = arg[@"bookName"];
    NSString* chapterName = arg[@"chapterName"];
    
    if (bookName.length <= 0 || chapterName.length <= 0 || catagory.length <= 0) {
        return;
    }
    
    NSString* suggest = content;
    if (suggest.length <= 0) {
        suggest = @"";
    }
    
    if (contact.length <= 0) {
        contact = @"";
    }
    
    NSDictionary* dictionary = @{
                                 @"app_version" : GET_VERSION_NUMBER,
                                 @"bookname" : bookName,
                                 @"chapter_title" : chapterName,
                                 @"device_type" : @"iOS",
                                 @"tid_gather" : catagory,
                                 @"content" : suggest,
                                 @"contact" : contact
                                 };
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/feedback/fiction-error" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSString*status = response[@"status"];
        if ([status intValue] == 1) {
            [MBProgressHUD showSuccess:@"提交成功"];
        }
    }];
    
}









NSInteger compare(JUDIAN_READ_ChapterTitleModel* num1, JUDIAN_READ_ChapterTitleModel* num2, void *context) {
    
    int v1 = [num1.chapnum intValue];
    int v2 = [num2.chapnum intValue];
    
    NSInteger* type = (NSInteger*)context;
    
    if (*type == 1) {
        
        if (v1 > v2) {
            return NSOrderedAscending;
        } else if (v1 < v2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    }
    else {
        if (v1 < v2) {
            return NSOrderedAscending;
        } else if (v1 > v2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }
    
    
}


#pragma mark 广告埋点

+ (void)addChuanShanJiaAdEvent:(NSString*)action index:(NSInteger)index {
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    
    if (index == 0) {
        
        NSDictionary* dictionary = @{
          @"device" : deviceName,
          @"source" : @"阅读器页面底部信息流广告"
          };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
    }
    else if(index == 1) {
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面最底部信息流广告"
                                     };
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
    }
    else {

        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面最底部信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
    }

}



+ (void)addGdtAdEvent:(NSString*)action index:(NSInteger)index {
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    
    if (index == 0) {
        NSDictionary* dictionary = @{
                                      @"device" : deviceName,
                                      @"source" : @"阅读器页面顶部信息流广告"
                                      };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];

    }
    else if(index == 1) {
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面中间信息流广告"
                                     };

        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
    }
    else {

        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面顶部信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        

        dictionary = @{
                       @"device" : deviceName,
                       @"source" : @"阅读器页面中间信息流广告"
                       };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
    }

}



+ (void)addVedioAdEvent:(NSString*)action {
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];

    NSDictionary* dictionary = @{
                   @"device" : deviceName,
                   @"source" : @"强制激励视频广告"
                   };
    
    [MobClick event:action attributes:dictionary];
    [GTCountSDK trackCountEvent:action withArgs:dictionary];
    
}





+ (void)addSingleAdEvent:(NSString*)action source:(NSString*)source {
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    
    NSDictionary* dictionary = @{
                                 @"device" : deviceName,
                                 @"source" : source
                                 };
    
    [MobClick event:action attributes:dictionary];
    [GTCountSDK trackCountEvent:action withArgs:dictionary];
}




+ (void)addChuanShanJiaAdEventEx:(NSString*)action index:(NSInteger)index {
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    
    if (index == 0) {
        
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面顶部信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
    }
    else if (index == 1) {

        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面中间信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
        
    }
    else if (index == 2) {
        
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面底部信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];

    }
    else if(index == 3) {
        
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面最底部信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
    }
    else {
        
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"source" : @"阅读器页面顶部信息流广告"
                                     };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
        
        
        dictionary = @{
                       @"device" : deviceName,
                       @"source" : @"阅读器页面中间信息流广告"
                       };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
        
        dictionary = @{
                       @"device" : deviceName,
                       @"source" : @"阅读器页面底部信息流广告"
                       };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
        
        dictionary = @{
                       @"device" : deviceName,
                       @"source" : @"阅读器页面最底部信息流广告"
                       };
        
        [MobClick event:action attributes:dictionary];
        [GTCountSDK trackCountEvent:action withArgs:dictionary];
        
    }
    
}




#pragma mark 仿真阅读界面相关处理
+ (void)handleCommand:(NSNotification*)obj viewController:(__weak JUDIAN_READ_ContentBrowseController*)viewController type:(NSInteger)type {
    
    NSNumber* cmd = obj.object[@"cmd"];
    
    if ([cmd intValue] == kBackCmd) {
        [viewController.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    if ([cmd intValue] == kDownloadCmd) {
        [viewController prepareDownload];
        return;
    }
    
    if ([cmd intValue] == kMoreCmd) {
        [viewController addMoreMenuView];
        return;
    }
    
    if ([cmd integerValue] == kAppreciateMoneyCmd) {
        [viewController prepareEnterAppreciateMoneyViewController];
        return;
    }
    
    if ([cmd integerValue] == kAppreciateChapterListCmd) {
        [viewController enterAppreciatedUserList];
        return;
    }
    
    
    if ([cmd integerValue] == kUserSugguestCmd) {
#if 0
        [viewController.settingView hideView];

        JUDIAN_READ_SuggestView* view = [[JUDIAN_READ_SuggestView alloc] initWithFrame:viewController.view.frame];
        view.commitBlock = ^(id _Nullable arg1, id _Nullable arg2) {
            
            [JUDIAN_READ_Reader_FictionCommandHandler publishUserSuggestion:arg1];
            
        };
        [viewController.view addSubview:view];
#endif
        return;
    }
    
    
    
    if ([cmd intValue] == kHideStatusViewCmd) {
        [viewController hideStatusView:YES];
        return;
    }
    
    if ([cmd intValue] == kArchiveSettingCmd) {
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
        [viewController hideStatusView:YES];
        return;
    }
    
    if ([cmd intValue] == kChapterContentCmd) {
        [viewController.catalogPanel removeFromSuperview];
        NSString* chapterId = obj.object[@"value"];
        [viewController loadFictionContent:chapterId.integerValue refresh:YES isCatalog:TRUE];
        [viewController updateViewStyle];
        return;
    }
    
    
    if ([cmd intValue] == kToBookStoreCmd) {
        [viewController enterBookStoreViewController];
        return;
    }
    
    if ([cmd intValue] == kChapterSortCmd) {
        
        NSString* chapterId = @"1";
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.isHaveNet){
            NSDictionary* dictionary = [JUDIAN_READ_UserReadingModel getChapterId:viewController.bookId];
            if (dictionary) {
                chapterId = dictionary[@"chapterId"];
            }
        }
        else {
            chapterId = [JUDIAN_READ_UserReadingModel getOfflineChapterIndex:viewController.bookId];
            if (chapterId.length <= 0) {
                chapterId = @"1";
            }
        }
        
        NSString* sortType = obj.object[@"value"];
        NSInteger type = [sortType intValue];
        viewController.chapterList = [viewController.chapterList sortedArrayUsingFunction:compare context:&type];
        
        NSInteger index = 0;
        for (index = 0; index < viewController.chapterList.count; index++) {
            JUDIAN_READ_ChapterTitleModel* model = viewController.chapterList[index];
            if ([model.chapnum isEqualToString:chapterId]) {
                break;
            }
        }
        
        [viewController.catalogPanel reloadData:viewController.chapterList clickIndex:index];
        [viewController.catalogPanel scrollToTop:0];
        return;
    }
    
    
    if ([cmd intValue] == kCatalogCmd) {
        [JUDIAN_READ_Reader_FictionCommandHandler popupCatalogView:viewController type:0];
        return;
    }
    
    
    
    if ([cmd intValue] == kNightCmd) {
        
        BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
        [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = !nightMode;
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
        //[viewController updatePageViewController];
        [viewController updatePageStyle];
        [viewController hideStatusView:NO];
        [viewController updateViewStyle];
        return;
    }
    
    
    if ([cmd intValue] == kDayLightCmd) {
        [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = 0;
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
        [viewController updatePageViewController];
        [viewController hideStatusView:NO];
        [viewController updateViewStyle];
        return;
    }
    
    
    if ([cmd intValue] == kMoreCmd) {
        //[viewController.settingView showMenu];
        return;
    }
    
    if ([cmd intValue] == kMenuItemShareCmd) {
        // [viewController.settingView hideView];
        // [viewController.settingView removeBarView];
        [viewController.settingView hideView];
        
        viewController.sharePanel = [[JUDIAN_READ_NovelSharePanel alloc]initWithId:viewController.bookId];
        viewController.sharePanel.frame = viewController.view.bounds;
        [viewController.sharePanel addToKeyWindow:viewController.view];
        [viewController.sharePanel showView];
        
        return;
    }
    
    
    if ([cmd intValue] == kMenuItemIntroductionCmd) {
        [viewController enterFictionDescriptionViewController];
        return;
    }
    
    
    
    if ([cmd intValue] == kMenuItemFeedbackCmd) {
    
        NSString* bookName = obj.object[@"bookName"];
        NSString* chapterName = obj.object[@"chapterName"];
        
        //[viewController.settingView removeSelf];
        
        viewController.feedbackPanel = [[JUDIAN_READ_ContentFeedbackPanel alloc]init];
        viewController.feedbackPanel.frame = viewController.view.bounds;
        [viewController.feedbackPanel addToKeyWindow:viewController.view];
        [viewController.feedbackPanel showView];
        [viewController.feedbackPanel setViewStyle];
        
        [viewController.feedbackPanel setFictionInfo:bookName chapterName:chapterName];
        return;
    }
    
    
    if ([cmd intValue] == kCancelFeedbackCmd) {
        [viewController.feedbackPanel removeSelf];
        return;
    }
    
    
    if ([cmd intValue] == kConfrimFeedbackCmd) {

        [JUDIAN_READ_Reader_FictionCommandHandler handleUserFeedback:obj.object];
        
        [viewController.feedbackPanel removeSelf];
        return;
    }
    
    
    
    if ([cmd intValue] == kStyleSettingCmd) {
        [viewController.settingView hideView];
        viewController.styleSettingPanel = [[JUDIAN_READ_TextStyleSettingPanel alloc]init];
        viewController.styleSettingPanel.frame = viewController.view.bounds;
        [viewController.styleSettingPanel addToKeyWindow:viewController.view];// kKeyWindow
        
        JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        [viewController.styleSettingPanel adjustButtonStyle:style];
        [viewController.styleSettingPanel showView];
        
        return;
    }
    
    
    if ([cmd intValue] == kLineSpaceCmd) {
        NSNumber* value = obj.object[@"value"];
        
        if ([value intValue] == kLineSpaceSmallTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel adjustSamllLineSpace];
        }
        else if ([value intValue] == kLineSpaceMiddleTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel adjustMiddleLineSpace];
        }
        else if ([value intValue] == kLineSpaceBigTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel adjustBigLineSpace];
        }
        //[viewController updatePageViewController];
        [viewController updatePageStyle];
        [viewController updateViewStyle];
        return;
    }
    
    if ([cmd intValue] == kPageStyleCmd) {
        NSNumber* value = obj.object[@"value"];
        
        if ([value intValue] == kStylePageCurlTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.pageStyle = kStylePageCurlIndex;
        }
        else if ([value intValue] == kStylePageScrollTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.pageStyle = kStylePageScrollIndex;
        }
        else if ([value intValue] == kStylePageVerticalTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.pageStyle = kStylePageVerticalIndex;
        }
        else if ([value intValue] == kStylePageCoverTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.pageStyle = kStylePageCoverIndex;
        }

        [viewController updatePageStyle];
        [viewController updateViewStyle];
        return;
    }
    
    if ([cmd intValue] == kBrightnessCmd) {
        
        NSNumber* value = obj.object[@"value"];
        [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.brightness = [value floatValue];
        [viewController setMaskViewBackgroundColor];
        return;
    }
    
    if ([cmd intValue] == kFontSizeCmd) {
        
        NSNumber* value = obj.object[@"value"];
        if ([value intValue] == kSmallFontSizeTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel decreaseFontSize];
        }
        else if ([value intValue] == kBigFontSizeTag) {
            [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel increaseFontSize];
        }
        
        JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        [viewController.styleSettingPanel adjustButtonStyle:style];
        
        //[viewController updatePageViewController];
        [viewController updatePageStyle];
        [viewController updateViewStyle];
        return;
    }
    
    if ([cmd intValue] == kBackgroudColorCmd) {
        
        NSNumber* value = obj.object[@"value"];
        if ([value intValue] == kProtectionEyeTag) {
            NSNumber*isClicked = obj.object[@"isClicked"];
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.eyeMode = [isClicked intValue];
            [viewController showProtectionEyeModeView];
            
            if ([isClicked intValue] > 0) {
                [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"model" value:@"打开"];
            }
            else {
                [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"model" value:@"关闭"];
            }
        }
        else if ([value intValue] == kLightGrayTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.bgColorIndex = kLightGrayIndex;
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = NO;
            [viewController.styleSettingPanel setViewStyle];
            
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"灰色"];
            
        }
        else if ([value intValue] == kLightYellowTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.bgColorIndex = kLightYellowIndex;
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = NO;
            [viewController.styleSettingPanel setViewStyle];
            
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"米黄色"];
            
        }
        else if ([value intValue] == kLightGreenTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.bgColorIndex = kLightGreenIndex;
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = NO;
            [viewController.styleSettingPanel setViewStyle];
            
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"浅绿色"];
        }
        else if ([value intValue] == kLightBlackTag) {
            [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.nightMode = YES;
            [viewController.styleSettingPanel setViewStyle];
            [JUDIAN_READ_Reader_FictionCommandHandler addClickEvent:@"type" value:@"黑色"];
        }
        
        //[viewController updatePageViewController];
        [viewController updatePageStyle];
        [viewController updateViewStyle];
        return;
    }
    
}


+ (void)popupCatalogView:(__weak JUDIAN_READ_ContentBrowseController*)viewController type:(NSInteger)type{
    
    if (!viewController.catalogPanel) {
        viewController.catalogPanel = [[JUDIAN_READ_ChapterCatalogPanel alloc]initWithViewController:viewController];
    }
    
    viewController.catalogPanel.titleItem.bookId = viewController.bookId;
    viewController.catalogPanel.titleItem.titleLabel.text = viewController.bookName;
    
    viewController.catalogPanel.frame = viewController.view.bounds;
    [viewController.catalogPanel addToKeyWindow:viewController.view];
    [viewController.catalogPanel showView];
    [viewController.catalogPanel.titleItem setViewStyle];
    
    NSString* chapterId = @"1";
    NSDictionary* dictionary = nil;
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isHaveNet){
        dictionary = [JUDIAN_READ_UserReadingModel getChapterId:viewController.bookId];
        if (dictionary) {
            chapterId = dictionary[@"chapterId"];
        }
    }
    else {
        chapterId = [JUDIAN_READ_UserReadingModel getOfflineChapterIndex:viewController.bookId];
        if (chapterId.length <= 0) {
            chapterId = @"1";
        }
    }
    
    if (viewController.chapterList.count <= 0) {
        
        [[JUDIAN_READ_NovelManager shareInstance] getNovelChapterList:viewController.bookId block:^(id  _Nonnull parameter) {
            viewController.chapterList = [parameter copy];
            [JUDIAN_READ_Reader_FictionCommandHandler updateCatalogueData:viewController chapterId:chapterId fromType:0];
        } failure:^(id  _Nonnull parameter) {
            
        } isCache:YES];
    }
    else {
        
        [JUDIAN_READ_Reader_FictionCommandHandler updateCatalogueData:viewController chapterId:chapterId fromType:0];
    }
}




+ (void)updateCatalogueData:(__weak JUDIAN_READ_ContentBrowseController*)viewController chapterId:(NSString*)chapterId fromType:(NSInteger)fromType{
    
    NSString* sortType = @"0";
    __block NSInteger type = [sortType intValue];
    
    viewController.chapterList = [viewController.chapterList sortedArrayUsingFunction:compare context:&type];
    
    NSInteger index = 0;
    for (index = 0; index < viewController.chapterList.count; index++) {
        JUDIAN_READ_ChapterTitleModel* model = viewController.chapterList[index];
        if ([model.chapnum isEqualToString:chapterId]) {
            break;
        }
    }
    
    [viewController.catalogPanel reloadData:viewController.chapterList clickIndex:index];
    [viewController.catalogPanel scrollToTop:index];
}











@end
