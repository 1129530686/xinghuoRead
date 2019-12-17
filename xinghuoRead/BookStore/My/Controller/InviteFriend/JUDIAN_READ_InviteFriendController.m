//
//  JUDIAN_READ_InviteController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/17.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_InviteFriendController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "SDCycleScrollView.h"
#import "JUDIAN_READ_TextVerticalScrollView.h"
#import "JUDIAN_READ_InviteFriendGuideCell.h"
#import "JUDIAN_READ_InviteFriendRuleCell.h"
#import "JUDIAN_READ_InviteFriendBottomView.h"
#import "JUDIAN_READ_InviteFriendPosterView.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_UserShareCodeMenu.h"
#import "JUDIAN_READ_PromotionUserCountActivity.h"
#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_CoinRecordController.h"
#import "JUDIAN_READ_FriendController.h"
#import "JUDIAN_READ_MySubordinateViewController.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>


#define InviteFriendGuideCell @"InviteFriendGuideCell"
#define InviteFriendRuleCell @"InviteFriendRuleCell"

#define BOTTOM_BAR_HEIGHT 67

@interface JUDIAN_READ_InviteFriendController ()
<UITableViewDelegate,
UITableViewDataSource>

@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, weak)JUDIAN_READ_UserEarningsNavigationView* navigationView;
@property(nonatomic, weak)JUDIAN_READ_InviteFriendPosterView* posterView;
@property(nonatomic, strong)JUDIAN_READ_UserShareCodeMenu* shareCodeMenu;
@property(nonatomic, strong)JUDIAN_READ_PromotionUserCountActivity* userCountModel;
@property(nonatomic, weak)JUDIAN_READ_TextVerticalScrollView* barView;
@property(nonatomic, weak)JUDIAN_READ_InviteFriendGuideCell* guideCell;
@end

@implementation JUDIAN_READ_InviteFriendController

+ (void)enterInviteFriendController:(UINavigationController*)navigationController {
    
    JUDIAN_READ_InviteFriendController* viewController = [[JUDIAN_READ_InviteFriendController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBgView];
    [self addNavigationView];
    [self addTableView];
    [self addCarouselTipView];
    [self addBottomBar];
    
    [self addPosterView];
    [self loadActivityModel];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar setHidden:NO];
}


- (void)addBgView {
    
    NSInteger yPos = 0;//[self getNavigationHeight];
    
    UIImageView* bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"invite_friend_bg"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    [self.view addSubview:bgImageView];
    
    UIImageView* leftBgimageView = [[UIImageView alloc] init];
    leftBgimageView.image = [UIImage imageNamed:@"invite_friend_left_bg"];
    //577 233
    [self.view addSubview:leftBgimageView];
    leftBgimageView.hidden = YES;
    
    UIImageView* rightBgimageView = [[UIImageView alloc] init];
    rightBgimageView.image = [UIImage imageNamed:@"invite_friend_right_bg"];
    //165 185
    [self.view addSubview:rightBgimageView];
    rightBgimageView.hidden = YES;
    
    WeakSelf(that);
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(@(yPos));
        make.bottom.equalTo(that.view.mas_bottom);
    }];
    
    
    [leftBgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.width.equalTo(@(288));
        make.top.equalTo(@(yPos));
        make.height.equalTo(@(126));
    }];
    
    
    [rightBgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.view.mas_right);
        make.width.equalTo(@(82));
        make.top.equalTo(@(yPos));
        make.height.equalTo(@(92));
    }];
    
    
}




