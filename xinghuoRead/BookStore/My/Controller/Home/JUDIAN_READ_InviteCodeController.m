//
//  JUDIAN_READ_GoldCoinController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/17.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_InviteCodeController.h"
#import "JUDIAN_READ_BaseTextFiled.h"
#import "JUDIAN_READ_ReadRankModel.h"

@interface JUDIAN_READ_InviteCodeController ()

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UIView  *tableFooterView;
@property (nonatomic,strong) UIImageView  *iconView;
@property (nonatomic,strong) UILabel  *nameLab;
@property (nonatomic,strong) UIView  *noticeView;


@property (nonatomic,strong) JUDIAN_READ_BaseTextFiled *tf;
@property (nonatomic,strong) UIButton  *btn;

@end

@implementation JUDIAN_READ_InviteCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写邀请人";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)addItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content - 120)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headView;
        
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [_tableView addGestureRecognizer:tapGuesture];
    }
    return _tableView;
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 46)];
        lab.numberOfLines = 0;
        NSString *text = @"绑定邀请\n一起读书，一起赚元宝";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 6;
        NSDictionary *dic = @{NSFontAttributeName:kFontSize14,NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:kColor153};
        NSDictionary *dic1 = @{NSFontAttributeName:kFontSize19,NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:kColor51};
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text attributes:dic];
        [attributeStr addAttributes:dic1 range:NSMakeRange(0, 4)];
        lab.attributedText = attributeStr;
        [_headView addSubview:lab];
        
        _tf = [[JUDIAN_READ_BaseTextFiled alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lab.frame)+30, SCREEN_WIDTH-30, 45) placeHolder:@"请输入邀请码" textFont:kFontSize17 searchImage:nil];
        _tf.textColor = kColor51;
        [_tf addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
        _tf.keyboardType = UIKeyboardTypeNumberPad;
        [_headView addSubview:_tf];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_tf.frame), SCREEN_WIDTH - 30, 1)];
        sepView.backgroundColor = KSepColor;
        [_headView addSubview:sepView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(14, CGRectGetMaxY(sepView.frame)+34, SCREEN_WIDTH-30, 47);
        [btn addTarget:self action:@selector(bindAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setText:@"绑定" titleFontSize:16 titleColot:kColorWhite];
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [btn doBorderWidth:0 color:nil cornerRadius:3];
        self.btn = btn;
        [_headView addSubview:btn];
        
        
    }
    return _headView;
}


- (void)valueChange:(UITextField *)tf{
    NSString *str = tf.text;
    if (str.length >= 8) {
        if (str.length >= 15) {
            [tf resignFirstResponder];
            tf.text = [str substringToIndex:15];
        }
        self.btn.userInteractionEnabled = YES;
        [self.btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [JUDIAN_READ_MyTool InputCodeWithParams:@{@"uid_b":tf.text,@"isself":@"false"} completionBlock:^(id result, id error) {
            if (result) {
                JUDIAN_READ_ReadRankModel *model = result;
                if (!model.uidb || !model.uidb.length) {
                    if (self.tableView.tableFooterView) {
                        self.tableView.tableFooterView = nil;
                    }
                }else{
                    if (!self.tableView.tableFooterView) {
                        self.tableView.tableFooterView = self.tableFooterView;
                    }
                    self.nameLab.text = model.nickname;
                    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"head_default_big"]];
                }

            }else{
                if (self.tableView.tableFooterView) {
                    self.tableView.tableFooterView = nil;
                }
            }
        }];
    }else{
        [self setBtnStatus];
    }
}

- (void)setBtnStatus{
    self.btn.userInteractionEnabled = NO;
    [self.btn setBackgroundImage:[UIImage imageNamed:@"login_button2"] forState:UIControlStateNormal];
    if (self.tableView.tableFooterView) {
        self.tableView.tableFooterView = nil;
    }
}

