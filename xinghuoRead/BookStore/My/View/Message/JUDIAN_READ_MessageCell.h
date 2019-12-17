//
//  JUDIAN_READ_MessageCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MessageCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

- (void)setMessageDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
