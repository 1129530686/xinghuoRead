//
//  JUDIAN_READ_CacheContentModel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/18.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CacheContentModel : NSObject

/*
 "chapnum": "1",
 "title": "第1章 被劈腿，贱人",
 "content":
 */
@property(nonatomic, copy)NSString* chapnum;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* content;
@property(nonatomic, copy)NSNumber* status;

@property(nonatomic, copy)NSNumber* next_chapter;
@property(nonatomic, copy)NSNumber* prev_chapter;
@property(nonatomic, copy)NSArray* pageArray;
@property(nonatomic, copy)NSArray* adViewFrameArray;
@property(nonatomic, copy)NSNumber* totalChap;
@end

NS_ASSUME_NONNULL_END
