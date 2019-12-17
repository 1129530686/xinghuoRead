//
//  JUDIAN_READ_MyHeadView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MyHeadView : JUDIAN_READ_BaseView

@property (nonatomic,copy) CompletionBlock  loginBlock;
@property (nonatomic,copy) CompletionBlock  indexBlock;
@property (nonatomic,copy) VoidBlock  removeSelfBlock;

- (void)setPersonInfoWithData:(id)model;

@end

NS_ASSUME_NONNULL_END
