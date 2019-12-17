//
//  JUDIAN_READ_SearchColCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SearchColCell : JUDIAN_READ_BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

//vipCell 设置
- (void)setVipDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

//搜索cell设置
- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
