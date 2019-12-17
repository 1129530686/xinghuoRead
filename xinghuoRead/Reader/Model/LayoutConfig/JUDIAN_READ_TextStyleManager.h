//
//  JUDIAN_READ_LayoutConfigure.h
//  xinghuoRead
//
//  Created by judian on 2019/4/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_TextStyleModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TextStyleManager : NSObject

@property(nonatomic, strong)JUDIAN_READ_TextStyleModel* textStyleModel;

+ (instancetype)shareInstance;


- (void)archiveTextStyle;

- (void)unarchiveTextStyle;



@end

NS_ASSUME_NONNULL_END
