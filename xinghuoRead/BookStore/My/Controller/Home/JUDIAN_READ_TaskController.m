//
//  JUDIAN_READ_TaskController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_TaskController.h"
#import "JUDIAN_READ_TaskCell.h"
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>

@interface JUDIAN_READ_TaskController ()<BURewardedVideoAdDelegate>

@property (nonatomic,strong) JUDIAN_READ_BaseTableView *tableView;
@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@property (nonatomic,strong) NSMutableArray  *arr;


@end

@implementation JUDIAN_READ_TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"福利任务";
    [self.view addSubview:self.tableView];
    [self loadData];
    
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID;
    //model.isShowDownloadBar = YES;
    
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:CHUAN_SHAN_JIA_REWARD_VEDIO_ID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    [MobClick event:ad_request attributes:@{@"source":ad_task}];
    // Do any additional setup after loading the view.
}


- (void)loadData{
    [JUDIAN_READ_MyTool getTaskWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            self.arr = result;
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_TaskCell class]) bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_TaskCell"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_TaskCell" forIndexPath:indexPath];
    [cell setDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.rewardedVideoAd showAdFromRootViewController:self.navigationController];
}


#pragma mark BURewardedVideoAdDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [MobClick event:ad_success_request attributes:@{@"source":ad_task}];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.offset = CGPointMake(0, -100);
//    hud.label.text = @"reawrded data load success";
//    [hud hideAnimated:YES afterDelay:0.1];
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.offset = CGPointMake(0, -100);
//    hud.label.text = @"reawrded video load success";
//    [hud hideAnimated:YES afterDelay:1];
}


- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [MobClick event:ad_success_show attributes:@{@"source":ad_task}];

}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    [MobClick event:ad_click attributes:@{@"source":ad_task}];
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.offset = CGPointMake(0, -100);
    hud.label.text = @"rewarded video material load fail";
    [hud hideAnimated:YES afterDelay:1];
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
     //   BUD_Log(@"rewardedVideoAd play error");
    } else {
        [JUDIAN_READ_MyTool uploadLookRecordWithParams:@{} completionBlock:^(id result, id error) {
            if (result) {
                [self loadData];
            }else{
                
            }
        }];
    }
    
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID;
    //model.isShowDownloadBar = YES;
    
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:CHUAN_SHAN_JIA_REWARD_VEDIO_ID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];

}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    //BUD_Log(@"rewardedVideoAd verify failed");
    
   // BUD_Log(@"Demo RewardName == %@", rewardedVideoAd.rewardedVideoModel.rewardName);
   // BUD_Log(@"Demo RewardAmount == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
//    BUD_Log(@"rewardedVideoAd verify succeed");
//    BUD_Log(@"verify result: %@", verify ? @"success" : @"fail");
//
//    BUD_Log(@"Demo RewardName == %@", rewardedVideoAd.rewardedVideoModel.rewardName);
//    BUD_Log(@"Demo RewardAmount == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
}
@end
