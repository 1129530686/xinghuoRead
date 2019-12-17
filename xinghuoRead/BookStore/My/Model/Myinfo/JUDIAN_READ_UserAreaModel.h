//
//  JUDIAN_READ_UserAreaModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAreaModel : NSObject
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSArray<JUDIAN_READ_UserAreaModel*>* children;
@end




NS_ASSUME_NONNULL_END
