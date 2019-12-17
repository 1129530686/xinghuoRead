//
//  JUDIAN_READ_AppreciateMoneyViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AppreciateMoneyViewController.h"
#import "JUDIAN_READ_NovelNavigationContainer.h"
#import "JUDIAN_READ_MoneyChoicePanel.h"
#import "JUDIAN_READ_ApplePayBar.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_RewardSuccessView.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_UserAppreciateListViewController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_LoadingFictionView.h"
#import "JUDIAN_READ_UserAppreciateMoneyCell.h"
#import "JUDIAN_READ_IAPShare.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_ApprecaiteMoneyManager.h"
#import "JUDIAN_READ_PayTypeController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"

@interface JUDIAN_READ_AppreciateMoneyViewController ()<UITextViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic, weak)JUDIAN_READ_NovelNavigationContainer* navigationContainer;
@property(nonatomic, weak)JUDIAN_READ_MoneyChoicePanel* choicePanel;
@property(nonatomic, copy)NSString* chapterId;
@property(nonatomic, copy)NSString* bookId;

@property (nonatomic, strong) JUDIAN_READ_LoadingFictionView* loadingView;
@property (nonatomic, weak)JUDIAN_READ_BaseTableView* tableView;

@property(nonatomic, copy)NSArray* amountArray;
@property(nonatomic, weak)UIButton* payButton;
@property (nonatomic, strong)JUDIAN_READ_ApprecaiteMoneyManager* moneyManager;
@property(nonatomic, weak)UILabel* payMoneyLabel;

@end

@implementation JUDIAN_READ_AppreciateMoneyViewController

+ (void)enterAppreciateMoneyViewController:(UINavigationController*)navigation bookId:(NSString*)bookId chapterId:(NSString*)chapterId source:(NSString*)source block:(refreshBlock)block {
    JUDIAN_READ_AppreciateMoneyViewController* viewController = [[JUDIAN_READ_AppreciateMoneyViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.chapterId = chapterId;
    viewController.bookId = bookId;
    viewController.source = source;
    viewController.block = block;
    [navigation pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];

    [self addTableView];
    [self addPayButton];
    [self loadMoneyAmountList];

    [self initAppriciateMoneyManager];
}



- (void)viewWillAppear:(BOOL)animated {
    self.hideBar = YES;
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}



- (void)addNavigationView {
#if 0
    JUDIAN_READ_NovelNavigationContainer* container = [[JUDIAN_READ_NovelNavigationContainer alloc]init];
    _navigationContainer = container;
    container.hidden = NO;
    [self.view addSubview:container];
    
    [container changeBarTransparent:1];
    [container setTitle:@"赞赏"];
    [container showShareButton:NO];
    
    CGFloat height = [self getNavigationHeight];
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.height.equalTo(@(height));
        make.top.equalTo(that.view.mas_top);
    }];
    
    
    container.navigationBar.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"0"]) {
            [that popViewController];
        }
    };
#else
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
   // _navigationView = view;
    [view updateUserBriefNavigation:@"赞赏" rightTitle:@"我的赞赏"];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            [JUDIAN_READ_UserAppreciateListViewController enterViewController:that.navigationController];
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
    
}


- (void)initAppriciateMoneyManager {
    WeakSelf(that);
    _moneyManager = [[JUDIAN_READ_ApprecaiteMoneyManager alloc] initWithView:self.view];
    _moneyManager.block = ^(id  _Nullable args) {
        [that showAppreciatedResult:args];
    };
}



- (void)addTableView {
    
    NSInteger yPosition = [self getNavigationHeight];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger height = SCREEN_HEIGHT - yPosition - bottomOffset;
    JUDIAN_READ_BaseTableView* tableView = [[JUDIAN_READ_BaseTableView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    WeakSelf(that);
    tableView.emptyCallBack = ^(int type){
        [that loadMoneyAmountList];
    };
    
    [self.view addSubview:tableView];
    _tableView = tableView;
}



- (void)addPayButton {

    UIView* container = [[UIView alloc] init];
    [self.view addSubview:container];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:lineView];

    NSMutableAttributedString* attributedString = [self createRmbCountTip:@"0"];
    
    UILabel* payMoneyLabel = [[UILabel alloc] init];
    _payMoneyLabel = payMoneyLabel;
    payMoneyLabel.attributedText = attributedString;
    [container addSubview:payMoneyLabel];
    

    UIButton* payButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _payButton = payButton;
    
    [payButton setTitle:@"立即支付" forState:(UIControlStateNormal)];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [payButton setBackgroundImage:[UIImage imageNamed:@"pay_chapter_tip"] forState:UIControlStateNormal];
    [container addSubview:payButton];
    [payButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
        make.height.equalTo(@(50));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.top.equalTo(container.mas_top);
        make.height.equalTo(@(0.5));
    }];
    
    
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_right);
        make.width.equalTo(@(113));
        make.bottom.equalTo(container.mas_bottom);
        make.height.equalTo(@(50));
    }];
    
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(14);
        make.right.equalTo(payButton.mas_left).offset(-14);
        make.centerY.equalTo(container.mas_centerY);
        make.height.equalTo(@(50));
    }];
    
    
    payButton.hidden = YES;
}




