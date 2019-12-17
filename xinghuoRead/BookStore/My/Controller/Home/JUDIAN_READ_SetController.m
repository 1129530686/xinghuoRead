//
//  JUDIAN_READ_SetController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SetController.h"
#import "JUDIAN_READ_MyHomeCell.h"
#import "JUDIAN_READ_ChangePhoneController.h"
#import <UMShare/UMShare.h>
#import "JUDIAN_READ_LoginController.h"


@interface JUDIAN_READ_SetController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray  *leadArr;
@property (nonatomic,strong) UIView  *footView;

@end

@implementation JUDIAN_READ_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.tableView];
    if ([JUDIAN_READ_Account currentAccount].token) {
        [self.view addSubview:self.footView];
    }
}


#pragma mark Tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leadArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_MyHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseHomeCell" forIndexPath:indexPath];
    [cell setSetDataWithModel:self.leadArr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (![JUDIAN_READ_Account currentAccount].token.length) {//未登录
            JUDIAN_READ_LoginController *vc = [JUDIAN_READ_LoginController new];
            vc.isPhoneLogin = YES;
            vc.bindSuccess = ^{
                [self refreshData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ([JUDIAN_READ_Account currentAccount].bind_mobile.integerValue == 0) {//未绑定
                JUDIAN_READ_LoginController *vc = [JUDIAN_READ_LoginController new];
                vc.isBind = YES;
                vc.bindSuccess = ^{
                    [self refreshData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{//更换
                JUDIAN_READ_ChangePhoneController *vc = [JUDIAN_READ_ChangePhoneController new];
                vc.refreshBlock = ^{
                    [self refreshData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        if ([JUDIAN_READ_Account currentAccount].bind_wechat.integerValue == 0) {//绑定微信
            if (![JUDIAN_READ_Account currentAccount].token.length) {//未登录
                [self getAuthWithUserInfoFromWechat:1];

            }else{
                [self getAuthWithUserInfoFromWechat:0];
            }
           // [self refreshData];
        }
        
    }
}

- (void)refreshData{
    [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            if ([JUDIAN_READ_Account currentAccount].token) {
                [self.view addSubview:self.footView];
            }
            [self.tableView reloadData];
        }
    }];
}


#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_MyHomeCell class]) bundle:nil] forCellReuseIdentifier:@"ReuseHomeCell"];
    }
    return _tableView;
}

- (NSMutableArray *)leadArr{
    if (!_leadArr) {
        _leadArr = [NSMutableArray arrayWithObjects:@"手机号",@"微信", nil];
    }
    return _leadArr;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60-Height_NavBar-BottomHeight, SCREEN_WIDTH, 60)];
        UIButton *lab = [UIButton buttonWithType:UIButtonTypeCustom];
        lab.frame = CGRectMake(0, 10, SCREEN_WIDTH, 50);
        [lab setText:@"退出" titleFontSize:16 titleColot:kColor51];
        [lab setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [lab addTarget:self action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:lab];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kBackColor;
        [_footView addSubview:view];
    }
    return _footView;
}

- (void)loginout{
    [JUDIAN_READ_MyTool loginOutWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            [MBProgressHUD showMessage:@"退出登录成功"];
            [self.footView removeFromSuperview];
            [self.tableView reloadData];
        }
    }];
}


- (void)getAuthWithUserInfoFromWechat:(BOOL)isLogining{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
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
            NSDictionary *dic = @{@"nickname":resp.name,@"auth_type":@"wechat",@"openid":resp.openid,@"unionid":resp.unionId,@"avatar":resp.iconurl,@"sex":resp.unionGender};

            if (isLogining) { //如果是登录
                [JUDIAN_READ_MyTool loginInWithParams:dic completionBlock:^(id result, id error) {
                    if (result) {
                        [MBProgressHUD showMessage:@"登录成功"];
                        [self refreshData];
                    }
                }];
            }else{//如果是绑定
                [JUDIAN_READ_MyTool bindWechatWithParams:dic completionBlock:^(id result, id error) {
                    if (result) {
                        [MBProgressHUD showMessage:@"绑定成功"];
                        [self refreshData];
                    }else{
                        if([error code] == 109){
                            [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:nil message:@"无法完成本次操作，此微信号已被其他人账号绑定" leftButtonTitle:@"知道了" rightButtonTitle:nil];
                        }
                    }
                }];
                
            }
            
        }
    }];
}



@end
