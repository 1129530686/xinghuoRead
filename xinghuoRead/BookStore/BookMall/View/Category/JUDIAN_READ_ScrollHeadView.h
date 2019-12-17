//
//  JUDIAN_READ_ScrollHeadView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/15.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ScrollHeadView : JUDIAN_READ_BaseView

@property (nonatomic,copy) CompletionBlock  touchBlock;
@property (nonatomic,assign) NSInteger  selectItem;
@property (nonatomic,assign) CGFloat  sepViewWidth;
@property (nonatomic,strong) NSArray  *subViewArr;
@property (nonatomic,strong) NSArray  *titles;

//titles为空则给空字符串,对应个数。
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles leftIcon:(nullable NSString *)leftImg;


@end

NS_ASSUME_NONNULL_END
