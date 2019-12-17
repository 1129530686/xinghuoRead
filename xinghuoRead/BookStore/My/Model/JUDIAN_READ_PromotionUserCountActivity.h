//
//  JUDIAN_READ_PromotionUserCountActivity.h
//  xinghuoRead
//
//  Created by judian on 2019/7/12.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JUDIAN_READ_PromotionMessageModel : NSObject
@property(nonatomic, copy)NSString* id;
@property(nonatomic, copy)NSString* title;
@end


@interface JUDIAN_READ_PromotionUserCountActivity : NSObject

@property(nonatomic, copy)NSString* coin;
@property(nonatomic, copy)NSString* count;
@property(nonatomic, copy)NSArray* message;
@property(nonatomic, copy)NSString* slogan;

+ (void)buildActivityModel:(modelBlock)block;
@end

NS_ASSUME_NONNULL_END
