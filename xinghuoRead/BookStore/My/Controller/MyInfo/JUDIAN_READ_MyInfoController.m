//
//  JUDIAN_READ_MyInfoController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/17.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MyInfoController.h"
#import "JUDIAN_READ_ImageLabelColCell.h"
#import "JUDIAN_READ_InfoHeadReuseView.h"
#import "JUDIAN_READ_InfoView.h"
#import "JUDIAN_READ_ReadRankModel.h"
#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_UserBriefViewController.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_VipCustomPromptView.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_NorvelShelfCell.h"
#import "JUDIAN_READ_NovelSummaryModel.h"

#define BackOrginY (iPhone6Plus ? (SCREEN_WIDTH-70-Height_NavBar+15-55):(SCREEN_WIDTH-70-Height_NavBar+15)) //默认值
#define BtnIWidth (100)

@interface JUDIAN_READ_MyInfoController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView  *navView;
@property (nonatomic,strong) UIScrollView  *scrView;
@property (nonatomic,strong) UIScrollView  *supScrView;
@property (nonatomic,strong) UIImageView  *backIconView;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *backView;
@property (nonatomic,strong) UIView  *selectItemView;
@property (nonatomic,strong) UILabel  *titleLab;

@property (nonatomic,strong) JUDIAN_READ_InfoView  *infoView;
@property (nonatomic,assign) CGFloat  OriginY;


@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) NSMutableArray  *commonArr;
@property (nonatomic,assign) NSInteger  selectItem;
@property (nonatomic,assign) int  page;
@property (nonatomic,assign) int  commonPage;
@property (nonatomic,assign) int  countTableView;

@property (nonatomic,strong) JUDIAN_READ_ReadRankModel  *info;

@property (nonatomic,strong) UIImageView  *iconView;
@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *colView;



@end

@implementation JUDIAN_READ_MyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    ;
}

- (void)initConfig{
    self.countTableView = (self.isSelf) ? 1 : 2;
   
    self.selectItem = 0;
    self.page = 1;
    self.commonPage = 1;
    self.view.backgroundColor = kColorWhite;
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.backIconView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.supScrView];
    //[self loadPersonInfo];
    [self loadData];
   
}

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
    if (!self.isSelf) {
        if ( [JUDIAN_READ_Account currentAccount].token) {
            self.colView.noticeTitle = @"这个用户比较懒，暂无更多信息";

            [self loadCommonData];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:self];
        }
    }
    
    [self loadPersonInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark 网络请求
- (void)loadData{
    if (!self.uid_b) {
        return;
    }
    NSMutableDictionary *dic = [@{@"uid_b":self.uid_b,@"page":[NSString stringWithFormat:@"%d",self.page]} mutableCopy];
    [JUDIAN_READ_MyTool  getUserRecentBookWithParams:dic completionBlock:^(id result,id error){
        UICollectionView *view = self.scrView.subviews[0];
        if (result) {
            //下拉刷新
            if (!view.mj_footer.isRefreshing) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:result];
            //没有更多
            if([result count] < 20){

                [view.mj_footer endRefreshingWithNoMoreData];
            }
            if ([result count] && self.page == 1 ) {
                self.supScrView.contentSize = CGSizeMake(0,Height_Content+self.OriginY);
            }
            
        }
        if (view.mj_footer.isRefreshing) {
            [view.mj_footer endRefreshing];
        }
        [view reloadData];
    }];
}

- (void)loadCommonData{
    if (![JUDIAN_READ_Account currentAccount].uid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:nil];
        return;
    }
    NSMutableDictionary *dic = [@{@"uid_b":[JUDIAN_READ_Account currentAccount].uid,@"page":[NSString stringWithFormat:@"%d",self.commonPage] } mutableCopy];
    if (!self.isSelf && self.uid_b) {
        [dic setObject:self.uid_b forKey:@"other_uidb"];
    }
    [JUDIAN_READ_MyTool  getUserCommonBookWithParams:dic completionBlock:^(id result,id error){
        UICollectionView *view = self.scrView.subviews[1];
        if (result) {
            //下拉刷新
            if (!view.mj_footer.isRefreshing) {
                [self.commonArr removeAllObjects];
            }
            [self.commonArr addObjectsFromArray:result];
            //没有更多
            if([result count] < 20){
                [view.mj_footer endRefreshingWithNoMoreData];
            }
            
            if ([result count] && self.page == 1 ) {
                self.supScrView.contentSize = CGSizeMake(0,Height_Content+self.OriginY);
            }
           
            [self refreshBtnTitle];
            
        }
        if (view.mj_footer.isRefreshing) {
            [view.mj_footer endRefreshing];
        }
        
        [view reloadData];
    }];
    
}

