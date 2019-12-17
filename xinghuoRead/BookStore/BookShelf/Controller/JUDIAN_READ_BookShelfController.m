//
//  BookShelfController.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import "JUDIAN_READ_BookShelfController.h"
#import "JUDIAN_READ_CollectionHeadReuseView.h"
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_MyController.h"
#import "JUDIAN_READ_ShelfView.h"
#import "JUDIAN_READ_ShelfTopView.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_MainViewController.h"
#import "JUDIAN_READ_UserContributionBoardController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_ContentBrowseController.h"
#import "JUDIAN_READ_InviteFriendController.h"

#define OriginY (Height_NavBar)
#define TableContentSize 90

@interface JUDIAN_READ_BookShelfController ()<UINavigationControllerDelegate,UIScrollViewDelegate>


@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIButton  *personBtn;
@property (nonatomic,strong) NSDictionary  *dic;
@property (nonatomic,strong) UILabel  *timeLab;
@property (nonatomic,strong) JUDIAN_READ_ShelfView  *shelfView;
@property (nonatomic,strong) UIImageView  *adverView;
@property (nonatomic,assign) NSInteger  selectItem;
@property (nonatomic,strong) UIImageView  *imgV;
@property (nonatomic,assign) BOOL  isAnimationg;
@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) UIImageView  *signImgView;
@property (nonatomic,assign) NSInteger  titleCount;
@property (nonatomic,strong) UIView  *unLoginHeadView;
@property (nonatomic,strong) NSTimer  *timer;



@end

@implementation JUDIAN_READ_BookShelfController

- (instancetype)init{
    if (self = [super init]) {
        if (self.view.window) {
            [MBProgressHUD showLoadingForView:self.shelfView];
        }
        [self.shelfView loadDataLike:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAdverStatus];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    [self addOfflineHistory];
    [self.shelfView loadData:YES];
    [self.shelfView loadDataLike:YES];
    [self loadTimeData];
    NSString *str = @"head_default_small";
    if ([JUDIAN_READ_Account currentAccount].token) {
        str = @"head_small";
        self.signImgView.hidden = [JUDIAN_READ_Account currentAccount].allow_signin.intValue == 1 ? NO : YES;
        self.timeLab.hidden = NO;
        self.unLoginHeadView.hidden = YES;
    }else{
        self.timeLab.hidden = YES;
        self.unLoginHeadView.hidden = NO;
    }
    [self.personBtn sd_setImageWithURL:[NSURL URLWithString:[JUDIAN_READ_Account currentAccount].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:str]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.shelfView willDismiss:YES];
}


- (void)initUI{
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];   
}

#pragma mark 网络请求
- (void)loadTimeData{
    [JUDIAN_READ_BookShelfTool getReadTimeWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            self.dic = result;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"今日已读 %@",self.dic[@"duration"]]];
            [str addAttributes:@{NSForegroundColorAttributeName:kColor100,NSFontAttributeName:kFontSize12} range:NSMakeRange(0, 4)];
            self.timeLab.attributedText = str;
        }
    }];
}

- (void)checkAdverStatus{
    [JUDIAN_READ_DiscoveryTool getAdvertStatusUrlWithParams:^(id result, id error) {
        
    }];
}


- (void)addOfflineHistory {
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSArray* array = [JUDIAN_READ_UserReadingModel getOfflineHistory];
        for (NSDictionary* element in array) {
            NSString* bookId = element[@"bookId"];
            NSString* chapterId = element[@"chapterId"];
            [[JUDIAN_READ_NovelManager shareInstance]addUserReadChapter:bookId chapterId:chapterId];
            [NSThread sleepForTimeInterval:3];
        }
        
        [JUDIAN_READ_UserReadingModel clearOfflineHistory];
    });
    
}






#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, OriginY, SCREEN_WIDTH, ScreenHeight - OriginY - Height_TabBar ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.adverView;
        _tableView.tableFooterView = self.shelfView;
        _tableView.needSimulate = YES;
        _tableView.backgroundColor = [UIColor clearColor];

    }
    return _tableView;
}


