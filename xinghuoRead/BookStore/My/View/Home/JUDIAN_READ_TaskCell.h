//
//  JUDIAN_READ_TaskCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TaskCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *smallNameLab;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UIView *sepView;

//设置福利任务
- (void)setDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