- (void)refreshBtnTitle{
    JUDIAN_READ_NovelSummaryModel *model = self.commonArr.firstObject;
    if (model.total && model.total.length) {
        UIButton *btn = (UIButton *)self.headView.subviews[1];
        NSString *str = [NSString stringWithFormat:@"共同阅读(%@)",model.total];
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
//        NSRange range = [str rangeOfString:model.total];
//        [att addAttributes:@{NSFontAttributeName : kFontSize10} range:range];
        [btn setTitle:str forState:UIControlStateNormal];
    }
}




- (void)loadPersonInfo{
    if (!self.uid_b) {
        return;
    }
    
    NSString *isself = self.isSelf ? @"true":@"false";
    NSMutableDictionary *dic = [@{@"uid_b":self.uid_b,@"isself":isself} mutableCopy];
    [JUDIAN_READ_MyTool  getUserHomeWithParams:dic completionBlock:^(id result,id error){
        if (result) {
            self.info = result;
            [self upDateInfo];
        }
    }];
}

- (void)upDateInfo{
    self.titleLab.text = self.info.nickname;
    WeakSelf(obj);
    [self.backIconView sd_setImageWithURL:[NSURL URLWithString:self.info.headImg] placeholderImage:[UIImage imageNamed:@"default_user_info_tip"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            obj.backIconView.image = [image imageByBlurRadius:1 tintColor:[UIColor colorWithWhite:0.11 alpha:0.73] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
        }

    }];
    
    NSString* imageUrl = self.info.headImg;
    NSRange formatRange = [imageUrl rangeOfString:@"/format" options:(NSBackwardsSearch)];
    NSRange resizeRange = [imageUrl rangeOfString:@"/resize" options:(NSBackwardsSearch)];
    NSString* avatarUrl = @"";
    
    if (formatRange.length > 0 && resizeRange.length > 0) {
        NSString* leftUrlPart = [imageUrl substringToIndex:resizeRange.location];
        NSString* rightUrlPart = [imageUrl substringFromIndex:formatRange.location];
        avatarUrl = [NSString stringWithFormat:@"%@%@", leftUrlPart, rightUrlPart];
    }
    else {
        avatarUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/132" withString:@"/0"];
    }

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];


    CGFloat y =  [self.infoView setPersonInfoWithModel:self.info isSelf:self.isSelf];
    self.OriginY = BackOrginY + y;
    self.infoView.height = self.OriginY;
//    self.backView.origin = CGPointMake(0, self.OriginY);
    self.backView.frame = CGRectMake(0, self.OriginY, SCREEN_WIDTH, Height_Content);
    if (self.dataArr.count || self.commonArr.count) {
        self.supScrView.contentSize = CGSizeMake(0,Height_Content+self.OriginY);
    }
//    self.scrView.height = Height_Content;
//    self.scrView.subviews[0].height = self.scrView.subviews[1].height = Height_Content;
}


#pragma mark 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)commonArr{
    if (!_commonArr) {
        _commonArr = [NSMutableArray array];
    }
    return _commonArr;
}

- (UIScrollView *)supScrView{
    if (!_supScrView) {
        _supScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, Height_Content)];
        _supScrView.contentSize = CGSizeMake(0,Height_Content+self.OriginY);
        _supScrView.bounces = YES;
        _supScrView.showsVerticalScrollIndicator = NO;
        _supScrView.delegate = self;
        [_supScrView addSubview:self.backView];
        [_supScrView addSubview:self.infoView];
        _supScrView.userInteractionEnabled = YES;

    }
    return _supScrView;
}



- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
        UIButton *imgV = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgV addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV setImage:[UIImage imageNamed:@"nav_return_white"] forState:UIControlStateNormal];
        imgV.frame = CGRectMake(0, Height_StatusBar, 47, Height_NavBar-Height_StatusBar);
        imgV.contentMode = UIViewContentModeCenter;
        [_navView addSubview:imgV];
        
        
        UILabel *centerLab = [[UILabel alloc]initWithFrame:CGRectMake(47, Height_StatusBar, SCREEN_WIDTH-47*2, Height_NavBar - Height_StatusBar)];
        [centerLab setText:@" " titleFontSize:17 titleColot:kColorWhite];
        centerLab.textAlignment = NSTextAlignmentCenter;
        centerLab.alpha = 0;
        self.titleLab = centerLab;
        [_navView addSubview:centerLab];
        
