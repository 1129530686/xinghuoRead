//
//  JUDIAN_READ_VipColCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_VipColCell : JUDIAN_READ_BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

- (void)setDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
- (void)setRechageDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
