//
//  JUDIAN_READ_CoinCell.h
//  universalRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CoinCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leadTopLab;
@property (weak, nonatomic) IBOutlet UILabel *trailTopLab;
@property (weak, nonatomic) IBOutlet UILabel *trailBotLab;
@property (weak, nonatomic) IBOutlet UIView *sepView;



- (void)setCoinDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath;

- (void)setIncomeDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
