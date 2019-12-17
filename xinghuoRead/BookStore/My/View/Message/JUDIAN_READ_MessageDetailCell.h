//
//  JUDIAN_READ_MessageDetailCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MessageDetailCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailTitlelab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImg;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightDetail;

- (void)setDetailDataWithBaseModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