#if 0
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(SCREEN_WIDTH- 53 - 15, Height_StatusBar, 53, Height_NavBar - Height_StatusBar);
        [editBtn setImage:[UIImage imageNamed:@"personal_nav_editor"] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        editBtn.hidden = !self.isSelf;
        [_navView addSubview:editBtn];
#endif
    }
    return _navView;
}

- (UIImageView *)backIconView{
    if (!_backIconView) {
        _backIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _backIconView.contentMode = UIViewContentModeScaleAspectFill;
        _backIconView.image = [UIImage imageNamed:@"default_user_info_tip"];
//        _backIconView.userInteractionEnabled  t= YES;
    }
    return _backIconView;
}

- (JUDIAN_READ_InfoView *)infoView{
    if (!_infoView) {
        _infoView = [[[NSBundle mainBundle] loadNibNamed:@"JUDIAN_READ_InfoView" owner:self options:nil] lastObject];
        _infoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.OriginY);
        WeakSelf(obj);
        _infoView.lockBlock = ^{
            if (obj.isSelf) {
                [obj edit];
                return;
            }
            
            if ([JUDIAN_READ_Account currentAccount].vip_status.intValue == 1) {
                [GTCountSDK trackCountEvent:@"personal_home_page" withArgs:@{@"unlockWechat":@"会员身份"}];
                [MobClick event:@"personal_home_page" attributes:@{@"unlockWechat":@"会员身份"}];

                NSString *str = obj.info.wxNo ? obj.info.wxNo : @"";
                [JUDIAN_READ_VipCustomPromptView createInfoHomePromptView:obj.view text:@"查看微信" detailText:[NSString stringWithFormat:@"微信号:%@",str] btnText:@"复制" block:^(id  _Nonnull args) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = obj.info.wxNo;
                }];
            }else{
                [GTCountSDK trackCountEvent:@"personal_home_page" withArgs:@{@"unlockWechat":@"非会员身份"}];
                [MobClick event:@"personal_home_page" attributes:@{@"unlockWechat":@"非会员身份"}];
                [JUDIAN_READ_VipCustomPromptView createInfoHomePromptView:obj.view text:@"温馨提示" detailText:@"该功能需要会员身份才能查看" btnText:@"去开通" block:^(id  _Nonnull args) {
                    JUDIAN_READ_VipController *vip = [JUDIAN_READ_VipController new];
                    [obj.navigationController pushViewController:vip animated:YES];
                }];
            }
        };
        _infoView.LookImgViewBlock = ^{
            if (obj.info.headImg.length) {
                [obj.view addSubview:obj.iconView];
            }
        };
    }
    return _infoView;
}



- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, BackOrginY-90, SCREEN_WIDTH, Height_Content - (BackOrginY-90))];
        _backView.backgroundColor = kColorWhite;
        [_backView doBorderWidth:0 color:nil cornerRadius:20];
        [_backView addSubview:self.headView];
        [_backView addSubview:self.scrView];
    }
    return _backView;
}


- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 35)];
        NSArray *titles = @[@"最近在读",@"共同阅读"];
        for (NSInteger i = 0; i < self.countTableView; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(touchScroll:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+1;
            btn.frame = CGRectMake(i*BtnIWidth, 0, BtnIWidth, 35);
            [btn setText:titles[i] titleFontSize:14 titleColot:kColor51];
            [_headView addSubview:btn];
        }
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH, 0.5)];
        sepView.backgroundColor = KSepColor;
        [_headView addSubview:sepView];
        
        if (self.countTableView == 2) {
            UIButton *btn =  _headView.subviews[self.selectItem];
            [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
            self.selectItemView = [[UIView alloc]initWithFrame:CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0, 35-2, 27, 2)];
            [self.selectItemView doBorderWidth:0 color:nil cornerRadius:2];
            self.selectItemView.backgroundColor = kThemeColor;
            [_headView addSubview:self.selectItemView];
        }

      
        
    }
    return _headView;
}