- (void)addNavigationView {
    
#if 0
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    _navigationView = view;
    [view updateUserBriefNavigation:@"邀请好友" rightTitle:@"活动说明"];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            [that enterWebView];
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

    self.title = @"邀请好友";
    
    UIButton* rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.contentMode = UIViewContentModeRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    [rightButton setTitle:@"活动说明" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(enterWebView) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}



- (void)addCarouselTipView {
    NSInteger yPos = 0;//[self getNavigationHeight];
    CGRect rect = CGRectMake(0, yPos, SCREEN_WIDTH, 33);
    JUDIAN_READ_TextVerticalScrollView* barView = [[JUDIAN_READ_TextVerticalScrollView alloc] initWithFrame:rect];
    _barView = barView;
    barView.backgroundColor = RGB(0xA9,0x00,0x1B);
    [self.view addSubview:barView];
}



- (void)addBottomBar {
    
    JUDIAN_READ_InviteFriendBottomView* barView = [[JUDIAN_READ_InviteFriendBottomView alloc] init];
    WeakSelf(that);
    barView.block = ^(id  _Nullable args) {
        [that shareCodeString:args];
    };
    
    [self.view addSubview:barView];
    
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.bottom.equalTo(that.tableView.mas_bottom);
        make.height.equalTo(@(BOTTOM_BAR_HEIGHT));
    }];
    
    
    if (iPhoneX) {
        UIView* emptyView = [[UIView alloc] init];
        emptyView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emptyView];
        
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(that.view.mas_left);
            make.right.equalTo(that.view.mas_right);
            make.top.equalTo(barView.mas_bottom);
            make.bottom.equalTo(that.view.mas_bottom);
        }];
        
    }
}



- (void)addPosterView {
    
    JUDIAN_READ_InviteFriendPosterView* posterView = [[JUDIAN_READ_InviteFriendPosterView alloc] init];
    _posterView = posterView;
    [self.view addSubview:posterView];
    
    //NSInteger yPos = [self getNavigationHeight];
    
    NSInteger height = [posterView getViewHeight];
    
    WeakSelf(that);
    [posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.view.mas_bottom).offset(100);
        //make.top.equalTo(that.view.mas_top).offset(yPos);
        make.height.equalTo(@(height));
        make.left.equalTo(that.view.mas_left);
        make.width.equalTo(that.view.mas_width);
    }];

}



- (CGFloat)getTextWidth:(CGFloat)height text:(NSString*)text font:(UIFont*)font {
    CGRect frame = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil];
    return ceil(frame.size.width);
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, BOTTOM_BAR_HEIGHT, 0);
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_InviteFriendRuleCell class] forCellReuseIdentifier:InviteFriendRuleCell];
    [tableView registerClass:[JUDIAN_READ_InviteFriendGuideCell class] forCellReuseIdentifier:InviteFriendGuideCell];
    
    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
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


- (void)loadActivityModel {
    
    WeakSelf(that);
    [JUDIAN_READ_PromotionUserCountActivity buildActivityModel:^(id  _Nullable args) {
        that.userCountModel = args;
        [that.tableView reloadData];
        
        [that.barView buildAttributedText:that.userCountModel.message];
        
    }];
    
}



