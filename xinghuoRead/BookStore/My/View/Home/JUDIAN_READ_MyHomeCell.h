//
//  JUDIAN_READ_MyHomeCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/17.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MyHomeCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leadBtn;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailWidth;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageV;
@property (weak, nonatomic) IBOutlet UIView *updatePointView;
@property (nonatomic,copy) VoidBlock  switchBlock;


- (void)setMyHomeDataWithModel:(id)model imgs:(NSMutableArray*)imgs indexPath:(NSIndexPath *)indexPath count:(NSInteger)count;//我的首页

- (void)setSetDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//设置界面

- (void)setHomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//我的首页



@end

NS_ASSUME_NONNULL_END
