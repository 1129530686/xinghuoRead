//
//  JUDIAN_READ_FastSearchCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FastSearchCell : JUDIAN_READ_BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leadBtn;

@property (weak, nonatomic) IBOutlet UILabel *trailLab;



//快速搜索数据
- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath keyWords:(NSString *)keywords;

@end

NS_ASSUME_NONNULL_END
