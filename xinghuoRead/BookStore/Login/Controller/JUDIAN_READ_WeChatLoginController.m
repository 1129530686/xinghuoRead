//
//  JUDIAN_READ_WeChatLoginController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/15.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_LoginController.h"
#import "JUDIAN_READ_ProtocolController.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>


@interface JUDIAN_READ_WeChatLoginController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,assign) BOOL  isSelect;


@end

@implementation JUDIAN_READ_WeChatLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //[IQKeyboardManager sharedManager].enable = YES;

    self.title = @"登录";
    [GTCountSDK trackCountEvent:@"pv_login_page" withArgs:@{@"loginPageExposeure":@"登录页面曝光"}];
    [MobClick event:@"pv_login_page" attributes:@{@"loginPageExposeure":@"登录页面曝光"}];

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
        _tableView.tableHeaderView = self.headView;
        _tableView.rowHeight = 70;
    }
    return _tableView;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 176)];
        UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_wechat_app_icon"]];
        [_headView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@37);
            make.width.height.equalTo(@73);
        }];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 15)];
        [lab setText:@"海量正版小说，全部免费" titleFontSize:14 titleColot:kColor100];
        lab.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:lab];
        
    }
    return _headView;
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content - 176)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 47);
        [btn setText:@"新用户登录 领20元宝" titleFontSize:16 titleColot:kColorWhite];
        [btn setImage:[UIImage imageNamed:@"login_btn_wechat_icon"] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        self.loginBtn = btn;
        
        UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(10, 10+81-34, 23, 23);
        [selBtn setImage:[UIImage imageNamed:@"login_agreement"] forState:UIControlStateNormal];
//        [selBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:selBtn];
        self.isSelect = YES;
        
        UITextView *lab = [[UITextView alloc]initWithFrame:CGRectMake(33, 7+81-34, SCREEN_WIDTH-15-38, 24)];
        lab.textColor = kColor100;
        lab.font = kFontSize12;
        lab.editable = NO;
        lab.delegate = self;
        NSString *Str = @"登录即同意《用户服务协议》和《隐私协议》";
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:Str];
        NSRange range = NSMakeRange(5, 8);
        NSRange range1 = NSMakeRange(Str.length-6, 6);
        [att addAttributes:@{NSLinkAttributeName:@"user",NSForegroundColorAttributeName:kColorBlue} range:range];
        [att addAttributes:@{NSForegroundColorAttributeName:kColorBlue,NSLinkAttributeName:@"security"} range:range1];
        lab.attributedText = att;
        [_footView addSubview:lab];
        
        UILabel *loginLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [loginLab setText:@"其他登录方式" titleFontSize:12 titleColot:kColor153];
        [_footView addSubview:loginLab];
        [loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.equalTo(@(-115-BottomHeight));
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
        [loginBtn setImage:[UIImage imageNamed:@"login_icon_phone"] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(pushController) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.width.height.equalTo(@47);
            make.bottom.equalTo(@(-45-BottomHeight));
        }];
        
        UILabel *botomLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [botomLab setText:@"手机登录" titleFontSize:12 titleColot:kColor153];
        [_footView addSubview:botomLab];
        [botomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(loginBtn.mas_bottom).offset(8);
        }];
        
    }
    return _footView;
}


//同意用户协议
- (void)selectAction:(UIButton *)btn{
    self.isSelect = !self.isSelect;
    if (self.isSelect) {
        [MobClick event:LoginRecord attributes:@{select_ua:@"选择用户协议"}];
        [btn setImage:[UIImage imageNamed:@"login_agreement"] forState:UIControlStateNormal];
        self.loginBtn.userInteractionEnabled = YES;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
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
    [GTCountSDK trackCountEvent:LoginRecord withArgs:@{wechat_quick_login:@"微信快捷登录"}];

    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
#if DEBUG
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
#endif

            NSString* name = resp.name;
            if (name.length <= 0) {
                name = @"";
            }
            
            NSString* openid = resp.openid;
            if (openid.length <= 0) {
                openid = @"";
            }
            
            NSString* unionId = resp.unionId;
            if (unionId.length <= 0) {
                unionId = @"";
            }
            
            NSString* iconurl = resp.iconurl;
            if (iconurl.length <= 0) {
                iconurl = @"";
            }
            
            NSString* unionGender = resp.unionGender;
            if (unionGender.length <= 0) {
                unionGender = @"";
            }
            
            NSDictionary *dic = @{@"nickname" : name,
                                  @"auth_type" : @"wechat",
                                  @"openid" : openid,
                                  @"unionid" : unionId,
                                  @"avatar" : iconurl,
                                  @"sex" : unionGender};
            
            
            [JUDIAN_READ_MyTool loginInWithParams:dic completionBlock:^(id result, id error) {
                if (result) {
                    [MBProgressHUD showMessage:@"登录成功"];
                    [MobClick event:LoginRecord attributes:@{login_success:wechat}];
                    [GTCountSDK trackCountEvent:LoginRecord withArgs:@{login_success:wechat}];

                    [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
                        if (self.loginSuccess) {
                            self.loginSuccess();
                        }
                        [self.navigationController popViewControllerAnimated:YES];

                        if (self.vcString) {
                            id vc = [NSClassFromString(self.vcString) new];
                            [self.navigationController pushViewController:vc animated:YES];
                        }

                    }];
                }
            }];
        }
    }];
}


- (void)pushController{
    JUDIAN_READ_LoginController *vc = [JUDIAN_READ_LoginController new];
    vc.isFromweChatLogin = YES;
    vc.vcString = self.vcString;
    vc.bindSuccess = ^{
        if (self.loginSuccess) {
            self.loginSuccess();
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        return [UITableViewCell new];
}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    JUDIAN_READ_ProtocolController *vc = [JUDIAN_READ_ProtocolController new];
    vc.value = URL.absoluteString;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}





@end
