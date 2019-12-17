//
//  JUDIAN_READ_InviteFriendModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/12.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_InviteFriendModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *nickname;
@property (nonatomic,copy) NSString  *sex;
@property (nonatomic,copy) NSString  *status;
@property (nonatomic,copy) NSString  *source;
@property (nonatomic,copy) NSString  *regType;
@property (nonatomic,copy) NSString  *createTime;
@property (nonatomic,copy) NSString  *createDate;
@property (nonatomic,copy) NSString  *updateTime;
@property (nonatomic,copy) NSString  *headImg;
@property (nonatomic,copy) NSString  *uidb;
@property (nonatomic,copy) NSString  *pages;


@end

NS_ASSUME_NONNULL_END
