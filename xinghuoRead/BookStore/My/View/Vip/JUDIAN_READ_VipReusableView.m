//
//  JUDIAN_READ_VipReusableView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/1.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_VipReusableView.h"

@implementation JUDIAN_READ_VipReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)leadAction:(id)sender {
    if (self.leadSetBlock) {
        self.leadSetBlock();
    }
}

- (IBAction)trailAction:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}




- (void)setVipSetDataWithModel:(nullable id)model indexPath:(NSIndexPath *)indexPath{
    
    [self.leadbtn setText:@"设置我的支付方式" titleFontSize:12 titleColot:kThemeColor];
    
    self.centerLab.hidden = YES;
    self.trailBtn.hidden = YES;
//    [self.centerLab setText:[NSString stringWithFormat:@"余额：00"] titleFontSize:12 titleColot:kColor51];
//    self.centerLab.userInteractionEnabled = NO;
//    [self.trailBtn setText:@"去充值" titleFontSize:12 titleColot:kColorWhite];
//    [self.trailBtn doBorderWidth:0 color:nil cornerRadius:3];
//    [self.trailBtn setBackgroundImage:[UIImage imageNamed:@"welfare_list_btn"] forState:UIControlStateNormal];
//    [self.trailBtn setImage:nil forState:UIControlStateNormal];
    
}

- (void)setAction{
    if (self.leadSetBlock) {
        self.leadSetBlock();
    }
}


- (void)setVipDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    [self.leadbtn setText:@"会员权益" titleFontSize:17 titleColot:kColor51];
    self.leadbtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.leadbtn setImage:[UIImage imageNamed:@"members_nterests_line"] forState:UIControlStateNormal];
    [self.leadbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    self.leadbtn.userInteractionEnabled = NO;
    self.trailBtn.hidden = YES;
    self.centerLab.hidden = YES;
}

@end
