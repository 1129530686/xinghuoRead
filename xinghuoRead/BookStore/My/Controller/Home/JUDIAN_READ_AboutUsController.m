//
//  JUDIAN_READ_AboutUsController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_AboutUsController.h"
#import "JUDIAN_READ_ProtocolController.h"

@interface JUDIAN_READ_AboutUsController ()<UITextViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray  *leadArr;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UITextView  *serviceLab;
@property (nonatomic,strong) UITextView  *serviceLab1;
@property (nonatomic,strong) UIButton  *versionlab;
@property (nonatomic,strong) UILabel  *redLab;
@property (nonatomic,strong) NSDictionary  *dic;


@end

@implementation JUDIAN_READ_AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self initHeadView];
    [self loadData];
    [self.view addSubview:self.tableView];
    [self loadData1];
}
#pragma mark 加载数据
- (void)loadData1{
    [JUDIAN_READ_MyTool getAboutUsWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            self.dic = result;
            NSDictionary *dic = @{NSFontAttributeName:kFontSize12,NSForegroundColorAttributeName:kColor100};
            NSString *str = [NSString stringWithFormat:@"客服QQ群:%@\n",self.dic[@"qq"]];
            NSString *str1 = [self.dic[@"wx"] length] ? [NSString stringWithFormat:@"客服微信号：%@",self.dic[@"wx"]] : @"";
            self.serviceLab.attributedText = [[NSAttributedString alloc]initWithString:str attributes:dic];
            self.serviceLab1.attributedText = [[NSAttributedString alloc]initWithString:str1 attributes:dic];
        }
    }];
    
}

#pragma mark 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
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


- (void)initHeadView{
    _headView = [[UIView alloc]initWithFrame:ViewFrame];
    self.tableView.tableHeaderView = self.headView;

    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imgView.image = [UIImage imageNamed:@"aboutus_icon_logo"];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
    [nameLab setText:@"追书宝" titleFontSize:17 titleColot:kColor51];
    nameLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectZero];
    [versionLab setText:[NSString stringWithFormat:@"版本：V%@",GET_VERSION_NUMBER] titleFontSize:14 titleColot:kColor153];
    versionLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btn setText:@"已是最新版本" titleFontSize:12 titleColot:kColor153];
    [btn setText:@"" titleFontSize:12 titleColot:kColor153];
    [btn addTarget:self action:@selector(checkVersion) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.versionlab = btn;
    btn.userInteractionEnabled = NO;
    
    UILabel *redLab = [[UILabel alloc]initWithFrame:CGRectZero];
    [redLab doBorderWidth:0 color:nil cornerRadius:2.5];
    redLab.backgroundColor = kThemeColor;
    redLab.hidden = YES;
    self.redLab = redLab;
    
    self.serviceLab = [[UITextView alloc]initWithFrame:CGRectZero];
    [self.serviceLab setText:@"" titleFontSize:12 titleColot:kColor100];
    self.serviceLab.scrollEnabled = NO;
    self.serviceLab.editable = NO;
    self.serviceLab.textAlignment = NSTextAlignmentCenter;
    
    self.serviceLab1 = [[UITextView alloc]initWithFrame:CGRectZero];
    [self.serviceLab1 setText:@"" titleFontSize:12 titleColot:kColor100];
    self.serviceLab1.scrollEnabled = NO;
    self.serviceLab1.editable = NO;
    self.serviceLab1.textAlignment = NSTextAlignmentCenter;
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:qqBtn];
    

    UITextView *lab = [[UITextView alloc]initWithFrame:CGRectZero];
    lab.textColor = kColor100;
    lab.font = kFontSize12;
    lab.editable = NO;
    lab.delegate = self;
    NSString *Str = @"《用户服务协议》《隐私协议》";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:Str];
    NSRange range = NSMakeRange(0, 8);
    NSRange range1 = NSMakeRange(Str.length-6, 6);
    [att addAttributes:@{NSLinkAttributeName:@"user",NSForegroundColorAttributeName:kColorBlue} range:range];
    [att addAttributes:@{NSForegroundColorAttributeName:kColorBlue,NSLinkAttributeName:@"security"} range:range1];
    lab.attributedText = att;
    lab.textAlignment = NSTextAlignmentCenter;
    
    
    [_headView addSubview:imgView];
    [_headView addSubview:nameLab];
    [_headView addSubview:versionLab];
    [_headView addSubview:btn];
    [_headView addSubview:redLab];
    [_headView addSubview:self.serviceLab];
    [_headView addSubview:self.serviceLab1];
    [_headView addSubview:lab];

    
    WeakSelf(weakSelf);
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@66);
        make.width.height.equalTo(@100);
        make.centerX.equalTo(weakSelf.headView);
    }];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(13);
        make.left.equalTo(weakSelf.headView);
        make.width.equalTo(@SCREEN_WIDTH);
    }];
    
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(7);
        make.left.equalTo(weakSelf.headView);
        make.width.equalTo(@SCREEN_WIDTH);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLab.mas_bottom).offset(15);
        make.centerX.equalTo(@0);
    }];
    
    [redLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn).offset(4.5);
        make.left.equalTo(btn.mas_right);
        make.width.height.equalTo(@5);
    }];
    
    [self.serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf .headView.mas_bottom).offset(-110);
//        make.centerX.equalTo(weakSelf.headView);
        make.width.equalTo(@140);
        make.left.equalTo(@((ScreenWidth - 220)/2.0));
        make.height.equalTo(@25);
    }];
    
    [self.serviceLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf .headView.mas_bottom).offset(-80);
        make.centerX.equalTo(weakSelf.headView);
        make.height.equalTo(@25);
    }];
    
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@73);
        make.left.equalTo(weakSelf.serviceLab.mas_right);
        make.top.equalTo(weakSelf.serviceLab.mas_top).offset(5);
    }];
    
    
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-33));
        make.left.equalTo(weakSelf.headView);
        make.width.equalTo(@SCREEN_WIDTH);
        make.height.equalTo(@24);
    }];
 
    
}

- (BOOL)join{
    return [JUDIAN_READ_TestHelper joinQQGroup];
}


- (void)checkVersion{
    NSString * url = APPSTORE_URL;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    JUDIAN_READ_ProtocolController *vc = [JUDIAN_READ_ProtocolController new];
    vc.value = URL.absoluteString;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}


- (void)loadData{

    if ([JUDIAN_READ_TestHelper needUpdate]) {
        [self.versionlab setTitle:@"立即更新" forState:UIControlStateNormal];
        self.versionlab.userInteractionEnabled = YES;
        self.redLab.hidden = NO;
    }else{
        [self.versionlab setTitle:@"" forState:UIControlStateNormal];
        self.versionlab.userInteractionEnabled = NO;
        self.redLab.hidden = YES;
    }
}

@end
