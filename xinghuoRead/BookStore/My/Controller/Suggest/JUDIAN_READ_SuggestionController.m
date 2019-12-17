//
//  JUDIAN_READ_SuggestionController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SuggestionController.h"
#import "JUDIAN_READ_SuggestionCell.h"
#import "JUDIAN_READ_SuggestDetailController.h"


@interface JUDIAN_READ_SuggestionController ()<UITextViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UITextView  *descLab;
@property (nonatomic,strong) UIButton  *btn;
@property (nonatomic,strong) NSMutableDictionary  *dic;
@property (nonatomic,strong) UIButton  *qqBtn;


@end

@implementation JUDIAN_READ_SuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    //[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //[IQKeyboardManager sharedManager].enable = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btn];
    [self addItem];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[IQKeyboardManager sharedManager].enable = NO;
    //[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)addItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"我的反馈" style:UIBarButtonItemStylePlain target:self action:@selector(detailAction)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)detailAction{
    JUDIAN_READ_SuggestDetailController *vc = [JUDIAN_READ_SuggestDetailController new];
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
- (void)loadData{
    [JUDIAN_READ_MyTool getAboutUsWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            //self.dic = result;
            [self.dic addEntriesFromDictionary:result];

            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            NSDictionary *dic = @{NSFontAttributeName:kFontSize12,NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:kColor153};
            paraStyle.lineSpacing = 5;
            NSString *str = [self.dic[@"wx"] length] ? [NSString stringWithFormat:@"追书宝QQ群：%@\n客服微信号：%@",self.dic[@"qq"],self.dic[@"wx"]] : [NSString stringWithFormat:@"客服QQ群:%@\n",self.dic[@"qq"]];
            
            NSString *str1  = [NSString stringWithFormat:@"追书宝QQ群：%@",self.dic[@"qq"]];
            CGFloat x = [str1 widthForFont:kFontSize12];
            self.qqBtn.hidden = NO;
            self.qqBtn.frame = CGRectMake(x + 20, 7, 73, 17);
            
            self.descLab.attributedText =  [[NSAttributedString alloc]initWithString:str attributes:dic];
        }
    }];
}




- (void)uploadData{
    
    if ([self.dic[@"content"] length] <= 0) {
        [MBProgressHUD showError:@"反馈意见不能为空"];
        return;
    }
 
    [self.dic setObject:GET_VERSION_NUMBER forKey:@"app_version"];
    [self.dic setObject:@"iOS" forKey:@"device_type"];
 
    [JUDIAN_READ_MyTool upLoadSuggestionWithParams:self.dic completionBlock:^(id result, id error) {
            if (result) {
                [MBProgressHUD showMessage:@"提交成功"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
            }
        }];
    
   
}

#pragma mark 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)];
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footView;
        _tableView.bounces = NO;
        _tableView.backgroundColor = kColorWhite;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_SuggestionCell class]) bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_SuggestionCell"];
        
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
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
        UITextView *lab = [[UITextView alloc]initWithFrame:CGRectZero];
        lab.delegate = self;
        lab.scrollEnabled = NO;
        lab.editable = NO;
        self.descLab = lab;
        [_footView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@0);
            make.width.equalTo(@(SCREEN_WIDTH-20));
            make.height.equalTo(@(120));
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lab addSubview:btn];
        [btn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
        [btn doBorderWidth:0 color:nil cornerRadius:2];
        [btn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        btn.hidden = YES;
        self.qqBtn = btn;
        [lab addSubview:btn];
    }
    return _footView;
}

- (BOOL)join{
    return [JUDIAN_READ_TestHelper joinQQGroup];
}





- (UIButton *)btn{
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, Height_Content-50, SCREEN_WIDTH, 50);
        [btn setText:@"提交" titleFontSize:16 titleColot:kColorWhite];
        [btn addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay_sel"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay2_sel"] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = NO;
        _btn = btn;
    }
    return _btn;
}


-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}


#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 170;
    }
    return 88;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_SuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_SuggestionCell" forIndexPath:indexPath];
    [cell setDataWithBaseModel:self.dic[@"content"] indexPath:indexPath];
    WeakSelf(obj);
    cell.inputBlock = ^(JUDIAN_READ_SuggestionCell *cellSelf, id text) {
        if (indexPath.row == 0) {
            if ([text length]) {
                [obj.btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay2"] forState:UIControlStateNormal];
                obj.btn.userInteractionEnabled = YES;
                [obj.dic setObject:text forKey:@"content"];
            }else{
                [obj.btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay_sel"] forState:UIControlStateNormal];
                obj.btn.userInteractionEnabled = NO;
            }
        }else{
            obj.dic[@"contact_way"] = text;
        }
    };
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return NO;
}



@end
