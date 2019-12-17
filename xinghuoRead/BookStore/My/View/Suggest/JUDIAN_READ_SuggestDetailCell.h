//
//  JUDIAN_READ_SuggestDetailCell.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SuggestDetailCell : JUDIAN_READ_BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leadTopLab;
@property (weak, nonatomic) IBOutlet UILabel *topTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *suggestLab;
@property (weak, nonatomic) IBOutlet UILabel *replyLab;
@property (weak, nonatomic) IBOutlet UILabel *botTimeLab;
@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpace;
- (void)setDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
