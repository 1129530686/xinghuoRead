//
//  JUDIAN_READ_BuyRecordCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/30.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BuyRecordCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;



- (void)setDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
