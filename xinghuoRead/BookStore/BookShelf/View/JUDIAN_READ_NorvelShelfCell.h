//
//  JUDIAN_READ_NorvelShelfCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NorvelShelfCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UILabel *centerUnreadLab;
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (nonatomic,copy) VoidBlock  deleteBlock;
@property (weak, nonatomic) IBOutlet UILabel *storeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet UILabel *trailLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailLeadConstant;


//书架
- (void)setShelfDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath selectItem:(NSInteger)item isEditing:(BOOL)isEditing;


- (void)setShelfDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
