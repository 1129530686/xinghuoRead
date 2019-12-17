//
//  JUDIAN_READ_InfoView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_InfoView.h"
#import "JUDIAN_READ_ReadRankModel.h"


@interface JUDIAN_READ_InfoView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1BottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1Height;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readTimeLabTop;

@end

@implementation JUDIAN_READ_InfoView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.iconView doBorderWidth:0 color:nil cornerRadius:67/2.0];
    
    self.iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigAction)];
    [self.iconView addGestureRecognizer:tap];
    
    self.lab1.backgroundColor = [kColorWhite colorWithAlphaComponent:0.3];
    self.lab2.backgroundColor = [kColorWhite colorWithAlphaComponent:0.3];
    self.lab3.backgroundColor = [kColorWhite colorWithAlphaComponent:0.3];
    self.lab4.backgroundColor = [kColorWhite colorWithAlphaComponent:0.3];
    self.lab5.backgroundColor = [kColorWhite colorWithAlphaComponent:0.3];


    [self.lab1 doBorderWidth:0 color:nil cornerRadius:8];
    [self.lab2 doBorderWidth:0 color:nil cornerRadius:8];
    [self.lab3 doBorderWidth:0 color:nil cornerRadius:8];
    [self.lab4 doBorderWidth:0 color:nil cornerRadius:8];
    [self.lab5 doBorderWidth:0 color:nil cornerRadius:8];
    
    self.nameLab.lineBreakMode = UILineBreakModeCharacterWrap;

}

- (void)bigAction{
    if (self.LookImgViewBlock) {
        self.LookImgViewBlock();
    }    
}

- (IBAction)lockAction:(id)sender {
    if (self.lockBlock) {
        self.lockBlock();
    }
}


- (CGFloat)setPersonInfoWithModel:(id)model isSelf:(BOOL)isYES{
    JUDIAN_READ_ReadRankModel *info = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.headImg]placeholderImage:[UIImage imageNamed:@"head_big"]];
    self.nameLab.text = info.nickname;
    self.idLab.text = [NSString stringWithFormat:@"ID：%@",info.uidb];
    
    CGFloat y = 0;
    self.lockBtn.hidden = NO;
    if (info.wxNo.length) {
        if (isYES) {
            self.wechatLab.text =  [NSString stringWithFormat:@"微信号：%@",info.wxNo];
            self.wechatLab.hidden = NO;
            self.widthConstant.constant = 67;
            [self.lockBtn setTitle:@"" forState:UIControlStateNormal];
            [self.lockBtn setImage:[UIImage imageNamed:@"personal_editor"] forState:UIControlStateNormal];
        }else{
            self.wechatBottomSpace.constant = 0;
            self.wechatLab.hidden = YES;
            self.widthConstant.constant = 90;
            y -= 25;
        }
    }else{
        if (isYES) {
            self.widthConstant.constant = 67;
            [self.lockBtn setTitle:@"" forState:UIControlStateNormal];
            [self.lockBtn setImage:[UIImage imageNamed:@"personal_editor"] forState:UIControlStateNormal];
        }else{
            y -= 25;
            self.wechatBottomSpace.constant = 0;
            self.wechatLab.hidden = YES;
            self.lockBtn.hidden = YES;
            self.widthConstant.constant = 0;
            
        }
    }
    
    
    
    
    
