//
//  JUDIAN_READ_UserFictionRateViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserFictionRateViewController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserRateFictionCountCell.h"
#import "JUDIAN_READ_UserRateFictionScoreCell.h"
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_UserRateBookModel.h"

#define UserRateFictionCountCell @"UserRateFictionCountCell"
#define UserRateFictionScoreCell @"UserRateFictionScoreCell"


@interface JUDIAN_READ_UserFictionRateViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSString* appreciateCount;
@property(nonatomic, copy)NSString* bookName;
@property(nonatomic, copy)NSString* bookAuthor;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, strong)JUDIAN_READ_UserRateBookModel* rateModel;

@property(nonatomic, weak)JUDIAN_READ_UserRateFictionScoreCell* scoreCell;

@end

@implementation JUDIAN_READ_UserFictionRateViewController


+ (void)enterFictionRateViewController:(UINavigationController*)navigationController book:(NSDictionary*)dictionary {
    
    JUDIAN_READ_UserFictionRateViewController* viewController = [[JUDIAN_READ_UserFictionRateViewController alloc] init];
    viewController.appreciateCount = dictionary[@"appreciateCount"];
    viewController.bookName = dictionary[@"bookName"];
    viewController.bookAuthor = dictionary[@"bookAuthor"];
    viewController.bookId = dictionary[@"bookId"];
    
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    [self addTableView];
    [self addBottomBar];
    
    WeakSelf(that);
    [JUDIAN_READ_UserRateBookModel buildRateModel:^(id  _Nullable args) {
        that.rateModel = args;
        [that.tableView reloadData];
    } bookId:_bookId];
}



- (void)addNavigationView {
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateUserBriefNavigation:@"评分" rightTitle:@""];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            
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
    
}





- (void)addTableView {
    
    NSInteger yPosition = [self getNavigationHeight];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger height = SCREEN_HEIGHT - yPosition - bottomOffset;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_UserRateFictionCountCell class] forCellReuseIdentifier:UserRateFictionCountCell];
    [tableView registerClass:[JUDIAN_READ_UserRateFictionScoreCell class] forCellReuseIdentifier:UserRateFictionScoreCell];
    
}



- (void)addBottomBar {
    
    UIButton* submitButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"novel_bottom_button"] forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    [submitButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    WeakSelf(that);
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.height.equalTo(@(50));
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
}


- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}




#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JUDIAN_READ_UserRateFictionCountCell* cell = [tableView dequeueReusableCellWithIdentifier:UserRateFictionCountCell];
        NSString* count = [self getRatedUserCount:_rateModel.evaluate_users.integerValue];;
        [cell upateCell:_bookName author:_bookAuthor count:count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    JUDIAN_READ_UserRateFictionScoreCell* cell = [tableView dequeueReusableCellWithIdentifier:UserRateFictionScoreCell];
    [cell updateCell:(_rateModel.evaluateScore.integerValue - 1)];
    _scoreCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSString*)getRatedUserCount:(NSInteger)count {
    
    CGFloat tenThousand = 0.0f;
    CGFloat limit = 10000.0f;
    
    NSString* appreciateCount = @"";
    
    if (count >= limit) {
        tenThousand = count / limit;
        appreciateCount = [NSString stringWithFormat:@"%.1f万", tenThousand];
    }
    else {
        appreciateCount = [NSString stringWithFormat:@"%ld", count];
    }
    
    return appreciateCount;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        return 154 + 20;
    }
    
    return 30 * 2 + 7 + 13 * 2;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)handleTouchEvent:(UIButton*)sender {
    
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length <= 0) {
        return;
    }
    
    NSString* score = [_scoreCell getScore];
    if (score.length <= 0) {
        [MBProgressHUD showMessage:@"请选择评分"];
        return;
    }
    
    [GTCountSDK trackCountEvent:@"mark_scores" withArgs:@{@"scores":score}];
    [MobClick event:@"mark_scores" attributes:@{@"scores" : score}];
    
    NSDictionary* dictionary = @{
                       @"nid" : _bookId,
                       @"uid_b" : uid,
                       @"score" : score
                       };
    
    WeakSelf(that);
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/add-book-evaluate" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* status = response[@"status"];
        if (status.intValue == 1) {
            [MBProgressHUD showMessage:@"评价成功"];
            [that.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
