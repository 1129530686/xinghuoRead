//
//  JUDIAN_READ_CategoryHeadView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CategoryHeadView.h"
#import "JUDIAN_READ_CategoryModel.h"

@interface JUDIAN_READ_CategoryHeadView ()

@property (nonatomic,strong) NSMutableArray  *arr;
@property (nonatomic,assign) NSInteger  selectI1;
@property (nonatomic,assign) NSInteger  selectI2;

@end

@implementation JUDIAN_READ_CategoryHeadView

- (void)setLeftDataWithModel:(id)model isHiddenTop:(BOOL)isYES{
    if (isYES) {
        self.topSpace.constant = 0;
        self.heightSpace.constant = 0;
    }
    self.arr = model;
    int i = 0;
    for (UILabel *lab in self.subviews) {
        if (![lab isKindOfClass:[UILabel class]]) {
            continue;
        }
        if ([model count] < i) {
            return;
        }
        JUDIAN_READ_CategoryModel *info = model[i];
        [lab setText:info.name titleFontSize:12 titleColot:kColor100];
        if (i == 0) {
            [lab doBorderWidth:0.5 color:kThemeColor cornerRadius:3];
            [lab setTextColor:kThemeColor];
        }
        if (i == 3) {
            [lab setTextColor:kThemeColor];
        }
        i++;
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectI2 = 3;
    int i = 0;
    for (UILabel *lab in self.subviews) {
        if (![lab isKindOfClass:[UILabel class]]) {
            continue;
        }
        lab.tag = i++;
        lab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAction:)];
        [lab addGestureRecognizer:tap];
    }
}

- (void)selectAction:(UITapGestureRecognizer *)ges{
    int i = 0;
    for (UILabel *lab in self.subviews) {
        if (![lab isKindOfClass:[UILabel class]]) {
            continue;
        }
        if ([ges.view isEqual:lab]) {
            i < 3 ? (self.selectI1 = i) : (self.selectI2 = i);
        }
        [lab doBorderWidth:0 color:nil cornerRadius:0];
        [lab setTextColor:kColor100];
        i++;
    }
    [self.subviews[_selectI1] setTextColor:kThemeColor];
    [self.subviews[_selectI1] doBorderWidth:0.5 color:kThemeColor cornerRadius:3];
    [self.subviews[_selectI2] setTextColor:kThemeColor];

    if (self.selectBlock) {
        NSString *status;
        NSString *tag;
        if (self.selectI1  != 0) {
            JUDIAN_READ_CategoryModel *info = self.arr[self.selectI1];
            status = info.value;
            [MobClick event:click_option_subtype attributes:@{@"state":info.name}];

        }
        if (self.selectI2 != 3) {
            JUDIAN_READ_CategoryModel *info = self.arr[self.selectI2];
           tag = info.value;
            [MobClick event:click_option_subtype attributes:@{@"type":info.name}];

        }
        self.selectBlock(status,tag);
    }
    
}

@end
