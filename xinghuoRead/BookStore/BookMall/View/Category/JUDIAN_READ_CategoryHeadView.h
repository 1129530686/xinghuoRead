//
//  JUDIAN_READ_CategoryHeadView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CategoryHeadView : JUDIAN_READ_BaseView
@property (weak, nonatomic) IBOutlet UILabel *leadLab;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UILabel *trailLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLeadLab;
@property (weak, nonatomic) IBOutlet UILabel *secondCenterLab;
@property (weak, nonatomic) IBOutlet UILabel *secondTrailLab;
@property (nonatomic,copy) CompletionBlock selectBlock;
@property (weak, nonatomic) IBOutlet UIView *sepView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

- (void)setLeftDataWithModel:(id)model isHiddenTop:(BOOL)isYES;

@end


NS_ASSUME_NONNULL_END
