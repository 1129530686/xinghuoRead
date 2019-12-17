//
//  JUDIAN_READ_LoginController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/28.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_LoginCell.h"
#import "JUDIAN_READ_LoginController.h"
#import "JUDIAN_READER_PhoneCodeButton.h"
#import "JUDIAN_READ_ProtocolController.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface JUDIAN_READ_LoginController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) NSMutableDictionary  *dic;
@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) NSTimer  *timer;
@property (nonatomic,assign) NSInteger durationToValidity;
@property (nonatomic,assign) JUDIAN_READER_PhoneCodeButton  *btn;
@property (nonatomic,assign) BOOL  isSelect;


@end

@implementation JUDIAN_READ_LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
 //   [IQKeyboardManager sharedManager].enable = YES;
    if (!self.isBind) {
        self.title = @"登录";
        [GTCountSDK trackCountEvent:@"pv_login_page" withArgs:@{@"loginPageExposeure":@"登录页面曝光"}];
        [MobClick event:@"pv_login_page" attributes:@{@"loginPageExposeure":@"登录页面曝光"}];
    }else{
        self.title = @"绑定手机号";
    }
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    //[IQKeyboardManager sharedManager].enable = NO;
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

- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content - 140)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 34, SCREEN_WIDTH-30, 47);
        if (!self.isBind) {
            [btn setText:@"新用户登录 领20元宝" titleFontSize:16 titleColot:kColorWhite];
        }else{
            [btn setText:@"立即绑定" titleFontSize:16 titleColot:kColorWhite];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
        btn.userInteractionEnabled = NO;
        [_footView addSubview:btn];
        self.loginBtn = btn;
        
        UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(10, 10+81, 23, 23);
        [selBtn setImage:[UIImage imageNamed:@"login_agreement"] forState:UIControlStateNormal];
//        [selBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:selBtn];
        self.isSelect = YES;
     
        UITextView *lab = [[UITextView alloc]initWithFrame:CGRectMake(33, 7+81, SCREEN_WIDTH-15-38, 24)];
        lab.textColor = kColor100;
        lab.font = kFontSize12;
        lab.editable = NO;
        lab.delegate = self;
        NSString *Str = @"登录即同意《用户服务协议》和《隐私协议》";
        if (self.isBind) {
            Str = @"绑定即同意《用户服务协议》和《隐私协议》";
        }
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:Str];
        NSRange range = NSMakeRange(5, 8);
        NSRange range1 = NSMakeRange(Str.length-6, 6);
        [att addAttributes:@{NSLinkAttributeName:@"user",NSForegroundColorAttributeName:kColorBlue} range:range];
        [att addAttributes:@{NSForegroundColorAttributeName:kColorBlue,NSLinkAttributeName:@"security"} range:range1];
        lab.attributedText = att;
        [_footView addSubview:lab];
        
        if (!self.isBind && !self.isPhoneLogin) {
            UILabel *loginLab = [[UILabel alloc]initWithFrame:CGRectZero];
            [loginLab setText:@"其他登录方式" titleFontSize:12 titleColot:kColor153];
            [_footView addSubview:loginLab];
            [loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@-115);
            }];
            
            
            UIView *sepview1 = [[UIView alloc]initWithFrame:CGRectZero];
            sepview1.backgroundColor = KSepColor;
            [_footView addSubview:sepview1];
            [sepview1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.left.equalTo(@15);
                make.centerY.equalTo(loginLab);
                make.right.equalTo(loginLab.mas_left).offset(-8);
            }];
            
            UIView *sepview2 = [[UIView alloc]initWithFrame:CGRectZero];
            sepview2.backgroundColor = KSepColor;
            [_footView addSubview:sepview2];
            [sepview2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.left.equalTo(loginLab.mas_right).offset(8);
                make.centerY.equalTo(loginLab);
                make.right.equalTo(@-15);
            }];
            
            
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginBtn setImage:[UIImage imageNamed:@"weixin_logo"] forState:UIControlStateNormal];
            [loginBtn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
            [_footView addSubview:loginBtn];
            [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@0);
                make.width.height.equalTo(@47);
                make.bottom.equalTo(@(-49));
            }];
            
            UILabel *botomLab = [[UILabel alloc]initWithFrame:CGRectZero];
            [botomLab setText:@"微信登录" titleFontSize:12 titleColot:kColor153];
            [_footView addSubview:botomLab];
            [botomLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@0);
                make.top.equalTo(loginBtn.mas_bottom).offset(8);
            }];
        }
        
        
       
    }
    return _footView;
}

