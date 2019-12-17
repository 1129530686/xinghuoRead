//
//  JUDIAN_READ_BannarView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/29.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView/SDCycleScrollView.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BannarView : UICollectionReusableView
@property (nonatomic,strong) SDCycleScrollView  *cycleScrollView;
@property (nonatomic,strong) NSMutableArray  *bannarArr;
@property (nonatomic,strong) void (^touchBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
