//
//  JUDIAN_READ_MyHeadView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MyHeadView.h"
#import "JUDIAN_READ_ShelfTopView.h"

@interface JUDIAN_READ_MyHeadView ()

@property (nonatomic,strong) UIImageView  *backImgView;
@property (nonatomic,strong) UIImageView  *imgView;
@property (nonatomic,strong) UILabel  *nameLab;
@property (nonatomic,strong) UILabel  *idLab;
@property (nonatomic,strong) UILabel  *readTimeLab;
@property (nonatomic,strong) UIImageView  *vipImgView;
@property (nonatomic,strong) UIButton  *unloginLab;
@property (nonatomic,strong) UIButton  *enterBtn;
@property (nonatomic,strong) UIButton  *enterBtn1;


@end


@implementation JUDIAN_READ_MyHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColorWhite;
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_default_big"]];
        self.imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction)];
        [self.imgView addGestureRecognizer:tap];
        [self.imgView doBorderWidth:0.5 color:KSepColor cornerRadius:53/2.0];
        [self addSubview:self.imgView];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.nameLab setText:@"点击登录" titleFontSize:17 titleColot:kColor51];
        [self addSubview:self.nameLab];
        
        self.nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction)];
        [self.nameLab addGestureRecognizer:tap1];
        
        
        self.idLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.idLab setText:@"ID：" titleFontSize:12 titleColot:kColor100];
        [self addSubview:self.idLab];
        self.idLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginAction)];
        [self.idLab addGestureRecognizer:tap2];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction)];
        [self.idLab addGestureRecognizer:longTap];
        
        
        self.vipImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        self.vipImgView.contentMode = UIViewContentModeLeft;
        self.vipImgView.hidden = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterCenter)];
        [self.vipImgView addGestureRecognizer:tap3];
        self.vipImgView.userInteractionEnabled = YES;
        [self addSubview:self.vipImgView];
    
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"my_close"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(removeSelfAction) forControlEvents:UIControlEventTouchUpInside];
        delBtn.contentMode = UIViewContentModeCenter;
        [self addSubview:delBtn];
        
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn.hidden = YES;
        [enterBtn setImage:[UIImage imageNamed:@"list_next"] forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterBtn];
        self.enterBtn = enterBtn;

        UIButton *enterBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn1.hidden = YES;
        [enterBtn1 setText:@"个人主页" titleFontSize:12 titleColot:kColor153];
        [enterBtn1 addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterBtn1];
        self.enterBtn1 = enterBtn1;
        
        NSArray *titles = @[@"昨日阅读排名",@"我的现金",@"我的元宝"];
        for (int i = 0; i < 3; i++) {
            JUDIAN_READ_ShelfTopView *view = [[JUDIAN_READ_ShelfTopView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0*i, 101, SCREEN_WIDTH/3.0, 67) imagesName:nil title:titles[i]];
            [view setTopTitle:@"0"];
            view.tag = (i+1)*1000;
            [view setBottomTextColor:kColor153];
            [view changeTopViewFrame:CGRectMake(0, 16, ScreenWidth/3, 14) bottomFrame:CGRectMake(0, 40, ScreenWidth/3, 12)];
            [self addSubview:view];
            view.touchBlock = ^{
                if (self.indexBlock) {
                    self.indexBlock([NSString stringWithFormat:@"%d",i],nil);
                }
            };
        }

        
        WeakSelf(weakSelf);
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(@48);
            make.width.height.equalTo(@53);
        }];

        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.imgView).offset(6);
            make.left.equalTo(weakSelf.imgView.mas_right).offset(15);
            
            make.width.lessThanOrEqualTo(@(weakSelf.width - 68 - 15 - 45 - 15 - 55 - 25));
        }];
        
        
        [self.idLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.imgView.mas_bottom).offset(-7);
            make.left.equalTo(weakSelf.imgView.mas_right).offset(15);
        }];
        
        [self.vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.nameLab);
            make.left.equalTo(weakSelf.nameLab.mas_right).offset(2).priorityHigh();
            make.right.lessThanOrEqualTo(enterBtn1.mas_left).offset(-20);
        }];
        
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
            make.width.height.equalTo(@53);
        }];
        
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.imgView);
            make.right.equalTo(@0);
            make.width.equalTo(@45);
            make.height.equalTo(@20);
        }];
        
        [enterBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.imgView);
            make.right.equalTo(enterBtn.mas_left).offset(15);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
        }];

        
    }
    return self;
}


- (void)setPersonInfoWithData:(id)model{
    JUDIAN_READ_Account *account = model;
    JUDIAN_READ_ShelfTopView *view = [self viewWithTag:1000];
    JUDIAN_READ_ShelfTopView *view1 = [self viewWithTag:2000];
    JUDIAN_READ_ShelfTopView *view2 = [self viewWithTag:3000];

    if ([JUDIAN_READ_Account currentAccount].token.length) {

        NSString *str = @"head_big";
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:[UIImage imageNamed:str]];
        self.nameLab.text = account.nickname;
        self.idLab.text = [NSString stringWithFormat:@"ID：%@",account.uid];
    
        if (account.todayReadRank.intValue > 100) {
            [view setTopTitle:@"未上榜"];
        }else{
            [view setTopTitle:account.todayReadRank];
        }
        [view1 setTopTitle:account.todayCoins];
        [view2 setTopTitle:account.totalCoins];
        self.enterBtn.hidden = NO;
        self.enterBtn1.hidden = NO;
           
    }else{
        [view setTopTitle:@"0"];
        [view1 setTopTitle:@"0"];
        [view2 setTopTitle:@"0"];
        self.enterBtn.hidden = YES;
        self.enterBtn1.hidden = YES;
        self.nameLab.userInteractionEnabled = YES;
        self.idLab.userInteractionEnabled = YES;
        self.idLab.text = @"登录后 元宝天天领";
        self.nameLab.text = @"点击登录";
        self.imgView.image = [UIImage imageNamed:@"head_default_big"];
    }
    
    NSString *vip = @"";
    if (account.vip_status.integerValue  == 1) {
        vip = account.vip_type.intValue == 5 ? @"members_icon_crown_permanent" : @"members_icon_crown_annual";
        self.vipImgView.hidden = NO;
        self.vipImgView.image = [UIImage imageNamed:vip];
    }else if(account.vip_status.integerValue  == 2){
        vip = @"members_icon_crown_annual_overdue";
        self.vipImgView.image = [UIImage imageNamed:vip];
    }else{
        self.vipImgView.hidden = YES;
    }
}

- (void)enterCenter{
    if (self.loginBlock) {
        self.loginBlock(@"2",@"2");
    }
}

- (void)loginAction{
    if (self.loginBlock) {
        if ([JUDIAN_READ_Account currentAccount].token) {
                self.loginBlock(@"0",@"0");
        }else{
            self.loginBlock(@"1",@"1");
        }
    }
}

- (void)longTapAction{
    if ([JUDIAN_READ_Account currentAccount].token) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [JUDIAN_READ_Account currentAccount].uid;
        [MBProgressHUD showMessage:@"复制成功"];
    }
}


- (void)removeSelfAction{
    if (self.removeSelfBlock) {
        self.removeSelfBlock();
    }
}

@end
