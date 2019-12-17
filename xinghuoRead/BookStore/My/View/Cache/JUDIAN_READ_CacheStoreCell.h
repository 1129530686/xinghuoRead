//
//  JUDIAN_READ_CacheStoreCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/15.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"
#import "JUDIAN_READ_CircleProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CacheStoreCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet JUDIAN_READ_CircleProgressView *trailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleWidth;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (nonatomic,copy) CompletionBlock  downLoadBlock;
@property (weak, nonatomic) IBOutlet UIImageView *freeLab;


- (void)setDataWithRecordModel:(id)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
