//
//  JUDIAN_READ_MyHomeCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/17.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MyHomeCell.h"

@implementation JUDIAN_READ_MyHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.updatePointView doBorderWidth:0 color:nil cornerRadius:2.5];
//    [self.leadBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSetDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{//设置界面
    NSMutableArray *arr = model;
    JUDIAN_READ_Account *acc = [JUDIAN_READ_Account currentAccount];
    [self.leadBtn setText:arr[indexPath.row] titleFontSize:16 titleColot:kColor51];
    [self.trailBtn setBackgroundColor:kColorWhite];
    self.trailWidth.constant = 67;
    [self.trailBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    self.centerLab.hidden = NO;
    if (indexPath.row == 0) {
        if (acc.bind_mobile.integerValue == 1) {
            self.centerLab.text = acc.mobile;
            [self.trailBtn setTitle:@"" forState:UIControlStateNormal];
            [self.trailBtn doBorderWidth:0 color:nil cornerRadius:0];
            [self.trailBtn setImage:[UIImage imageNamed:@"list_next"] forState:UIControlStateNormal];
            self.trailWidth.constant = 7;
        }else{
            self.centerLab.text = @"绑定手机号，提高安全等级";
            [self.trailBtn setText:[NSString stringWithFormat:@"立即绑定"] titleFontSize:12 titleColot:kThemeColor];
            [self.trailBtn doBorderWidth:0.5 color:kThemeColor cornerRadius:3];
            [self.trailBtn setImage:nil forState:UIControlStateNormal];
        }
    }else{
        if (acc.bind_wechat.integerValue == 1) {
            self.centerLab.text = acc.wechat_nickname;
            [self.trailBtn setText:[NSString stringWithFormat:@"已绑定"] titleFontSize:12 titleColot:kColor204];
            [self.trailBtn doBorderWidth:0 color:nil cornerRadius:3];
            [self.trailBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.trailBtn setBackgroundColor:KSepColor];
        }else{
            self.centerLab.text = @"一键快捷登录";
            [self.trailBtn setText:[NSString stringWithFormat:@"立即绑定"] titleFontSize:12 titleColot:kThemeColor];
            [self.trailBtn doBorderWidth:0.5 color:kThemeColor cornerRadius:3];
            [self.trailBtn setImage:nil forState:UIControlStateNormal];
        }
        
    }
}


- (void)setMyHomeDataWithModel:(id)model imgs:(NSMutableArray*)imgs indexPath:(NSIndexPath *)indexPath count:(NSInteger)count{//我的首页
    NSMutableArray *arr = model;
    self.sepView.hidden = YES;
    self.centerLab.hidden = YES;
    self.centerImageV.hidden = YES;
    [self.leadBtn setTitle:arr[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    [self.trailBtn doBorderWidth:0 color:nil cornerRadius:6];
    [self.leadBtn setImage:[UIImage imageNamed:imgs[indexPath.section][indexPath.row]] forState:UIControlStateNormal];
    self.centerLab.text = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.centerLab.hidden = NO;
            self.centerLab.text = @"赚元宝";
        }
        if ([arr[0] containsObject:@"输入邀请码，领元宝"]) {
            if (indexPath.row == 2){
                self.centerLab.hidden = NO;
                self.centerLab.text = @"兑换手机话费";
            }else if (indexPath.row == 3){
                self.centerLab.hidden = NO;
                self.centerLab.text = @"更多元宝，等你领取";
            }
        }else{
            if (indexPath.row == 1){
                self.centerLab.hidden = NO;
                self.centerLab.text = @"兑换手机话费";
            }else if (indexPath.row == 2){
                self.centerLab.hidden = NO;
                self.centerLab.text = @"更多元宝，等你领取";
            }
        }
    }else{
        if (indexPath.row == 1) {
            self.centerImageV.hidden = NO;
            self.centerLab.hidden = NO;
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            self.centerLab.text = [def objectForKey:QQ_Group];
        }
    }
    
}


- (void)setHomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = model;
    self.centerLab.hidden = YES;
    self.centerImageV.hidden = YES;
    self.sepView.hidden = NO;
    [self.leadBtn setTitle:arr[indexPath.row] forState:UIControlStateNormal];
    [self.trailBtn setImage:[UIImage imageNamed:@"list_next"] forState:UIControlStateNormal];
    if (indexPath.row == 0) {
        self.centerLab.hidden = NO;
        self.centerLab.text = @"连续签到，奖励翻倍";
        [self.trailBtn setImage:[UIImage imageNamed:@"default_address_on_tip"] forState:UIControlStateNormal];
    }else if (indexPath.row == 1){
        self.centerLab.hidden = NO;
        self.centerLab.text = @"收藏书籍更新，及时通知";
        [self.trailBtn setImage:[UIImage imageNamed:@"default_address_off_tip"] forState:UIControlStateNormal];
    }else if (indexPath.row == 2){
        self.centerLab.hidden = NO;
        self.centerLab.text = @"赚现金";
    }else if (indexPath.row == 5){
        self.centerImageV.hidden = NO;
        self.centerLab.hidden = NO;
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        self.centerLab.text = [def objectForKey:QQ_Group];
    }
    if (indexPath.row == arr.count - 1) {
        self.sepView.hidden = YES;
    }
    
   
    
    if ([JUDIAN_READ_TestHelper needUpdate]&& indexPath.row == arr.count - 2) {
        self.updatePointView.hidden = NO;
    }else{
        self.updatePointView.hidden = YES;
    }
    
}

- (IBAction)leadBtnAction:(id)sender {
    
}


- (IBAction)trailBtnAction:(id)sender {
    if (self.switchBlock) {
        self.switchBlock();
    }
}


@end
