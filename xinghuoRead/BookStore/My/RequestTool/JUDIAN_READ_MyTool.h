//
//  JUDIAN_READ_MyTool.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#define LoginOut @"/appprogram/user/logout"
#define PersonInfo @"/appprogram/user-info/person-info"
#define SignIn @"/appprogram/user/signin"
#define SigninList @"/appprogram/user/signin-list"
#define goldCoinReward @"/appprogram/user-capital/goldcoin-reward"
#define LoginInWithThirdUrl @"/appprogram/login/signin"
#define LoginInWithPhoneUrl @"/appprogram/login/mobile-login"
#define VersionUrl @"/appprogram/static/version-update"
#define GetSuggestionDesc @"/appprogram/system/user-suggest-description"
#define UploadSuggetionUrl @"/appprogram/user-behavior/suggest"
#define SendCodeUrl @"/appprogram/sms/send"
#define ReadPreferenceUrl @"/appprogram/user-behavior/read-preference"
#define AboutUsUrl @"/appprogram/system/user-about-us"
#define TaskUrl @"/appprogram/user-behavior/video-watch-list"
#define GetPreferenceUrl @"/appprogram/user-behavior/preference-sex"
#define BindPhoneUrl @"/appprogram/user-bind/mobile"
#define BindWeChatUrl @"/appprogram/user-bind/wechat"
#define ChangeBindPhoneUrl @"/appprogram/user-bind/mobile-replace"
#define ChargeType @"/appprogram/user-recharge/list"
#define CreateOrder @"/appprogram/order/create"
#define UpdateAppPay @"/appprogram/order/iap-update"
#define BuyRecordUrl @"/appprogram/user-vip/person-vip"
#define UploadLookUrl @"/appprogram/user-behavior/V2/video-watch-add"
#define CacheRecordUrl @"/appprogram/user-read/person-download"
#define checkMobileUrl @"/appprogram/user-bind/check-mobile"
#define ReadSortUrl @"/appprogram/user/query-yesterday-rank"
#define MyCoinListtUrl @"/appprogram/user/query-golds-detail"
#define UserHomeUrl @"/appprogram/user/query-home-info"
#define UserRecentReadUrl @"/appprogram/fiction/show-recent-books"
#define UserCommonReadUrl @"/appprogram/fiction//show-common-books"
#define InviteCodeUrl @"/appprogram/share/assignRewardPhone"
#define InviteFriendListUrl @"/appprogram/share/getInvitationRecord"
#define GuestInfoUrl  @"/guest/info"
#define GuestChargeListUrl  @"/guest/guestRechargeList"
#define InputCodeUrl @"/appprogram/invitation/person-info"
#define ReplyUrl @"/appprogram/user-suggest/show"


@interface JUDIAN_READ_MyTool : JUDIAN_READ_BaseModel

// 退出登录
+ (void)loginOutWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

// 用户个人信息
+ (void)getUserInfoWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

// 用户签到
+ (void)getUserSignWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

// 用户已签到列表
+ (void)getUserSignListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

// 金币奖励列表
+ (void)getgoldCoinRewardListWithParams:(NSDictionary *)paraDic pageCount:(NSInteger)page completionBlock:(CompletionBlock)finishblock;

//微信登录
+ (void)loginInWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//手机号登录
+ (void)loginInWithPhoneParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//获取验证码
+ (void)getPhoneCodeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//个人偏好
+ (void)userPreferenceParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//版本获取
+ (void)getVersionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//意见反馈-描述信息
+ (void)getSuggestionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//意见反馈
+ (void)upLoadSuggestionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//关于我们
+ (void)getAboutUsWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//福利任务
+ (void)getTaskWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//阅读偏好获取
+ (void)getUserPreferenceWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//绑定手机
+ (void)bindPhoneWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//更换绑定手机号
+ (void)changeBindPhoneWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//绑定微信
+ (void)bindWechatWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//支付会员类型
+ (void)getChargeTypeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//创建订单
+ (void)createOrderWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//苹果内购-状态更新
+ (void)updateAppPayWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//用户会员购买记录
+ (void)getBuyRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//福利任务上报
+ (void)uploadLookRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//缓存记录
+ (void)getCacheRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//手机号校验
+ (void)checkMobileWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//1.0临时购买vip产品接口
+ (void)uploadVipStatusWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;


//1.1
//昨日阅读排名
+ (void)getReadSortListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//我的金币明细
+ (void)getMyCoinListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//用户个人主页
+ (void)getUserHomeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//邀请码匹配
+ (void)InputCodeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//最近阅读
+ (void)getUserRecentBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//共同阅读
+ (void)getUserCommonBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//输入邀请码
+ (void)inputInviteCodeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//邀请好友列表
+ (void)getInviteFriendListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//游客充值记录查询
+ (void)getGuestChargeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

+ (void)getReplyListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;


@end

NS_ASSUME_NONNULL_END
