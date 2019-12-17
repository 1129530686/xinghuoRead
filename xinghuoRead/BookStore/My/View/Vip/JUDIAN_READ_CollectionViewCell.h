//
//  JUDIAN_READ_CollectionViewCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/1.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CollectionViewCell : JUDIAN_READ_BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;

- (void)setVipDataWithModel:(nullable id)model model2:(nullable id)model1 model3:(nullable id)model2 indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