- (UIScrollView *)scrView{
    if (!_scrView) {
        CGFloat height = Height_Content;
        _scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, height)];
        _scrView.contentSize = CGSizeMake(SCREEN_WIDTH * self.countTableView,  0);
        _scrView.pagingEnabled = YES;
        _scrView.showsHorizontalScrollIndicator = NO;
        _scrView.bounces = NO;
        _scrView.delegate = self;
        for (NSInteger i = 0; i < self.countTableView; i++) {
            JUDIAN_READ_BaseTableView *colView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, height-35) style:UITableViewStylePlain];
            [colView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_NorvelShelfCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_NorvelShelfCell"];
            colView.delegate = self;
            colView.dataSource = self;
            colView.needSimulate = YES;
            colView.noticeTitle = @"这个用户比较懒，暂无更多信息";
            colView.noitceImageName = @"personal_default_information";
            if (![JUDIAN_READ_Account currentAccount].token && i == 1) {
                colView.noitceImageName = @"personal_default_reading";
                colView.noitceOperateImage = @"personal_login_btn";
                colView.noticeTitle = @"登录后，查看共同阅读的小说";
                self.colView = colView;
                colView.needDelegateNotShow = YES;
            }
            colView.verticalSpace = -120;
            WeakSelf(obj);
            colView.emptyCallBack = ^(int type) {
                obj.page = 1;
                [obj loadPersonInfo];
                if (i == 0) {
                    [obj loadData];
                }else{
                    if (type == 2) {
                        JUDIAN_READ_WeChatLoginController *vc = [JUDIAN_READ_WeChatLoginController new];
                        [obj.navigationController pushViewController:vc animated:YES];
                    }else{
                        [obj loadCommonData];
                    }
                }
            };
            
            MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
                if (i == 0) {
                    obj.page++;
                    [obj loadData];
                }else{
                    obj.commonPage++;
                    [obj loadCommonData];
                }
            }];
            colView.mj_footer = foot;
            foot.stateLabel.textColor = kColor153;
            foot.stateLabel.font = kFontSize12;
            [foot setTitle:BOTTOM_LINE_TIP forState:MJRefreshStateNoMoreData];
            [foot setImages:nil forState:MJRefreshStateNoMoreData];
            [_scrView addSubview:colView];
        }
        
    }
    return _scrView;
}


- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _iconView.backgroundColor = [UIColor blackColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSelf)];
        [_iconView addGestureRecognizer:tap];
    }
    return _iconView;
}

- (void)dismissSelf{
    [self.iconView removeFromSuperview];
}



#pragma mark UICollection代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.scrView.subviews.count <= 0) {
        return 0;
    }
    
    if ([tableView isEqual:self.scrView.subviews[0]]) {
        return self.dataArr.count;
    }
    return self.commonArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return iPhone6Plus ? 117 : 107;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUDIAN_READ_NorvelShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_NorvelShelfCell" forIndexPath:indexPath];
    NSMutableArray *arr = [tableView isEqual:self.scrView.subviews[0]] ? self.dataArr : self.commonArr;
    [cell setShelfDataWithModel:arr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = [tableView isEqual:self.scrView.subviews[0]] ? self.dataArr : self.commonArr;
    JUDIAN_READ_NovelSummaryModel *info = arr[indexPath.row];
    if (info.nid) {
        
        [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"个人中心"}];
        [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : @"个人中心"}];
        
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:@"个人中心"];
    }
    
}

#pragma mark scrollView相关
- (void)touchScroll:(UIButton *)btn{
    if (btn.tag - 1 == self.selectItem) {
        return;
    }
    
    CGFloat x = (self.selectItem+1 - btn.tag)*BtnIWidth;
    CGFloat px = x < 0 ? -x : x ;
    [UIView animateWithDuration:0.25 animations:^{
        if (x < 0) {

            self.selectItemView.frame = CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0, 35-2, 27+px, 2);
        }else{
            self.selectItemView.frame = CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0 - x, 35-2, 27+px, 2);
        }
    } completion:^(BOOL finished) {
        self.selectItem = btn.tag - 1;
        self.scrView.contentOffset = CGPointMake(self.selectItem*SCREEN_WIDTH, 0);
        [self changeUI];
        [UIView animateWithDuration:0.1 animations:^{
            self.selectItemView.frame = CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0, 35-2, 27, 2);
        }];
    }];
    
}

