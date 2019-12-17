//
//  JUDIAN_READ_UpLoadMoneyController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_UpLoadMoneyController.h"
#import "JUDIAN_READ_LoginCell.h"
#import "JUDIAN_READ_WithdrawController.h"

@interface JUDIAN_READ_UpLoadMoneyController ()<CustomAlertViewDelegate>
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) NSMutableDictionary  *dic;
@property (nonatomic,strong) NSArray  *places;
@property (nonatomic,strong) UIButton  *btn;
@end

@implementation JUDIAN_READ_UpLoadMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入提现账号";
    [self.view addSubview:self.tableView];
  
}


#pragma mark 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:ViewFrame  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_LoginCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_LoginCell"];
        _tableView.tableFooterView = self.footView;
        _tableView.tableHeaderView = self.headView;
        _tableView.rowHeight = 53;
        
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [_tableView addGestureRecognizer:tapGuesture];
    }
    return _tableView;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53)];
        _headView.backgroundColor = kColorWhite;
        UILabel *leadLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [leadLab setText:@"提现金额" titleFontSize:14 titleColot:kColor100];
        [_headView addSubview:leadLab];
        [leadLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *trailLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [_headView addSubview:trailLab];
        NSString *str = [NSString stringWithFormat:@"%@ 元",self.money];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range = [str rangeOfString:@"元"];
        [att addAttributes:@{NSFontAttributeName:kFontSize14} range:range];
        [trailLab setText:@" " titleFontSize:18 titleColot:kColor51];
        trailLab.attributedText = att;
        [trailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
        }];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(15, 52.5, SCREEN_WIDTH-30, 0.5)];
        sepView.backgroundColor = KSepColor;
        [_headView addSubview:sepView];
        
    }
    return _headView;
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  300)];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, SCREEN_WIDTH-30, 12)];
        [lab1 setText:@"*支付宝账号或姓名输入错误将无法提现" titleFontSize:12 titleColot:kColor153];
        [_footView addSubview:lab1];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 44, SCREEN_WIDTH-30, 47);
        [btn setText:@"确定提现" titleFontSize:16 titleColot:kColorWhite];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        self.loginBtn = btn;
        btn.userInteractionEnabled = NO;
        
        
        UITextView *lab = [[UITextView alloc]initWithFrame:CGRectZero];
        lab.editable = NO;
        lab.scrollEnabled = NO;
        [lab setText:@" " titleFontSize:12 titleColot:kColor153];
        NSString *str = @"温馨提示：\n1.使用支付宝提现需要您已注册支付宝并在支付宝中实名认证过。\n2.支付宝账号是您注册支付宝的手机号或者邮箱号，您可登录支 付宝查看。\n3.我们不会保存您的姓名和支付宝账号，每次提现都需要您重新输入相关信息。\n4.如您在提现中遇到其他问题，请在“我的”页面点击“意见回复”把相关问题反馈给我们。";
        NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc]init];
        par.lineSpacing = 5;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:kColor153,NSParagraphStyleAttributeName:par,NSFontAttributeName:kFontSize12}];
        lab.attributedText = att;
        [_footView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(113);
            make.width.mas_equalTo(SCREEN_WIDTH-20);
            make.bottom.mas_equalTo(0);
        }];
        
        
    }
    return _footView;
}

- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (NSArray *)places{
    if (!_places) {
        _places = [NSMutableArray arrayWithObjects:@"请输入支付宝姓名",@"请输入支付宝账号",nil];
    }
    return _places;
}



#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_LoginCell" forIndexPath:indexPath];
    [cell setMWithDrawDataWithIndexPath:indexPath model:self.dic placeArr:self.places];
    WeakSelf(obj);
    cell.tfBlock = ^(JUDIAN_READ_LoginCell *cellSelf, NSString *text) {
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            NSString *str = text;
            if ([text length] >= 11) {
                str = [text substringToIndex:11];
                cellSelf.inputTF.text = str;
            }
            indexPath.row == 0 ? [obj.dic setObject:str forKey:@"old_mobile"] : [obj.dic setObject:str forKey:@"mobile"];
        }
        if ([obj.dic[@"old_mobile"] length] && [obj.dic[@"mobile"]  length]) {
            [obj.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            obj.loginBtn.userInteractionEnabled = YES;
        }else{
            [obj.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
            obj.loginBtn.userInteractionEnabled = NO;
        }
    };
    return cell;
}

//提现
- (void)loginIn{
    JUDIAN_READ_CustomAlertView *alert = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:@"提现通知" message:@"已经提交申请。可在【个人中心-提现-提现记录】里查看进度" leftButtonTitle:@"我知道了" rightButtonTitle:@"去查看"];
    alert.textAlignment = NSTextAlignmentLeft;
    alert.delegate = self;
    
}

- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index{
    if (index == 1) {
        JUDIAN_READ_WithdrawController *vc = [JUDIAN_READ_WithdrawController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
