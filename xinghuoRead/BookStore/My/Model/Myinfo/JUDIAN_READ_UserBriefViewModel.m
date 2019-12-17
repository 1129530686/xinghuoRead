//
//  JUDIAN_READ_UserBriefViewModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserBriefViewModel.h"
#import "JUDIAN_READ_APIRequest.h"

@implementation JUDIAN_READ_UserBriefViewModel

@end



@implementation JUDIAN_READ_UserBriefModel


+ (void)buildModel:(modelBlock)block {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/query-home-info" params:@{@"isself" : @"1"} isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionary = response[@"data"][@"info"];
        JUDIAN_READ_UserBriefModel* model = [JUDIAN_READ_UserBriefModel yy_modelWithJSON:dictionary];
        if (model.province.length > 0 && [model.province isEqualToString:model.city]) {
            model.area = model.province;
        }
        else {
            if(model.province.length > 0 && model.city.length > 0) {
                model.area = [NSString stringWithFormat:@"%@%@%@", model.province,_MIDDLE_CIRCLE_DOT_, model.city];
            }
            else {
                model.area = @"";
            }
        }
        
        if (block) {
            block(model);
        }
    }];

}


- (void)updateSex:(NSString*)name {
    if ([name isEqualToString:@"女"]) {
        _sex = @(2);
    }
    else if ([name isEqualToString:@"男"]) {
        _sex = @(1);
    }
}


- (NSString*)getSexName {

    if (_sex.intValue == 1) {
        return @"男";
    }
    
    if (_sex.intValue == 2) {
        return @"女";
    }
    
    return @"未知";
}


- (void)saveUserBriefModel:(modelBlock)block viewController:(UIViewController*)viewController isFirst:(BOOL)isFirst {
    
    if (!_age) {
        _age = @"";
    }
    
    if (!_birthday) {
        _birthday = @"";
    }
    
    if (!_area) {
        _area = @"";
    }
    
    if (!_wxNo) {
        _wxNo = @"";
    }

    if (!_nickname) {
        _nickname = @"";
    }
    
    if (!_sex) {
        _sex = @(0);
    }
    
    if (!_profession) {
        _profession = @"";
    }
    
    if (!_personProfile) {
        _personProfile = @"";
    }
    
    if (!_deliveryAddr) {
        _deliveryAddr = @"";
    }
    
    NSString* province = @"";
    NSString* city = @"";
    
    
    NSRange range = [_area rangeOfString:_MIDDLE_CIRCLE_DOT_];
    if (range.length > 0) {
        province = [_area substringToIndex:range.location];
        city = [_area substringFromIndex:range.location + 1];
    }
    else {
        if ([_area containsString:@"北京"] || [_area containsString:@"上海"] || [_area containsString:@"天津"] || [_area containsString:@"天津"]) {
            province = _area;
            city = _area;
        }
    }

    

    NSDictionary* dictionary = @{
      @"isFirst" : @(isFirst),
      @"age" : _age,
      @"nickname" : _nickname,
      @"sex" : _sex,
      @"birthday" : _birthday,
      @"wx_no" : _wxNo,
      @"new_signature" : _personProfile,
      @"province" : province,
      @"city" : city,
      @"area" : @"",
      @"professional" : _profession
      };
    

    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/update-person-info" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* status = response[@"status"];
        NSNumber* coins = response[@"data"][@"info"][@"coins"];
        if (coins.intValue > 0) {
            NSString* tip = [NSString stringWithFormat:@"恭喜你获得%ld元宝", coins.integerValue];
            [MBProgressHUD showTipWithImage:tip image:[UIImage imageNamed:@"ingots_toast_tip"] toVc:viewController];
        }
        else {
            [MBProgressHUD showMessage:@"保存成功"];
        }
        
        if (block) {
            block(status);
        }
    }];
    
    
}


@end



@implementation JUDIAN_READ_UserDeliveryAddressModel


+ (void)buildDeliveryAddressModel:(modelBlock)block {
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length <= 0) {
        return;
    }
   
    NSDictionary* dictionary = @{@"uid_b" : uid};
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/query-delivery-addr" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSArray* array = response[@"data"][@"list"];
        array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserDeliveryAddressModel class] json:array];
        if (block) {
            block(array);
        }
    }];
}




- (void)saveDeliveryAddress:(modelBlock)block isAdd:(BOOL)isAdd {

    if(!_privince) {
        _privince = @"";
    }
    
    if(!_city) {
        _city = @"";
    }
    
    if(!_area) {
        _area = @"";
    }
    
    
    if(!_uid_b) {
        _uid_b = @"";
    }
 
    if(!_user_name) {
        _user_name = @"";
    }
    
    
    if(!_phone_no) {
        _phone_no = @"";
    }

    if(!_default_addr) {
        _default_addr = @(0);
    }
    
    if(!_detailed_addr) {
        _detailed_addr = @"";
    }
    
    if (!_id) {
        _id = @(0);
    }
    
    
    NSDictionary* dictionary = @{
                                 @"isAdd" : @(isAdd),
                                 @"privince": _privince,
                                 @"city" : _city,
                                 @"area" : _area,
                                 @"uid_b" : _uid_b,
                                 @"id" : _id,
                                 @"user_name" : _user_name,
                                 @"phone_no" : _phone_no,
                                 @"default_addr" : _default_addr,
                                 @"detailed_addr" : _detailed_addr
                                 };
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/addOrUpdate-delivery-addr" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* status = response[@"status"];
        if (block) {
            block(status);
        }
    }];
    
    
}



- (void)deleteAddress:(modelBlock)block {
    
    if (!_id) {
        _id = @(0);
    }
    
    if(!_uid_b) {
        _uid_b = @"";
    }
    
    NSDictionary* dictionary = @{

                                 @"uid_b" : _uid_b,
                                 @"id" : _id,

                                 };
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/delete-delivery-addr" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* status = response[@"status"];
        if (block) {
            block(status);
        }
    }];
    
}





@end




