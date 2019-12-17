//
//  JUDIAN_READ_InfoView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_InfoView : JUDIAN_READ_BaseView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@property (weak, nonatomic) IBOutlet UILabel *wechatLab;
@property (weak, nonatomic) IBOutlet UIButton *lab1;
@property (weak, nonatomic) IBOutlet UIButton *lab2;
@property (weak, nonatomic) IBOutlet UIButton *lab3;
@property (weak, nonatomic) IBOutlet UIButton *lab4;
@property (weak, nonatomic) IBOutlet UIButton *lab5;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *readTimeLab;
@property (nonatomic,copy) VoidBlock LookImgViewBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;

@property (nonatomic,copy) VoidBlock  lockBlock;


- (CGFloat)setPersonInfoWithModel:(id)model isSelf:(BOOL)isYES;


@end

NS_ASSUME_NONNULL_END