//登陆
- (void)loginIn{
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    NSDictionary* dic = @{click_login : @"点击登录",
                          @"device" : deviceName,
                          };
    [MobClick event:LoginRecord attributes:dic];
    [GTCountSDK trackCountEvent:@"login" withArgs:dic];

    if (!self.dic[@"mobile"]) {
        [MBProgressHUD showMessage:@"请输入手机号"];
        return;
    }
    if (![JUDIAN_READ_TestHelper isMobileNumber:self.dic[@"mobile"]]) {
        [MBProgressHUD showMessage:@"手机号输入有误"];
        return;
    }
    if (!self.dic[@"code"]) {
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    [self.view endEditing:YES];
    if (self.isBind) {
        [JUDIAN_READ_MyTool bindPhoneWithParams:self.dic completionBlock:^(id result, id error) {
            if (result) {
                [MBProgressHUD showMessage:@"绑定成功"];
                if (self.bindSuccess) {
                    self.bindSuccess();
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
    }else{
        [JUDIAN_READ_MyTool loginInWithPhoneParams:self.dic completionBlock:^(id result, id error) {
            if (result) {
                [MobClick event:LoginRecord attributes:@{login_success:phone_number}];
                [GTCountSDK trackCountEvent:LoginRecord withArgs:@{login_success:phone_number}];
                [MBProgressHUD showMessage:@"登录成功"];
                [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
                   
                    if (self.bindSuccess) {
                        self.bindSuccess();
                    }
                    if (self.isFromweChatLogin) {
                        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    if (self.vcString) {
                        id vc = [NSClassFromString(self.vcString) new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    return ;
                }];
            }
        }];
    }
  
}

//同意用户协议
- (void)selectAction:(UIButton *)btn{
    self.isSelect = !self.isSelect;
    if (self.isSelect) {
        [MobClick event:LoginRecord attributes:@{select_ua:@"选择用户协议"}];
        [btn setImage:[UIImage imageNamed:@"login_agreement"] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
        if ([self.dic[@"mobile"] length] && [self.dic[@"code"] length]) {
            [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        }
    }else{
        [btn setImage:[UIImage imageNamed:@"login_agreement2"] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = NO;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
    }
}


- (void)wechatLogin{
    [self getAuthWithUserInfoFromWechat];
}


// 在需要进行获取用户信息的UIViewController中加入如下代码
- (void)getAuthWithUserInfoFromWechat
{
    [MobClick event:LoginRecord attributes:@{wechat_quick_login:@"微信快捷登录"}];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        
        if (!error) {
            UMSocialUserInfoResponse *resp = result;
            NSDictionary *dic = @{@"nickname":resp.name,@"auth_type":@"wechat",@"openid":resp.openid,@"unionid":resp.unionId,@"avatar":resp.iconurl,@"sex":resp.unionGender};
            [JUDIAN_READ_MyTool loginInWithParams:dic completionBlock:^(id result, id error) {
                if (result) {
                    [MBProgressHUD showMessage:@"登录成功"];
                    [MobClick event:LoginRecord attributes:@{login_success:wechat}];

                    [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
                        if (self.bindSuccess) {
                            self.bindSuccess();
                        }

                        if (self.isFromweChatLogin) {
                            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        if (self.vcString) {
                            id vc = [NSClassFromString(self.vcString) new];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        return ;
                    }];

                    
                }
            }];
        }
    }];
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
    
    if (indexPath.row == 0) {
        [cell setKeyboardType:(UIKeyboardTypePhonePad)];
    }
    else if (indexPath.row == 1) {
        [cell setKeyboardType:(UIKeyboardTypeNumberPad)];
    }
    
    [cell setDataWithIndexPath:indexPath model:self.dic];
    WeakSelf(obj);
    cell.tfBlock = ^(JUDIAN_READ_LoginCell *cellSelf, NSString *text) {
       
        if (indexPath.row == 0) {
            NSString *str = text;
            if ([text length] >= 11) {
                str = [text substringToIndex:11];
                cellSelf.inputTF.text = str;
            }
            [obj.dic setObject:str forKey:@"mobile"];
            [GTCountSDK trackCountEvent:@"login" withArgs:@{input_phone_number:@"输入手机号"}];
            [MobClick event:LoginRecord attributes:@{input_phone_number:@"输入手机号"}];
        }else{
            if (text.length >= 4) {
                NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
                if (!deviceName) {
                    deviceName = @"";
                }
                NSDictionary* dic = @{input_phone_code : @"输入验证码",
                                      @"device" : deviceName,
                                      };
                [MobClick event:LoginRecord attributes:dic];
                [GTCountSDK trackCountEvent:@"login" withArgs:@{input_phone_code: @"输入验证码"}];

            }
            [obj.dic setObject:text forKey:@"code"];
        }
        if ([obj.dic[@"mobile"] length] && [obj.dic[@"code"] length]) {
            [obj.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            obj.loginBtn.userInteractionEnabled = YES;
        }else{
            [obj.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
            obj.loginBtn.userInteractionEnabled = NO;
        }
        
        if (indexPath.row == 0) {
            if (text.length >= 11) {
                [obj.tableView endEditing:YES];
                [obj.tableView reloadData];
            }else{
                [obj.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    };
    cell.getBlock = ^(id cellSelf,id btn){
        NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
        if (!deviceName) {
            deviceName = @"";
        }
        NSDictionary* dic = @{get_phone_code : @"获取验证码",
                              @"device" : deviceName,
                              };
        [MobClick event:LoginRecord attributes:dic];
        [GTCountSDK trackCountEvent:@"login" withArgs:@{get_phone_code:@"获取验证码"}];

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
    
    if (self.isBind) {
        NSDictionary *params = @{@"mobile" : self.dic[@"mobile"]};
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
    }else{
        [self sendCode:btn];
    }
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


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    JUDIAN_READ_ProtocolController *vc = [JUDIAN_READ_ProtocolController new];
    vc.value = URL.absoluteString;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        [self.view endEditing:YES];
    }
}



@end
