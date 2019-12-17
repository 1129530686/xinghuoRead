//
//  JUDIAN_READ_MyTool.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_MyTool.h"
#import "JUDIAN_READ_Account.h"
#import "JUDIAN_READ_SignListModel.h"
#import "JUDIAN_READ_GoldCoinModel.h"
#import "JUDIAN_READ_TaskModel.h"
#import "JUDIAN_READ_VipModel.h"
#import "JUDIAN_READ_BuyRecordModel.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_ReadRankModel.h"
#import "JUDIAN_READ_GoldCoinListModel.h"
#import "JUDIAN_READ_GoldCoinModel.h"
#import "JUDIAN_READ_InviteFriendModel.h"
#import "JUDIAN_READ_NovelSummaryModel.h"

@implementation JUDIAN_READ_MyTool

// 退出登录
+ (void)loginOutWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:LoginOut params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            [JUDIAN_READ_Account deleteCurrentAccount];
            finishblock(@"退出成功",nil);
        }
    }];
}

// 用户个人信息
+ (void)getUserInfoWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (token.length <= 0) {
        return;
    }
    
    [JUDIAN_READ_APIRequest POST:PersonInfo params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            JUDIAN_READ_Account *account = [JUDIAN_READ_Account yy_modelWithJSON:dic];
            JUDIAN_READ_Account *account1 = [JUDIAN_READ_Account currentAccount];
            account.token = account1.token;
            [JUDIAN_READ_Account saveCurrentAccount:account];
            finishblock([account yy_modelCopy],nil);
        }
    }];
}

// 用户签到
+ (void)getUserSignWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:SignIn params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
        }
    }];
}

// 用户已签到列表
+ (void)getUserSignListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:SigninList params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            JUDIAN_READ_SignListModel *model = [JUDIAN_READ_SignListModel yy_modelWithJSON:dic];
            finishblock([model yy_modelCopy],nil);
        }
    }];
}

// 金币奖励列表
+ (void)getgoldCoinRewardListWithParams:(NSDictionary *)paraDic pageCount:(NSInteger)page completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:SigninList params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_GoldCoinModel *model = [JUDIAN_READ_GoldCoinModel yy_modelWithJSON:dic];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
    
}

//微信登录
+ (void)loginInWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:LoginInWithThirdUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            JUDIAN_READ_Account *account = [JUDIAN_READ_Account yy_modelWithJSON:dic];
            [JUDIAN_READ_Account saveCurrentAccount:account];
            finishblock([account yy_modelCopy],nil);
        }
    }];
}

//手机号登录
+ (void)loginInWithPhoneParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:LoginInWithPhoneUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            JUDIAN_READ_Account *account = [JUDIAN_READ_Account yy_modelWithJSON:dic];
            [JUDIAN_READ_Account saveCurrentAccount:account];
            finishblock([account yy_modelCopy],nil);
           
        }
    }];
}

//获取验证码
+ (void)getPhoneCodeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:SendCodeUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(response[@"status"],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//个人偏好
+ (void)userPreferenceParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ReadPreferenceUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(response[@"status"],nil);
        }
    }];
}


//获取版本
+ (void)getVersionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:VersionUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
        }
    }];
    
}

//意见反馈-描述信息
+ (void)getSuggestionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:GetSuggestionDesc params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSString *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
        }
    }];
}

//意见反馈
+ (void)upLoadSuggestionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:UploadSuggetionUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"提交平台",nil);
        }
    }];
}

//关于我们
+ (void)getAboutUsWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:AboutUsUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
        }
    }];
}

//福利任务
+ (void)getTaskWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:TaskUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_TaskModel *model = [JUDIAN_READ_TaskModel yy_modelWithJSON:dic];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}


+ (void)getUserPreferenceWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:GetPreferenceUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
            
        }
    }];
}

//绑定手机
+ (void)bindPhoneWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BindPhoneUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"绑定成功",nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//更换绑定手机号
+ (void)changeBindPhoneWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ChangeBindPhoneUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"更换成功",nil);
        }else{
            finishblock(nil,error);
        }

    }];
    
}

//绑定微信
+ (void)bindWechatWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BindWeChatUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"绑定成功",nil);
        }else{
            finishblock(nil,error);
        }
    }];
    
}
//支付会员类型
+ (void)getChargeTypeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ChargeType params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_VipModel *model = [JUDIAN_READ_VipModel yy_modelWithJSON:dic];
                model.desc = dic[@"description"];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//创建订单
+ (void)createOrderWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:CreateOrder params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
        }
    }];
}


