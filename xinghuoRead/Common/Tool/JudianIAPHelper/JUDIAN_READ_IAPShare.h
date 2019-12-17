//
//  IAPShare.h
//  ;
//
//  Created by Htain Lin Shwe on 10/7/12.
//  Copyright (c) 2012 Edenpod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_IAPHelper.h"
@interface JUDIAN_READ_IAPShare : NSObject
@property (nonatomic,strong) JUDIAN_READ_IAPHelper *iap;

+ (JUDIAN_READ_IAPShare *) sharedHelper;
+(id)toJSON:(NSString *)json;

- (NSString*)getChargeFilePath:(NSString*)orderId;
- (void)deleteChargeFile:(NSString*)orderId;
- (void)sychronizeChargeHistory;

@end
