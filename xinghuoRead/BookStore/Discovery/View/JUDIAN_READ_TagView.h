//
//  JUDIAN_READ_TagView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TagView : JUDIAN_READ_BaseView

@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) CompletionBlock  refreshBlock;
@property (nonatomic,strong) CompletionBlock  loadBlock;


@end

NS_ASSUME_NONNULL_END
