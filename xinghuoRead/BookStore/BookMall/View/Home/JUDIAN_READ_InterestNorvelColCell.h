//
//  JUDIAN_READ_InterestNorvelColCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionViewCell.h"

typedef void(^clickBlock)(NSInteger args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_InterestNorvelColCell : JUDIAN_READ_BaseCollectionViewCell

@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic, copy) clickBlock block;

@end

NS_ASSUME_NONNULL_END