- (NSMutableAttributedString*)createRmbCountTip:(NSString*)amount {
    
    if (amount.length <= 0) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    NSString* text = [NSString stringWithFormat:@"实付: ¥%@", amount];
    
    UIFont* samllFont = [UIFont systemFontOfSize:12];
    
    UIFont* bigFont = [UIFont systemFontOfSize:17];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:samllFont range:NSMakeRange(0, 3)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, 3)];
    
    [attributedString addAttribute:NSFontAttributeName value:samllFont range:NSMakeRange(4, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(4, 1)];


    [attributedString addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(5, amount.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(5, amount.length)];
    
    return attributedString;
}





- (void)showPayButton {
    if (self.amountArray > 0) {
        _payButton.hidden = NO;
    }
    else {
        _payButton.hidden = YES;
    }
}


- (void)showAppreciateResultView:(BOOL)isSuccess {
    JUDIAN_READ_RewardSuccessView *view = [[JUDIAN_READ_RewardSuccessView alloc]initWithType:isSuccess];
    view.viewController = self;
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nullable args) {
        [that shareChapterToOthers:args];
    };
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.top.equalTo(that.view.mas_top);
        make.width.equalTo(that.view.mas_width);
        make.height.equalTo(that.view.mas_height);
    }];
}




- (CGFloat)getNavigationHeight {
    CGFloat height = 0;
    if (iPhoneX) {
        height = 88;
    }
    else {
        height = 64;
    }
    return height;
}



- (void)shareChapterToOthers:(NSNumber*)index {
    
    NSString* bookId = _bookId;
    if (!bookId) {
        return;
    }
    
    NSDictionary* dictionary = nil;
    NSInteger cmdArray[] = {kWeixinTag, kFriendTag, kQQTag, kQQZoneTag, kWeiboTag, kCopyLinkTag};

    dictionary = @{
                      @"cmd":@(cmdArray[[index intValue]]),
                      @"value":bookId,
                      @"fromView" : @"赞赏成功后分享"
                    };

    NSNotification* notification = [[NSNotification alloc]initWithName:@"" object:dictionary userInfo:nil];
    [JUDIAN_READ_Reader_FictionCommandHandler shareNovelToOther:notification];
        
}



#pragma mark 表单代理
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JUDIAN_READ_UserAppreciateMoneyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appreciateMoneyCell"];
    if (!cell) {
        cell = [[JUDIAN_READ_UserAppreciateMoneyCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"appreciateMoneyCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _choicePanel = cell.choicePanel;
    WeakSelf(that);
    _choicePanel.block = ^(JUDIAN_READ_AppreciateAmountModel* model) {
        NSString* tip = [NSString stringWithFormat:@"%ld", (long)model.price.intValue];
        that.payMoneyLabel.attributedText = [self createRmbCountTip:tip];
    };
    
    if (self.amountArray.count > 0) {
        [cell.choicePanel updateAmount:self.amountArray];
        JUDIAN_READ_AppreciateAmountModel* model = [_choicePanel getSelectedModel];
        _payMoneyLabel.attributedText = [self createRmbCountTip:model.price];
    }
    
    cell.block = ^(NSString*  _Nullable args) {
        if ([args isEqualToString:@"history"]) {
            [JUDIAN_READ_UserAppreciateListViewController enterViewController:that.navigationController];
        }
        else {
            [that enterPayStyleView];
        }
        
    };
    
    return cell;
}



- (void)enterPayStyleView {
    
    JUDIAN_READ_PayTypeController *vc = [JUDIAN_READ_PayTypeController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    //return 182 + 34 + 20 + 100 + 40;
    return 376;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_amountArray.count > 0) {
        return 1;
    }
    else {
        return 0;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}





#pragma mark 事件处理

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)handleTouchEvent:(UIButton*)sender {
    [self appreciateMoney];
}



- (void)loadMoneyAmountList {
    
    [MBProgressHUD showLoadingForView:_tableView];
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getAppreciateMoneyAmountList:^(id  _Nonnull parameter) {
        [MBProgressHUD hideHUDForView:that.tableView];
        
        that.amountArray = parameter;
        [that showPayButton];
        [that.tableView reloadData];
    }];

}


#pragma mark 服务端验证
- (void)appreciateMoney {

   // JUDIAN_READ_AppreciateMoneyStriaManager*  IAPManager = [JUDIAN_READ_AppreciateMoneyStriaManager shareInstance];
   // IAPManager.chpaterId = self.chapterId;
   // IAPManager.bookId = self.bookId;

    JUDIAN_READ_AppreciateAmountModel* model = [_choicePanel getSelectedModel];

    if (!model || !model.product_id || !model.price || !self.bookId || !self.chapterId) {
        return;
    }
    
    NSDictionary *dictonary = @{
                          @"payment_category":@"iap",
                          @"product_id" : model.product_id,
                          @"price" : model.price,
                          @"nid" : self.bookId,
                          @"chapnum" : self.chapterId,
                          @"type":@"ios"
                          };
    
    [_moneyManager appreciateMoney:dictonary source:_source];
    
}



- (void) showAppreciatedResult:(NSString*)result {
    
    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([result isEqualToString:@"1"]) {
            [that showAppreciateResultView:YES];
            
            if (that.block) {
                that.block(@"");
            }
            
        }else{
            [that showAppreciateResultView:NO];
        }
    });

}



@end
