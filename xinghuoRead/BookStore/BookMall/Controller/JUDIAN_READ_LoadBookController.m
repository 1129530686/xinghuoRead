//
//  JUDIAN_READ_LoadBookController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_LoadBookController.h"
#import "JUDIAN_READ_BaseTextFiled.h"
#import "JUDIAN_READ_TextView.h"

@interface JUDIAN_READ_LoadBookController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTextFiled  *mySearchBar;
@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UIButton  *btn;
@property (nonatomic,strong) JUDIAN_READ_TextView  *textView;
@property (nonatomic,strong) NSMutableDictionary  *dic;

@end

@implementation JUDIAN_READ_LoadBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要求书";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btn];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:ViewFrame style:UITableViewStylePlain];
        _tableView.rowHeight = 0;
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = self.footView;
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
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63)];
        _headView.backgroundColor = kColorWhite;
        
        [_headView addSubview:self.mySearchBar];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, 10)];
        view.backgroundColor = KSepColor;
        [_headView addSubview:view];
    }
    return _headView;
}

- (JUDIAN_READ_BaseTextFiled *)mySearchBar{
    if (!_mySearchBar) {
        _mySearchBar = [[JUDIAN_READ_BaseTextFiled alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 33) placeHolder:@"请输入书名" textFont:[UIFont systemFontOfSize:13] searchImage:nil];
        _mySearchBar.textColor = kColor51;
        _mySearchBar.text = self.searchTitle;
        [_mySearchBar addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mySearchBar;
}

- (void)valueChange:(UITextField *)tf{
    if ([tf.text length]) {
        [self.btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay2"] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
        [self.dic setObject:tf.text forKey:@"content"];
    }else{
        [self.btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay_sel"] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = NO;
    }
}

- (NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content - 63 - 50)];
        _footView.backgroundColor = kColorWhite;
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [titleLab setText:@"您输入的内容为？" titleFontSize:14 titleColot:kColor51];
        [_footView addSubview:titleLab];
        
        UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selBtn.tag = 100;
        [selBtn setText:@"书籍名称" titleFontSize:13 titleColot:kThemeColor];
        [selBtn setImage:[UIImage imageNamed:@"please_book_radio"] forState:UIControlStateNormal];
        [selBtn addTarget:self action:@selector(selAction:) forControlEvents:UIControlEventTouchUpInside];
        [selBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [selBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_footView addSubview:selBtn];

        UIButton *selBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        selBtn1.tag = 1000;
        [selBtn1 setText:@"作者名称" titleFontSize:13 titleColot:kColor153];
        [selBtn1 setImage:[UIImage imageNamed:@"please_book_radio2"] forState:UIControlStateNormal];
        [selBtn1 addTarget:self action:@selector(selAction:) forControlEvents:UIControlEventTouchUpInside];
        [selBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [selBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_footView addSubview:selBtn1];
        
        self.textView = [[JUDIAN_READ_TextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 133)];
        self.textView.textColor = kColor51;
        self.textView.placeholder = @"您还可输入图书简介及内容，提高搜索效率";
        self.textView.placeholderColor = kColor204;
        [self.textView doBorderWidth:0.5 color:kColor204 cornerRadius:3];
        self.textView.textContainerInset = UIEdgeInsetsMake(7, 7, 0, 7);
        [_footView addSubview:self.textView];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
        }];
        
        [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(SCREEN_WIDTH/2.0);
            make.top.equalTo(titleLab.mas_bottom).offset(12);
        }];
        
        [selBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH/2.0);
            make.top.mas_equalTo(selBtn);
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selBtn.mas_bottom).offset(20);
            make.width.mas_equalTo(SCREEN_WIDTH-30);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(133);
        }];
        
        
        
    }
    return _footView;
}

- (void)selAction:(UIButton *)btn{
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"please_book_radio"] forState:UIControlStateNormal];
    int tag = btn.tag == 100 ? 1000 : 100;
    UIButton *unBtn = [self.footView viewWithTag:tag];
    [unBtn setTitleColor:kColor153 forState:UIControlStateNormal];
    [unBtn setImage:[UIImage imageNamed:@"please_book_radio2"] forState:UIControlStateNormal];
}



- (UIButton *)btn{
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, Height_Content-50, SCREEN_WIDTH, 50);
        [btn setText:@"提交" titleFontSize:16 titleColot:kColorWhite];
        [btn addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay2_sel"] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = NO;
        _btn = btn;
    }
    return _btn;
}

- (void)uploadData{
    
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












@end
