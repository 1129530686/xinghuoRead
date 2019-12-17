//
//  JUDIAN_READ_TypeCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TypeCell : JUDIAN_READ_BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


- (void)setTypeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)setPlatFormDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
