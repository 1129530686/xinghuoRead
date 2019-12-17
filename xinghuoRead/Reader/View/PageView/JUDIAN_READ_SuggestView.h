//
//  JUDIAN_READ_SuggestView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SuggestView : JUDIAN_READ_BaseView

@property (nonatomic,copy) CompletionBlock  inputBlock;
@property (nonatomic,copy) CompletionBlock  commitBlock;


@end

NS_ASSUME_NONNULL_END
