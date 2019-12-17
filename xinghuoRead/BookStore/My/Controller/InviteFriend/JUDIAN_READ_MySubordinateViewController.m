//
//  JUDIAN_READ_MySubordinateViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/9/29.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_MySubordinateViewController.h"
#import "JUDIAN_READ_MySubordinateCell.h"


#define MySubordinateCell @"MySubordinateCell"
#define MySubordinateHeaderView @"MySubordinateHeaderView"

@interface JUDIAN_READ_MySubordinateViewController ()
@property(nonatomic, weak)UITableView* tableView;
@end

@implementation JUDIAN_READ_MySubordinateViewController


+ (void)enterSubordinateViewController:(UINavigationController*)navigationController {
    JUDIAN_READ_MySubordinateViewController* viewController = [[JUDIAN_READ_MySubordinateViewController alloc] init];
    [navigationController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBarView];
    [self addTableView];
}


- (void)addNavigationBarView {
  self.title = @"我的推广员";
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
    
    [tableView registerClass:[JUDIAN_READ_MySubordinateCell class] forCellReuseIdentifier:MySubordinateCell];
    
    [tableView registerClass:[JUDIAN_READ_MySubordinateHeaderView class] forHeaderFooterViewReuseIdentifier:MySubordinateHeaderView];
    
    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    JUDIAN_READ_MySubordinateCell* cell = [tableView dequeueReusableCellWithIdentifier:MySubordinateCell];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 66;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
      JUDIAN_READ_MySubordinateHeaderView* headerView =   [tableView dequeueReusableHeaderFooterViewWithIdentifier:MySubordinateHeaderView];
        
        return headerView;
    }
    
    return nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;

}
    


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