- (void)enterWebView {
    JUDIAN_READ_BannarWebController *webVC = [JUDIAN_READ_BannarWebController new];
    webVC.title = @"活动说明";
    webVC.url = EARNING_TASK_INTRODUCTION_URL;
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)enterRuleDetailView {
    JUDIAN_READ_BannarWebController *webVC = [JUDIAN_READ_BannarWebController new];
    webVC.title = @"邀请好友技巧";
    webVC.url = [NSString stringWithFormat:@"%@/templates/myInviting/invitationTechnique.html", API_HOST_NAME];
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JUDIAN_READ_InviteFriendGuideCell* cell = [tableView dequeueReusableCellWithIdentifier:InviteFriendGuideCell];
        _guideCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WeakSelf(that);
        cell.block = ^(id  _Nullable args) {
            [that handleTouchCommand:args];
        };
        [cell updateCell:_userCountModel.coin friendCount:_userCountModel.count];
        return cell;
    }
    else {
        JUDIAN_READ_InviteFriendRuleCell* cell = [tableView dequeueReusableCellWithIdentifier:InviteFriendRuleCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
#if 0
    if (indexPath.row == 0) {
        return 397 + 20;
    }
    
    CGFloat width = (SCREEN_WIDTH - 22 * 2);
    CGFloat height = ceil(width * 1.23f) + 27;//407 / 333.0f
    
    return height;
#else
    return [_guideCell getCellHeight];
#endif
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



- (void)handleTouchCommand:(NSString*) cmd {
    
    if ([cmd isEqualToString:@"watchDetail"]) {
        [self enterRuleDetailView];
        return;
    }
    
    
    if ([cmd isEqualToString:@"goldCoin"]) {
        JUDIAN_READ_CoinRecordController *vc = [JUDIAN_READ_CoinRecordController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([cmd isEqualToString:@"friendCount"]) {
        WeakSelf(that);
        JUDIAN_READ_BannarWebController *webVC = [JUDIAN_READ_BannarWebController new];
        webVC.title = @"我邀请的好友";
        webVC.url = [NSString stringWithFormat:@"%@/templates/myInviting/index.html",API_HOST_NAME];
        [that.navigationController pushViewController:webVC animated:YES];
        return;
    }
    
    if ([cmd isEqualToString:@"subordinateCount"]) {
        [JUDIAN_READ_MySubordinateViewController enterSubordinateViewController:self.navigationController];
        return;
    }
    
    if ([cmd containsString:@"Poster"]) {
        [self showShareMenu:NO];
    }
    else {
        [self showShareMenu:YES];
    }
    
}

- (void)showShareMenu:(BOOL)hidePictureButton {
    
    _shareCodeMenu = [[JUDIAN_READ_UserShareCodeMenu alloc]init];
    _shareCodeMenu.frame = self.view.bounds;
    [self.view addSubview:_shareCodeMenu];
    
    if (hidePictureButton) {
        [_shareCodeMenu.barView hidePictureButton];
    }
    
    WeakSelf(that);
    _shareCodeMenu.block = ^(id  _Nullable args) {
        if (hidePictureButton) {
            [that shareLink:args];
        }
        else {
            [that shareCodeString:args];
        }
    };

    [_shareCodeMenu showView];;
}



- (void)shareLink:(NSString*)cmd {
    NSString* qrCode = [JUDIAN_READ_TestHelper getQrCode];
    
    [JUDIAN_READ_Reader_FictionCommandHandler shareFriendLink:cmd url:qrCode slogan:_userCountModel.slogan];
    
    NSString* source = @"";
    if([cmd isEqualToString:@"weixin"]) {
        source = @"微信好友";
    }
    else {
        source = @"朋友圈";
    }
    
    [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"type":source}];
    [MobClick event:@"Invite_friends" attributes:@{@"type" :source}];
}


- (void)shareCodeString:(NSString*)cmd {
    
    if ([cmd isEqualToString:@"save"]) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self.posterView saveImageToAlbum];
                
                [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"type":@"保存图片"}];
                [MobClick event:@"Invite_friends" attributes:@{@"type" : @"保存图片"}];
                
            }else {
                [JUDIAN_READ_TestHelper showSystemSettingAlert:@"请在系统设置中,启用“照片”服务" viewController:self];
            }
        }];
        
    }
    else if([cmd isEqualToString:@"weixin"]) {
        UIImage* image = [self.posterView getSnapShot];
        [JUDIAN_READ_Reader_FictionCommandHandler shareQrcodePicture:UMSocialPlatformType_WechatSession shareImage:image thumbImage:nil];
        
        [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"type":@"微信好友"}];
        [MobClick event:@"Invite_friends" attributes:@{@"type" : @"微信好友"}];
    }
    else if([cmd isEqualToString:@"friend"]) {
        UIImage* image = [self.posterView getSnapShot];
        [JUDIAN_READ_Reader_FictionCommandHandler shareQrcodePicture:UMSocialPlatformType_WechatTimeLine shareImage:image thumbImage:nil];
        
        [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"type":@"微信朋友圈"}];
        [MobClick event:@"Invite_friends" attributes:@{@"type" : @"微信朋友圈"}];
    }
    
}

- (void)dealloc {
    [_barView resetTimer];
}

@end
