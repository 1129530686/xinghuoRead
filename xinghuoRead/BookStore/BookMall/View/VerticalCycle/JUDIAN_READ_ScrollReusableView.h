//
//  JUDIAN_READ_ScrollReusableView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/21.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_CycleVerticalView.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ScrollReusableView : UICollectionReusableView

@property (nonatomic,strong) JUDIAN_READ_CycleVerticalView *cycleView;

@property (nonatomic,strong) NSMutableArray  *arr;

@property (nonatomic,copy) void (^touchBlock)(NSInteger index);


@end

NS_ASSUME_NONNULL_END
