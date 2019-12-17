//
//  JUDIAN_READ_RecruitSubordinateViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/10/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_RecruitSubordinateViewController.h"
#import "JUDIAN_READ_TextVerticalScrollView.h"
#import "JUDIAN_READ_PromotionUserCountActivity.h"
#import "JUDIAN_READ_RecruitSubordinateProfitCell.h"
#import "JUDIAN_READ_RecruitSubordinateTop10Cell.h"

#define RecruitSubordinateProfitCell @"RecruitSubordinateProfitCell"
#define RecruitSubordinateRuleCell @"RecruitSubordinateRuleCell"
#define RecruitSubordinateWxCodeCell @"RecruitSubordinateWxCodeCell"
#define RecruitSubordinateTop10Cell @"RecruitSubordinateTop10Cell"


@interface JUDIAN_READ_RecruitSubordinateViewController ()
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, weak)JUDIAN_READ_TextVerticalScrollView* barView;
@property(nonatomic, strong)JUDIAN_READ_PromotionUserCountActivity* userCountModel;
@property(nonatomic, strong)JUDIAN_READ_RecruitSubordinateProfitCell* profitCell;
@property(nonatomic, strong)JUDIAN_READ_RecruitSubordinateRuleCell* ruleCell;
@property(nonatomic, strong)JUDIAN_READ_RecruitSubordinateWxCodeCell* wxCodeCell;

@end

@implementation JUDIAN_READ_RecruitSubordinateViewController

+ (void)enterRecruitSubordinateController:(UINavigationController*)navigationController {
    
    JUDIAN_READ_RecruitSubordinateViewController* viewController = [[JUDIAN_READ_RecruitSubordinateViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTitleView];
    [self addBgView];
    [self addTableView];
    [self addCarouselTipView];
    [self loadActivityModel];
}



- (void)addBgView {
    UIImageView* bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"recruit_subordinate_bg"];
    [self.view addSubview:bgImageView];
    
    UIImageView* leftImageView = [[UIImageView alloc] init];
    leftImageView.image = [UIImage imageNamed:@"recruit_subordinate_right_goin"];
    [self.view addSubview:leftImageView];
    
    
    UIImageView* rightImageView = [[UIImageView alloc] init];
    rightImageView.image = [UIImage imageNamed:@"recruit_subordinate_left_goin"];
    [self.view addSubview:rightImageView];


    WeakSelf(that);
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(@(0));
        make.bottom.equalTo(that.view.mas_bottom);
    }];
    
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(36));
        make.width.equalTo(@(41));
        make.height.equalTo(@(35));
        make.left.equalTo(that.view.mas_left);
    }];
    
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(260));
        make.width.equalTo(@(51));
        make.height.equalTo(@(32));
        make.right.equalTo(that.view.mas_right);
    }];
    
}



- (void)updateTitleView {
    self.title = @"招募推广员";
}


- (void)addTableView {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    //NSInteger height = SCREEN_HEIGHT - yPosition - bottomOffset;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_BAR_HEIGHT, 0);
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_RecruitSubordinateProfitCell class] forCellReuseIdentifier:RecruitSubordinateProfitCell];
    [tableView registerClass:[JUDIAN_READ_RecruitSubordinateRuleCell class] forCellReuseIdentifier:RecruitSubordinateRuleCell];
    [tableView registerClass:[JUDIAN_READ_RecruitSubordinateWxCodeCell class] forCellReuseIdentifier:RecruitSubordinateWxCodeCell];
    [tableView registerClass:[JUDIAN_READ_RecruitSubordinateTop10Cell class] forCellReuseIdentifier:RecruitSubordinateTop10Cell];
    
    
    _profitCell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateProfitCell];;
    _ruleCell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateRuleCell];
    _wxCodeCell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateWxCodeCell];
    
    
    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
    
}


- (void)addCarouselTipView {
    NSInteger yPos = 0;//[self getNavigationHeight];
    CGRect rect = CGRectMake(0, yPos, SCREEN_WIDTH, 33);
    JUDIAN_READ_TextVerticalScrollView* barView = [[JUDIAN_READ_TextVerticalScrollView alloc] initWithFrame:rect];
    _barView = barView;
    barView.backgroundColor = RGB(0xA9,0x00,0x1B);
    [self.view addSubview:barView];
}



- (void)loadActivityModel {
    
    WeakSelf(that);
    [JUDIAN_READ_PromotionUserCountActivity buildActivityModel:^(id  _Nullable args) {
        that.userCountModel = args;
        [that.tableView reloadData];
        
        [that.barView buildAttributedText:that.userCountModel.message];
        
    }];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            JUDIAN_READ_RecruitSubordinateProfitCell* cell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateProfitCell];
            _profitCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (row == 1) {
            JUDIAN_READ_RecruitSubordinateRuleCell* cell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateRuleCell];
            _ruleCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (row == 2) {
            JUDIAN_READ_RecruitSubordinateWxCodeCell* cell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateWxCodeCell];
            _wxCodeCell = cell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if (section == 1) {
        JUDIAN_READ_RecruitSubordinateTop10Cell* cell = [tableView dequeueReusableCellWithIdentifier:RecruitSubordinateTop10Cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0 && _profitCell) {
            return [_profitCell getCellHeight];
        }
        
        if (row == 1 && _ruleCell) {
            return  [_ruleCell getCellHeight];
        }

        if (row == 2 && _wxCodeCell) {
            return  [_wxCodeCell getCellHeight];
        }
    }
    
    if (section == 1) {
        return 769;//703 + 33 * 2
    }


    return 0;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}




@end
