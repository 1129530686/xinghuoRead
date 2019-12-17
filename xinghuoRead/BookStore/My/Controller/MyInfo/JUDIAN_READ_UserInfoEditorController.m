//
//  JUDIAN_READ_UserInfoEditorController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserInfoEditorController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserSignatureCell.h"
#import "JUDIAN_READ_UserInfoEditorCell.h"

#define UserSignatureCell @"UserSignatureCell"
#define UserInfoEditorCell @"UserInfoEditorCell"

@interface JUDIAN_READ_UserInfoEditorController ()
<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, weak)JUDIAN_READ_UserBriefModel* userBriefModel;
@property(nonatomic, copy)NSString* titleText;
@property(nonatomic, copy)NSString* placeholder;
@property(nonatomic, weak)JUDIAN_READ_UserInfoEditorCell* textFieldCell;
@property(nonatomic, weak)JUDIAN_READ_UserSignatureCell* textViewCell;

@end

@implementation JUDIAN_READ_UserInfoEditorController


+ (void)enterUserInfoEditor:(UINavigationController*)navigationController title:(NSString*)title placeholder:(NSString*)placeholder userBriefModel:(JUDIAN_READ_UserBriefModel*)userBriefModel {
    JUDIAN_READ_UserInfoEditorController* viewController = [[JUDIAN_READ_UserInfoEditorController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.titleText = title;
    viewController.placeholder = placeholder;
    viewController.userBriefModel = userBriefModel;
    [navigationController pushViewController:viewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addTableView];
}


- (void)addNavigationView {
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:_titleText rightTitle:@"保存"];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            [that updateUserInfo];
        }
    };
    
    CGFloat height = 64;
    if (iPhoneX) {
        height = 88;
    }
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.height.equalTo(@(height));
    }];
#endif
    self.title = _titleText;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(updateUserInfo)];
}


- (void)addTableView {
    
    NSInteger navigationHeight = [self getNavigationHeight];
    NSInteger yPosition = 0;
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger height = SCREEN_HEIGHT - navigationHeight - bottomOffset;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tableView addGestureRecognizer:tapGuesture];
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_UserSignatureCell class] forCellReuseIdentifier:UserSignatureCell];
    [tableView registerClass:[JUDIAN_READ_UserInfoEditorCell class] forCellReuseIdentifier:UserInfoEditorCell];
    
    
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}



- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}



- (void)updateUserInfo {
    BOOL isFirst = FALSE;
    NSString* errorTip = @"保存内容不能为空";
    if ([_titleText isEqualToString:@"昵称"]) {
        _userBriefModel.nickname = [_textFieldCell getEditorText];
        if (_userBriefModel.nickname.length <= 0) {
            [MBProgressHUD showMessage:errorTip];
            return;
        }
    }
    else if ([_titleText isEqualToString:@"微信号"]) {
        if (_userBriefModel.wxNo.length <= 0) {
            isFirst = TRUE;
        }
        _userBriefModel.wxNo = [_textFieldCell getEditorText];
        if (_userBriefModel.wxNo.length <= 0) {
            [MBProgressHUD showMessage:errorTip];
            return;
        }
    }
    else if ([_titleText isEqualToString:@"职业"]) {
        if (_userBriefModel.profession.length <= 0) {
            isFirst = TRUE;
        }
       _userBriefModel.profession = [_textFieldCell getEditorText];
        if (_userBriefModel.profession.length <= 0) {
            [MBProgressHUD showMessage:errorTip];
            return;
        }
    }
    else if ([_titleText isEqualToString:@"个性签名"]) {
        if (_userBriefModel.personProfile.length <= 0) {
            isFirst = TRUE;
        }
       _userBriefModel.personProfile = [_textViewCell getEditorText];
        if (_userBriefModel.personProfile.length <= 0) {
            [MBProgressHUD showMessage:errorTip];
            return;
        }
    }
    

    WeakSelf(that);
    [_userBriefModel saveUserBriefModel:^(id  _Nullable args) {
        NSNumber* status = args;
        if (status.intValue == 1) {
            
            [GTCountSDK trackCountEvent:@"personal_information" withArgs:@{@"infor_option" : that.titleText}];
            [MobClick event:@"personal_information" attributes:@{@"infor_option" : that.titleText}];
            
             [that.navigationController popViewControllerAnimated:YES];
        }
    } viewController:self isFirst:isFirst];
}



#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
   
    if([_titleText isEqualToString:@"个性签名"]) {
        JUDIAN_READ_UserSignatureCell* cell = [tableView dequeueReusableCellWithIdentifier:UserSignatureCell];
        _textViewCell = cell;
        NSString* content = _userBriefModel.personProfile;
        [cell updateTextView:content];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        JUDIAN_READ_UserInfoEditorCell* cell = [tableView dequeueReusableCellWithIdentifier:UserInfoEditorCell];
        _textFieldCell = cell;
        NSString* cellTitle = [NSString stringWithFormat:@"我的%@", _titleText];

        NSString* content = @"";
        if ([_titleText isEqualToString:@"昵称"]) {
            content = _userBriefModel.nickname;
        }
        else if ([_titleText isEqualToString:@"微信号"]) {
            content = _userBriefModel.wxNo;
        }
        else if ([_titleText isEqualToString:@"职业"]) {
            content = _userBriefModel.profession;
        }

        [cell updateInfo:cellTitle placeholder:_placeholder content:content];
 
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 138;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



@end