//苹果内购-状态更新
+ (void)updateAppPayWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:UpdateAppPay params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"支付成功",nil);
        }else{
            finishblock(nil,error);
        }
    }];
}


//用户会员购买记录
+ (void)getBuyRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BuyRecordUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BuyRecordModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//福利任务上报
+ (void)uploadLookRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:UploadLookUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
           NSNumber* gold = response[@"data"][@"info"][@"gold"];
           NSString* goldStr = [NSString stringWithFormat:@"%ld", gold.integerValue];
            finishblock(goldStr, nil);
        }else{
            finishblock(nil,error);
        }
    }];
    
}


//缓存记录列表
+ (void)getCacheRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:CacheRecordUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_ReadListModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

+ (void)checkMobileWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:checkMobileUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"校验成功",nil);
        }else{
            finishblock(nil,error);
        }
    }];
}


//1.0临时购买vip产品接口
+ (void)uploadVipStatusWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:GuestInfoUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            JUDIAN_READ_Account *account = [JUDIAN_READ_Account yy_modelWithJSON:dic];
            JUDIAN_READ_Account *account1 = [JUDIAN_READ_Account currentAccount];
            if (!account1) {
                account1 = [[JUDIAN_READ_Account alloc]init];
            }
            account1.vip_type = account.vip_type;
            account1.fiction_num = account.fiction_num;
            account1.vip_status = account.vip_status;
            account1.start_time = account.start_time;
            account1.end_time = account.end_time;
            [JUDIAN_READ_Account saveCurrentAccount:account1];
            finishblock([account1 yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//昨日阅读排名
+ (void)getReadSortListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ReadSortUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [[NSArray yy_modelArrayWithClass:[JUDIAN_READ_ReadRankModel class] json:response[@"data"][@"list"]] mutableCopy];
            JUDIAN_READ_ReadRankModel *model = [JUDIAN_READ_ReadRankModel yy_modelWithDictionary:response[@"data"][@"info"]];
            if (!model) {
                model = [[JUDIAN_READ_ReadRankModel alloc]init];
            }
            finishblock([arr yy_modelCopy],model);
        }
    }];
}

//我的金币明细
+ (void)getMyCoinListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:MyCoinListtUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [[NSArray yy_modelArrayWithClass:[JUDIAN_READ_GoldCoinListModel class] json:response[@"data"][@"list"]] mutableCopy];
            JUDIAN_READ_GoldCoinModel *model = [JUDIAN_READ_GoldCoinModel yy_modelWithDictionary:response[@"data"][@"info"]];
            if (!model) {
                model = [[JUDIAN_READ_GoldCoinModel alloc]init];
            }
            if (arr.count == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:self];
            }
            finishblock([arr yy_modelCopy],[model yy_modelCopy]);

        }
    }];
}

//用户个人主页
+ (void)getUserHomeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:UserHomeUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            JUDIAN_READ_ReadRankModel *model = [JUDIAN_READ_ReadRankModel yy_modelWithDictionary:response[@"data"][@"info"]];
            finishblock(model,nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//邀请码匹配
+ (void)InputCodeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:InputCodeUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            JUDIAN_READ_ReadRankModel *model = [JUDIAN_READ_ReadRankModel yy_modelWithDictionary:response[@"data"][@"info"]];
            finishblock(model,nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//最近阅读
+ (void)getUserRecentBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:UserRecentReadUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_NovelSummaryModel class] json:response[@"data"][@"list"]];
            finishblock(arr,nil);
        }
    }];
}

//共同阅读
+ (void)getUserCommonBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:UserCommonReadUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_NovelSummaryModel class] json:response[@"data"][@"list"]];
            JUDIAN_READ_ReadListModel *model = arr.firstObject;
            model.total = [NSString stringWithFormat:@"%@",response[@"data"][@"total"]];
            finishblock(arr,nil);
        }
    }];
}


//输入邀请码
+ (void)inputInviteCodeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:InviteCodeUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"绑定成功",nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//邀请好友列表
+ (void)getInviteFriendListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:InviteFriendListUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_InviteFriendModel class] json:response[@"data"][@"list"]];
            JUDIAN_READ_InviteFriendModel *model = arr.firstObject;
            model.pages = response[@"data"][@"pages"];
            finishblock(arr,nil);
        }
    }];
}


//游客充值记录查询
+ (void)getGuestChargeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:GuestChargeListUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BuyRecordModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}


+ (void)getReplyListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ReplyUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BuyRecordModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

@end
