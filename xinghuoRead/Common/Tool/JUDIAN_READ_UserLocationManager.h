//
//  JUDIAN_READ_UserLocationManager.h
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationBlock)(_Nullable id arg1, _Nullable id arg2, _Nullable id arg3);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserLocationManager : NSObject
@property(nonatomic, weak)UIViewController* viewController;
@property(nonatomic, copy)locationBlock simpleLocationBlock;
@property(nonatomic, copy)locationBlock detailLocationBlock;
@property(nonatomic, copy)locationBlock errorLocationBlock;
- (void)startLocationService;
@end

NS_ASSUME_NONNULL_END
