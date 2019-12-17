//
//  JUDIAN_READ_MakeMoneyController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/26.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MakeMoneyController.h"
#import "JUDIAN_READ_WithdrawController.h"
#import "JUDIAN_READ_UpLoadMoneyController.h"

@interface JUDIAN_READ_MakeMoneyController ()<CustomAlertViewDelegate>

@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UILabel  *moneyLab;



@end

@implementation JUDIAN_READ_MakeMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    [self addItem];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.footView];
    // Do any additional setup after loading the view.
}

- (void)addItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(detailAction)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)detailAction{
    JUDIAN_READ_WithdrawController *vc = [JUDIAN_READ_WithdrawController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 103)];
        _headView.backgroundColor = kColorWhite;
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
        [lab setText:@"总金额（元）" titleFontSize:14 titleColot:kColor153];
        [_headView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.mas_equalTo(21);
        }];
        
        self.moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 23)];
        self.moneyLab.textAlignment = NSTextAlignmentCenter;
        [self.moneyLab setText:@"11.00" titleFontSize:28 titleColot:kThemeColor];
        self.moneyLab.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
        [_headView addSubview:self.moneyLab];
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 103-10, SCREEN_WIDTH, 10)];
        view.backgroundColor = kBackColor;
        [_headView addSubview:view];
    }
    return _headView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 103, SCREEN_WIDTH, Height_Content - 103)];
        _footView.backgroundColor = kColorWhite;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"members_pay_treasure2"] forState:UIControlStateNormal];
        [btn setText:@"支付宝提现" titleFontSize:14 titleColot:kColor51];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_footView addSubview:btn];
        [btn doBorderWidth:0 color:nil cornerRadius:3];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(14);
            make.width.mas_equalTo(200);
        }];

        NSArray *arr = @[@"提现1.00元",@"提现30.00元",@"提现100.00元"];
        for (int i = 0; i < 3; i++) {
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(15+i*((SCREEN_WIDTH-30-14)/3.0+7), 45, (SCREEN_WIDTH-30-14)/3.0, 47);
            [btn1 setText:arr[i] titleFontSize:15 titleColot:kColor100];
            [btn1 setBackgroundColor:kBackColor];
            [btn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            btn1.tag = (i+1)*100;
            [btn1 addTarget:self action:@selector(selType:) forControlEvents:UIControlEventTouchUpInside];
            [_footView addSubview:btn1];
        }
        
        UITextView *lab = [[UITextView alloc]initWithFrame:CGRectZero];
        lab.editable = NO;
        lab.scrollEnabled = NO;
        [lab setText:@" " titleFontSize:12 titleColot:kColor153];
        NSString *str = @"温馨提示：\n1. 提现额度分为1元、30元、100元三档，仅首次提现，1元可提 ，首次提现过后，每次提现时您可以选择所需的一档提现额度， 剩余金额可在下次满足前述提现额度时申请提现。\n2. 提现一般7~15天内到账。\n3. 如发现造价等违规操作，我们有权阻止您使用以及取消您获得的奖励。\n4. 我们可在法律法规允许的范围内对本次活动贵的解释并作出适当的修改。\n";
        NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc]init];
        par.lineSpacing = 5;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:kColor153,NSParagraphStyleAttributeName:par,NSFontAttributeName:kFontSize12}];
        NSRange range = [str rangeOfString:@"1元、30元、100元"];
                [att addAttributes:@{NSForegroundColorAttributeName:kThemeColor} range:range];
        lab.attributedText = att;
        [_footView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20+90);
            make.width.mas_equalTo(SCREEN_WIDTH-20);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return _footView;
}

- (void)selType:(UIButton *)btn{
    
    for (int i = 1; i < 4; i++) {
        UIButton *btn1 = (UIButton *)self.footView.subviews[i];
        btn1.backgroundColor = kBackColor;
        [btn1 setTitleColor:kColor100 forState:UIControlStateNormal];

    }
    btn.backgroundColor = RGBA(255, 241, 245, 1);
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    // 如果非首次提现&&提现一元
    if (btn.tag == 100) {
        JUDIAN_READ_CustomAlertView *alert = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:@"" message:@"一元提现，每人只限一次哦" leftButtonTitle:@"我知道了" rightButtonTitle:@"去赚钱"];
        alert.tag = 100;
        alert.delegate = self;
        return;
    }
    
    //如果余额不足
    if(0){
        JUDIAN_READ_CustomAlertView *alert = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:@"" message:@"余额不足，快去邀请好友继续赚钱吧~" leftButtonTitle:@"我知道了" rightButtonTitle:@"去赚钱"];
        alert.textAlignment = NSTextAlignmentLeft;
        alert.lineHeight = 5;
        alert.tag = 1000;
        alert.delegate = self;
        return;
    }
    
    JUDIAN_READ_UpLoadMoneyController *vc = [JUDIAN_READ_UpLoadMoneyController new];
    vc.money = btn.tag == 100 ? @"1.00" : (btn.tag == 200 ? @"30.00":@"100.00");
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index{
    if (view.tag == 100) {
        
        
        
    }else{
        
        
    }
    
}


@end
