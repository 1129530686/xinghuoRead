//
//  JUDIAN_READ_ChangePhoneController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/5.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ChangePhoneController.h"
#import "JUDIAN_READ_LoginCell.h"

@interface JUDIAN_READ_ChangePhoneController ()

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) NSTimer  *timer;
@property (nonatomic,strong) NSMutableDictionary  *dic;
@property (nonatomic,strong) NSArray  *places;
@property (nonatomic,strong) UIButton  *btn;


@end

@implementation JUDIAN_READ_ChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    [self.view addSubview:self.tableView];
 //   [IQKeyboardManager sharedManager].enable = YES;
  //  [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [IQKeyboardManager sharedManager].enable = NO;
   // [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
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
        _tableView.rowHeight = 70;
        
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [_tableView addGestureRecognizer:tapGuesture];
    }
    return _tableView;
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  100)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 34, SCREEN_WIDTH-30, 47);
        [btn setText:@"确定" titleFontSize:16 titleColot:kColorWhite];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        self.loginBtn = btn;
        btn.userInteractionEnabled = NO;
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
        _places = [NSMutableArray arrayWithObjects:@"请输入当前绑定的手机号",@"请输入新的手机号",@"验证码",nil];
    }
    return _places;
}

//登陆
- (void)loginIn{
    if (!self.dic[@"mobile"] || !self.dic[@"old_mobile"]) {
        [MBProgressHUD showMessage:@"请输入手机号"];
        return;
    }
    
    if (![JUDIAN_READ_TestHelper isMobileNumber:self.dic[@"old_mobile"]] || ![JUDIAN_READ_TestHelper isMobileNumber:self.dic[@"mobile"]]) {
        [MBProgressHUD showMessage:@"手机号输入有误"];
        return;
    }
    
    if (!self.dic[@"code"]) {
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    [self.view endEditing:YES];
    [JUDIAN_READ_MyTool changeBindPhoneWithParams:self.dic completionBlock:^(id result, id error) {
        if (result) {
            [MBProgressHUD showMessage:@"绑定成功"];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            if ([error code] == 109) {
                JUDIAN_READ_CustomAlertView *view = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:@"无法完成本次操作，此手机号已被其他账号绑定" message:@"如需绑定该手机号，可先用该手机号登录，通过解绑功能释放该手机号" leftButtonTitle:@"知道了" rightButtonTitle:nil];
                view.textAlignment = NSTextAlignmentLeft;
            
                return;
            }
        }
    }];
}



#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_LoginCell" forIndexPath:indexPath];
    [cell setChangePhoneDataWithIndexPath:indexPath model:self.dic placeArr:self.places];
    WeakSelf(obj);
    cell.tfBlock = ^(JUDIAN_READ_LoginCell *cellSelf, NSString *text) {
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            NSString *str = text;
            if ([text length] >= 11) {
                str = [text substringToIndex:11];
                cellSelf.inputTF.text = str;
            }
            indexPath.row == 0 ? [obj.dic setObject:str forKey:@"old_mobile"] : [obj.dic setObject:str forKey:@"mobile"];
        }else{
            [obj.dic setObject:text forKey:@"code"];
        }
        if ([obj.dic[@"old_mobile"] length] && [obj.dic[@"code"] length] && [obj.dic[@"mobile"]  length]) {
            [obj.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            obj.loginBtn.userInteractionEnabled = YES;
        }else{
            [obj.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
            obj.loginBtn.userInteractionEnabled = NO;
        }
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            if (text.length >= 11) {
                [obj.tableView endEditing:YES];
                [obj.tableView reloadData];
            }else{
                [obj.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationNone];

            }
        }
    };
    cell.getBlock = ^(id cellSelf,id btn){
        [obj sendPhoneCode:btn];
        obj.btn = btn;
        
    };
    return cell;
}

- (void)sendPhoneCode:(JUDIAN_READER_PhoneCodeButton *)btn{
    if (!self.dic[@"mobile"]) {
        [MBProgressHUD showMessage:@"请输入手机号"];
        return;
    }
    
    if (![JUDIAN_READ_TestHelper isMobileNumber:self.dic[@"mobile"]]) {
        [MBProgressHUD showMessage:@"手机号输入有误"];
        return;
    }
    if ([self.dic[@"mobile"] isEqualToString:self.dic[@"old_mobile"]]) {
        [MBProgressHUD showMessage:@"请输入不同的新手机号"];
        return;
    }
    
    
    NSDictionary *params = @{@"mobile" : self.dic[@"mobile"],@"old_mobile":self.dic[@"old_mobile"]};
    [JUDIAN_READ_MyTool checkMobileWithParams:params completionBlock:^(id result, id error) {
        if (result) {
            [self sendCode:btn];
        }else{
            if ([error code] == 109) {
                JUDIAN_READ_CustomAlertView *view = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:@"无法完成本次操作，此手机号已被其他账号绑定" message:@"如需绑定该手机号，可先用该手机号登录，通过解绑功能释放该手机号" leftButtonTitle:@"知道了" rightButtonTitle:nil];
                view.textAlignment = NSTextAlignmentLeft;
                return;
            }
        }
    }];
}

- (void)sendCode:(JUDIAN_READER_PhoneCodeButton *)btn{
    NSDictionary *params = @{@"mobile" : self.dic[@"mobile"]};
    [JUDIAN_READ_MyTool getPhoneCodeWithParams:params completionBlock:^(id result, NSError *error) {
        if (result) {
            [MBProgressHUD showMessage:@"验证码发送成功"];
            [btn startUpTimer];
        }else{
            [btn invalidateTimer];
        }
    }];
}


@end