- (JUDIAN_READ_ShelfView *)shelfView{
    if (!_shelfView) {
        CGFloat height = ScreenHeight - Height_TabBar - OriginY;
        _shelfView = [[JUDIAN_READ_ShelfView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        WeakSelf(obj);
        _shelfView.selectBlcok = ^(id result, id error) {
            if ([error isKindOfClass:[NSString class]]) { //跳书城
                JUDIAN_READ_MainViewController *vc = (JUDIAN_READ_MainViewController *)kKeyWindow.rootViewController;
                vc.selectedIndex = 2;
            }else{
#if 0
                [JUDIAN_READ_FictionReadingViewController enterFictionViewController:obj.navigationController book:error viewName:result];
#else
                [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:obj.navigationController book:error viewName:result];
#endif
            }
        };
    }
    return _shelfView;
}



- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55+Height_NavBar)];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bookcase_head_bg"]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55+Height_NavBar);
        [_headView addSubview:imgView];
        
        self.personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.personBtn.frame = CGRectMake(15, Height_StatusBar+5, 33, 33);
        [self.personBtn setImage:[UIImage imageNamed:@"head_default_small"] forState:UIControlStateNormal];
        [self.personBtn addTarget:self action:@selector(personAction) forControlEvents:UIControlEventTouchUpInside];
        self.personBtn.contentMode = UIViewContentModeScaleToFill;
        [_headView addSubview:self.personBtn];
        [self.personBtn doBorderWidth:0.5 color:KSepColor cornerRadius:33/2];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.textColor = kColor51;
        label.font = kFontSize16;
        self.timeLab = label;
        [_headView addSubview:label];
        WeakSelf(obj);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(obj.personBtn);
            make.trailing.equalTo(@(-15));
        }];
        
        [_headView addSubview:self.unLoginHeadView];
    }
    return _headView;
}

- (UIView *)unLoginHeadView{
    if (!_unLoginHeadView) {
        _unLoginHeadView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-230-20, Height_StatusBar+5, 230, 33)];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 131, 33)];
        [lab setText:@"您还有奖励未领取" titleFontSize:14 titleColot:kColor51];
        lab.textAlignment = NSTextAlignmentRight;
        [_unLoginHeadView addSubview:lab];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"book_login_btn"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(_unLoginHeadView.width - 91, 0, 91, 33);
        [_unLoginHeadView addSubview:btn];
    }
    return _unLoginHeadView;
}

- (void)login{
    JUDIAN_READ_WeChatLoginController *vc = [JUDIAN_READ_WeChatLoginController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIImageView *)adverView{
    if (!_adverView) {
        _adverView = [[UIImageView alloc]initWithFrame:CGRectMake(15, Height_NavBar+22, SCREEN_WIDTH-30, TableContentSize)];
        _adverView.userInteractionEnabled = YES;
        
        WeakSelf(obj);
        BOOL isOpen = [JUDIAN_READ_TestHelper needAdView:GET_MONEY_SWITCH];
        NSArray *titles;
        if (isOpen) {
            titles = @[@"鸣谢",@"福利",@"元宝",@"赚钱",@"借钱"];
        }else{
            titles = @[@"鸣谢",@"福利",@"元宝",@"赚钱"];
        }
        self.titleCount = titles.count;
        NSArray *imgs = @[@"bookcase_icon_thanks",@"bookcase_icon_welfare",@"bookcase_icon_wing",@"bookcase_icon_make_money",@"bookcase_icon_money"];
        for (int i = 0; i < titles.count; i++) {
            JUDIAN_READ_ShelfTopView *view = [[JUDIAN_READ_ShelfTopView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/self.titleCount*i+15, 0, (SCREEN_WIDTH-30)/self.titleCount, 85) imagesName:imgs[i] title:titles[i]];
            if (i == 2) {
                [view.subviews.firstObject addSubview:self.signImgView];
                [self animationView];
            }
            [_adverView addSubview:view];
            
            NSArray *vcArr = @[@"",@"JUDIAN_READ_BannarWebController",@"JUDIAN_READ_UserEarningsViewController",@"",@"JUDIAN_READ_BannarWebController"];
            view.touchBlock = ^{
                [GTCountSDK trackCountEvent:@"click_bookshelf_subtype" withArgs:@{@"type":titles[i]}];
                [MobClick event:@"click_bookshelf_subtype" attributes:@{@"type":titles[i]}];

                if (i == 0) {
                    [JUDIAN_READ_UserContributionBoardController enterUserContributionBoard:self.navigationController];
                    return;
                }
                
                if (i == 2) {
                    [JUDIAN_READ_UserEarningsViewController entryEarningsViewController:self.navigationController];
                    [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"source":@"书架的赚钱"}];
                    [MobClick event:@"make_money_task" attributes:@{@"type":@"书架的赚钱"}];

                    return;
                }
                if (i == 3) {
                    [JUDIAN_READ_InviteFriendController enterInviteFriendController:self.navigationController];
                    [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"source":@"书架"}];
                    [MobClick event:@"Invite_friends" attributes:@{@"source":@"书架"}];
                    return;
                }
               
                JUDIAN_READ_BannarWebController *vc = nil;
                if (i == 1) {
                    vc = [JUDIAN_READ_BannarWebController shareInstance];
                    vc.url = @"goldmall";
                    vc.title = @"福利商城";
                    
                }else{
                    vc = [NSClassFromString(vcArr[i]) new];
                    vc.url = [[NSUserDefaults standardUserDefaults] objectForKey:GET_MONEY_SWITCH];
                    vc.title = @"借钱";
                }
              
                [obj.navigationController pushViewController:vc animated:YES];
            };
        }
    }
    return _adverView;
}