- (void)scrollHeadNavWithScrollView:(UIScrollView *)scr{
    
    //获取最初偏移量
    CGFloat offsetX = self.selectItem * SCREEN_WIDTH;
    //绝对偏移量
    CGFloat changeX = scr.contentOffset.x - offsetX;
    CGFloat positionChangeX = changeX < 0 ? -changeX : changeX;
    
    //nav移动距离
    CGFloat x = BtnIWidth/SCREEN_WIDTH * changeX;
    CGFloat positionX =  BtnIWidth/SCREEN_WIDTH * positionChangeX;
    if (x != 0) {
        [UIView animateWithDuration:0.15 animations:^{
            if (x > 0) {
            
                self.selectItemView.frame = CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0, 35-2, 27+positionX, 2);

            }else{
                
                self.selectItemView.frame = CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0 + x, 35-2, 27+positionX, 2);

            }
        }];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //左右切换
    if ([scrollView isEqual:self.scrView] ) {
        [self scrollHeadNavWithScrollView:scrollView];
        return;
    }
    
    //到顶关闭弹簧效果
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (self.supScrView.contentOffset.y >= self.supScrView.contentSize.height - Height_Content) {
        self.supScrView.bounces = NO;
    }else{
        self.supScrView.bounces = YES;
    }
    
    //底部scrview
    if ([scrollView isEqual:self.supScrView]) {
        //设置文字显示
        self.titleLab.alpha = self.supScrView.contentOffset.y / ((self.supScrView.contentSize.height - Height_Content) * 1.0);
        
        if (yOffset < 0) {//下拉放大
            self.backIconView.height = SCREEN_WIDTH -  yOffset;
            self.backIconView.width = SCREEN_WIDTH - yOffset;
            self.backIconView.origin = CGPointMake(yOffset/2, self.backIconView.origin.y);
        }else{
            self.backIconView.height = SCREEN_WIDTH;
            self.backIconView.width = SCREEN_WIDTH;
            self.backIconView.origin = CGPointMake(0, self.backIconView.origin.y);
        }
        //设置supScrView不能下滚
        CGPoint point1 =  [scrollView.panGestureRecognizer translationInView:self.view];
        UIScrollView *scr = self.scrView.subviews[self.selectItem];
        if (point1.y > 0 && scr.contentOffset.y > 5) {
            [self.supScrView setContentOffset:CGPointMake(0, self.supScrView.contentSize.height - Height_Content)];
        }
        return;
    }
    
    //设置colview不能上滚
    if (![scrollView isEqual:self.scrView] && ![scrollView isEqual:self.supScrView]) {
        scrollView.bounces = YES;
        if (self.supScrView.contentOffset.y < self.supScrView.contentSize.height - Height_Content) {
            //supScrView下移将所有colview偏移量设0
            for (UICollectionView *view in self.scrView.subviews) {
                if ([view isKindOfClass:[UICollectionView class]]) {
                    [view setContentOffset:CGPointZero];
                }
            }
            scrollView.bounces = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrView] ) {
        self.selectItem = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self changeUI];
        [UIView animateWithDuration:0.2 animations:^{
            self.selectItemView.frame = CGRectMake(BtnIWidth*self.selectItem+(BtnIWidth-27)/2.0 , 35-2, 27, 2);
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrView] ) {
        for (JUDIAN_READ_BaseCollectionView *view in self.scrView.subviews) {
            if ([view isKindOfClass:[JUDIAN_READ_BaseCollectionView class]]) {
                view.needSimulate = NO;
            }
        }
    }else{
        for (JUDIAN_READ_BaseCollectionView *view in self.scrView.subviews) {
            if ([view isKindOfClass:[JUDIAN_READ_BaseCollectionView class]]) {
                view.needSimulate = YES;
            }
        }
        
        
    }
}

- (void)changeUI{
    if (self.selectItem == 1 && ![JUDIAN_READ_Account currentAccount].token) {
        [self loadCommonData];
    }
    for (int i = 0; i < self.countTableView; i++) {
        if (self.headView.subviews.count > self.countTableView) {
            UIButton *btn = self.headView.subviews[i];
            [btn setTitleColor:kColor51 forState:UIControlStateNormal];
        }
    }
    UIButton *btn = self.headView.subviews[self.selectItem];
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
}




#pragma mark 按钮事件
- (void)edit{
    [JUDIAN_READ_UserBriefViewController enterUserBriefViewController:self.navigationController];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    
}

@end
