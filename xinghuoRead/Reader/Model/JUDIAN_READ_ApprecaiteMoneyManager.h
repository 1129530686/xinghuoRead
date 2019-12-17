//
//  JUDIAN_READ_ApprecaiteMoneyManager.h
//  xinghuoRead
//
//  Created by judian on 2019/7/20.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ApprecaiteMoneyManager : NSObject
@property(nonatomic, copy)modelBlock block;
@property(nonatomic, assign)BOOL isOnlyOneAppreciate;
- (instancetype)initWithView:(UIView*)view;
- (void)appreciateMoney:(NSDictionary*)dictionary source:(NSString*)source;

@end

NS_ASSUME_NONNULL_END