- (UIImageView *)signImgView{
    if (!_signImgView) {
        CGFloat x = iPhone6Plus ? 40 : 35;
        if (self.titleCount == 3) {
            x = iPhone6Plus ? 55 : 50;
        }
        _signImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bookcase_icon_label"]];
        _signImgView.layer.anchorPoint = CGPointMake(0, 1);
        _signImgView.frame = CGRectMake((SCREEN_WIDTH-30)/self.titleCount - x, 0, 25, 15);
    }
    return _signImgView;
}



- (void)personAction{
//    [self handleButtonAction];
//    return;
    [MobClick event:personal_center attributes:@{resource_page:personal_center_bookshelf}];
    [GTCountSDK trackCountEvent:personal_center withArgs:@{resource_page:personal_center_bookshelf}];

    CATransition *transition1 = [CATransition animation];
    transition1.duration = 0.3;
    transition1.type = kCATransitionPush;
    transition1.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition1 forKey:nil];
    JUDIAN_READ_MyController *vc = [JUDIAN_READ_MyController new];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //设置tableview不能下滚
    CGPoint point1 =  [scrollView.panGestureRecognizer translationInView:self.view];
    UIScrollView *scr = self.shelfView.currentScrView;
    if (point1.y > 0 && scr.contentOffset.y > 2) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.height)];
    }
    
    //设置子tableview不能上滚
    if (self.tableView.contentOffset.y < self.tableView.contentSize.height - self.tableView.height) {
        [scr setContentOffset:CGPointZero];
    }
    
    if (self.tableView.contentOffset.y >=  TableContentSize) {
        self.shelfView.lineView.hidden = NO;
    }else{
        self.shelfView.lineView.hidden = YES;
    }
    
}


//- (void)handleButtonAction {
//    FlutterViewController *vc = [JUDIAN_READ_FlutterEnter enterWithRoute:@"/readpage" channel:@"tip.flutter.io/method" context:@{@"bookId":@"1000"}];
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)animationView{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(0.8);
    animation.toValue = @(1.1);
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation3.fromValue = @(M_PI/36);
    animation3.toValue = @(-M_PI/36);
    
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 0.5;
    aniGroup.animations = @[animation,animation3];
    aniGroup.repeatCount = CGFLOAT_MAX;
    aniGroup.removedOnCompletion=NO;
    aniGroup.autoreverses = YES;
    [self.signImgView.layer addAnimation:aniGroup forKey:@"grouani"];
    

}




@end