- (void)bindAction{
    if (!self.tf.text || ![JUDIAN_READ_Account currentAccount].uid) {
        return;
    }
    [JUDIAN_READ_MyTool inputInviteCodeWithParams:@{@"nvitationUidb":self.tf.text,@"guestUidb":[JUDIAN_READ_Account currentAccount].uid} completionBlock:^(id result, id error) {
        if(result){
            [MBProgressHUD showMessage:@"绑定成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
//            [MBProgressHUD showMessage:@"绑定失败"];
        }
    }];
    
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-53)/2, 33, 53, 53)];
        self.iconView.image = [UIImage imageNamed:@"head_default_big"];
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.iconView doBorderWidth:0 color:nil cornerRadius:53/2.0];
        [_tableFooterView addSubview:self.iconView];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 8+CGRectGetMaxY(self.iconView.frame), SCREEN_WIDTH, 12)];
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        [self.nameLab setText:@" " titleFontSize:12 titleColot:kColor51];
        [_tableFooterView addSubview:self.nameLab];
        
        UILabel *inviteLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2.0, 8+CGRectGetMaxY(self.nameLab.frame), 60, 18)];
        inviteLab.textAlignment = NSTextAlignmentCenter;
        [inviteLab setText:@"当前邀请人" titleFontSize:10 titleColot:kThemeColor];
        [inviteLab doBorderWidth:0.5 color:kThemeColor cornerRadius:9];
        [_tableFooterView addSubview:inviteLab];
    }
    return _tableFooterView;
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Content - 120, SCREEN_WIDTH, 120)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 100)];
        lab.numberOfLines = 0;
        NSString *text = @"温馨提示：\n1.邀请码可向好友索取，填写后可获得随机元宝；\n2.邀请码登录起3天内有效，过期后则不可填写；\n3.一台手机只能填写一次邀请码，填写成功后，即使切换账号也无法填写其他邀请码。";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 7;
        NSDictionary *dic = @{NSFontAttributeName:kFontSize12,NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:kColor153};
        NSDictionary *dic1 = @{NSFontAttributeName:kFontSize12,NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:kColor100};
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text attributes:dic];
        [attributeStr addAttributes:dic1 range:NSMakeRange(0, 5)];
        lab.attributedText = attributeStr;
        [_footView addSubview:lab];
    }
    return _footView;
}

- (UIView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _noticeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2, (ScreenHeight-290)/2, 240, 230)];
        view.backgroundColor = kColorWhite;
        [view doBorderWidth:0 color:nil cornerRadius:7];
        [_noticeView addSubview:view];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, 80)];
        [lab setText:@"温馨提示" titleFontSize:19 titleColot:kColor51];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, view.width - 40, 66)];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        lab1.numberOfLines = 0;
        paraStyle.lineSpacing = 7;
        NSString *text = @"如果当前不绑定，也可在“我的-输入邀请码”中进行绑定，登录成功后，3天内绑定有效。";
        NSDictionary *dic = @{NSFontAttributeName:kFontSize14,NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:kColor100};
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text attributes:dic];
        lab1.attributedText = attributeStr;
        [view addSubview:lab1];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateHighlighted];
        [btn3 setText:@"确定" titleFontSize:16 titleColot:kColorWhite];
        [btn3 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        btn3.frame = CGRectMake(17, view.height - 40 - 17, view.width - 34, 40);
        [btn3 doBorderWidth:0 color:nil cornerRadius:20];
        [view addSubview:btn3];
        
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake((SCREEN_WIDTH-33)/2, CGRectGetMaxY(view.frame) + 27, 33, 33);
        [delBtn setImage:[UIImage imageNamed:@"close_prompt_button"] forState:UIControlStateNormal];
        [delBtn setImage:[UIImage imageNamed:@"close_prompt_button"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [_noticeView addSubview:delBtn];
        
        
    }
    return _noticeView;
}

- (void)delAction{
    [self.noticeView removeFromSuperview];
}

- (void)sureAction{
    [self.noticeView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}




#pragma mark 返回
- (void)cancel{
    [kKeyWindow addSubview:self.noticeView];
}



@end
