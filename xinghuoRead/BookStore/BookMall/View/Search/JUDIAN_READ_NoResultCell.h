//
//  JUDIAN_READ_NoResultCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NoResultCell : JUDIAN_READ_BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (nonatomic,copy) VoidBlock  LoadBookBlock;

- (void)setModel:(NSString *)model;

@end

NS_ASSUME_NONNULL_END
