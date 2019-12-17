//
//  JUDIAN_READ_CategoryLeftCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CategoryLeftCell : JUDIAN_READ_BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

- (void)setLeftDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//全部分类

@end

NS_ASSUME_NONNULL_END