//   四个标签
    NSString *str0;
    if (info.sex.intValue) {
        str0 = info.sex.intValue == 1 ? @"男" : @"女";
    }else{
        str0 = @"";
    }
    NSString *str1 = info.age.length ? [NSString stringWithFormat:@"  %@岁  ",info.age]: @"";
    NSString *str2 = info.constellation.length ? [NSString stringWithFormat:@"  %@  ",info.constellation] : @"";
    if (info.province.length && [info.province isEqualToString:@"重庆市"]) {
        info.city = @"重庆市";
    }
    NSString *str3 = info.city.length ? [NSString stringWithFormat:@"  %@  ",info.city] : @"";
    NSString *str4 = info.profession.length ? [NSString stringWithFormat:@"  %@  ",info.profession]  : @"";
    
    if (!str0.length && !str1.length && !str2.length && !str3.length && !str4.length) {
        y -= 27;
        self.lab1BottomSpace.constant = 0;
        self.lab1Height.constant = 0;
        self.lab1.hidden = YES;
    }
    
    if (info.sex.intValue) {
        NSString *img = info.sex.intValue == 1 ? @"personal_boy_bg2" : @"personal_girl_bg2";
        [self.lab1 setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    }
    
    
    int count = 0;
    if (!str0.length) {
        self.lab5.hidden = YES;
    }else{
        count = 1;
        [self.lab1 setTitle:str0 forState:UIControlStateNormal];
    }
    
    
    if (count == 1) {
        if (!str1.length) {
            self.lab5.hidden = YES;
        }else{
            count = 2;
            [self.lab2 setTitle:str1 forState:UIControlStateNormal];
        }
    }else{
        if (!str1.length) {
            self.lab4.hidden = YES;
        }else{
            [self.lab1 setTitle:str1 forState:UIControlStateNormal];
            count = 1;
        }
    }
    
    if (count == 2) {
        if (!str2.length) {
            self.lab5.hidden = YES;
        }else{
            count = 3;
            [self.lab3 setTitle:str2 forState:UIControlStateNormal];
        }
    }else if (count == 1){
        if (!str2.length) {
            self.lab4.hidden = YES;
        }else{
            [self.lab2 setTitle:str2 forState:UIControlStateNormal];
            count = 2;
        }
    }else{
        if (!str2.length) {
            self.lab3.hidden = YES;
        }else{
            [self.lab1 setTitle:str2 forState:UIControlStateNormal];
            count = 1;
        }
    }
    
    
    if (count == 3) {
        if (!str3.length) {
            self.lab5.hidden = YES;
        }else{
            [self.lab4 setTitle:str3 forState:UIControlStateNormal];
            count = 4;
        }
    }else if (count == 2){
        if (!str3.length) {
            self.lab4.hidden = YES;
        }else{
            [self.lab3 setTitle:str3 forState:UIControlStateNormal];
            count = 3;
        }
    }else if (count == 1){
        if (!str3.length) {
            self.lab3.hidden = YES;
        }else{
            [self.lab2 setTitle:str3 forState:UIControlStateNormal];
            count = 2;
        }
    }else{
        if (!str3.length) {
            self.lab2.hidden = YES;
        }else{
            [self.lab1 setTitle:str3 forState:UIControlStateNormal];
            count = 1;
        }
    }
    
    
    if (count == 4) {
        if (!str4.length) {
            self.lab5.hidden = YES;
        }else{
            [self.lab5 setTitle:str4 forState:UIControlStateNormal];
            count = 4;
        }
    }else if (count == 3){
        if (!str4.length) {
            self.lab4.hidden = YES;
        }else{
            [self.lab4 setTitle:str4 forState:UIControlStateNormal];
            count = 3;
        }
    }else if (count == 2){
        if (!str4.length) {
            self.lab3.hidden = YES;
        }else{
            [self.lab3 setTitle:str4 forState:UIControlStateNormal];
            count = 2;
        }
    }else if (count == 1){
        if (!str4.length) {
            self.lab2.hidden = YES;
        }else{
            [self.lab2 setTitle:str4 forState:UIControlStateNormal];
            count = 1;
        }
    }else{
        if (!str4.length) {
            self.lab1.hidden = YES;
        }else{
            [self.lab1 setTitle:str4 forState:UIControlStateNormal];
            count = 1;
        }
    }
    

    [self.descLab setText:@"" titleFontSize:12 titleColot:kColor204];
    self.descLab.text = info.personProfile.length ? info.personProfile : @"";
    y = info.personProfile.length ? y : (y-20);
    self.readTimeLabTop.constant = info.personProfile.length ? 25 : 14;
    
    NSString *ss = !info.rankDesc.length || !info.rankDesc ? @"" : info.rankDesc;
    NSString *str;
    if ([info.readDuration isEqualToString:@"0时0分"]) {
        str = [NSString stringWithFormat:@"阅读时长：%@   ", info.readDuration];
    }else{
        str = [NSString stringWithFormat:@"阅读时长：%@   %@", info.readDuration,ss];
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    
   
    NSDictionary *hightLightDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:kFontSize17};
    
    if (info.readDuration) {
        NSRange durationRange = [str rangeOfString:info.readDuration];
        if (durationRange.length > 0) {
            [att addAttributes:hightLightDictionary range:durationRange];
        }
    }
   
    
    NSCharacterSet *nonDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    NSArray *arr = [str componentsSeparatedByCharactersInSet:nonDigitCharacterSet];
    for (NSString *str1 in arr) {
        NSRange rang = [str rangeOfString:str1 options:NSBackwardsSearch];
        [att setAttributes:@{NSFontAttributeName:kFontSize12} range:rang];
    }
  
    self.readTimeLab.attributedText = att;
    
    return y;
}



@end
