//
//  JUDIAN_READ_UserRateBookModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserRateBookModel : NSObject

/*
 avgScore = "7.5";
 deviceId = "<null>";
 evaluateScore = 0;
 "evaluate_users" = 10;
 id = 0;
 nid = "<null>";
 uidb = "<null>";
 
 */
@property(nonatomic, copy)NSString* avgScore;
@property(nonatomic, copy)NSString* deviceId;
@property(nonatomic, copy)NSNumber* evaluateScore;
@property(nonatomic, copy)NSNumber* evaluate_users;

+ (void)buildRateModel:(modelBlock)block bookId:(NSString*)bookId;
@end

NS_ASSUME_NONNULL_END
