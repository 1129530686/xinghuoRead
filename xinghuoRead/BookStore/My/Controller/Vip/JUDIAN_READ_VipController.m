//
//  JUDIAN_READ_VipController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_SearchColCell.h"
#import "JUDIAN_READ_VipReusableView.h"
#import "JUDIAN_READ_ImageLabelColCell.h"
#import "JUDIAN_READ_BuyRecordController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_VipModel.h"
#import "JUDIAN_READ_IAPShare.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_MyTool.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "NSUserDefaults+JUDIAN_READ_UserDefaults.h"
#import "JUDIAN_READ_PayTypeController.h"
#import "JUDIAN_READ_VipColCell.h"
#import "JUDIAN_READ_RechargeController.h"
#import "JUDIAN_READ_CollectionViewCell.h"
#import "JUDIAN_READ_LoadingFictionView.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_PayLoadView.h"

#define headimageHeight   (Height_NavBar +  94) //头部视图的高度

#define ANNUAL_MEMBER 4
#define PERMENANT_MEMBER 5

@interface JUDIAN_READ_VipController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic,strong) UICollectionView  *collectView;
@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UIImageView  *personView;
@property (nonatomic,strong) NSMutableArray  *icons;
@property (nonatomic,strong) NSMutableArray  *rightArr;
@property (nonatomic,strong) NSArray  *desTitles;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UILabel  *moneyLab;
@property (nonatomic,strong) JUDIAN_READ_VipModel *info;
@property (nonatomic,strong) UIView  *naView;


@property (nonatomic,strong) UIButton  *statusLab;
@property (nonatomic,strong) UILabel  *timeLab;
@property (nonatomic,strong) UIButton  *vipLoginBtn;
@property (nonatomic,strong) UIImageView  *iconView;
@property (nonatomic,strong) UILabel  *nameLab;
@property (nonatomic,strong) UIImageView  *typeImgV;

@property (nonatomic,strong) UIButton  *payBtn;
@property (nonatomic,strong) UIButton  *restoreBtn;
@property (nonatomic,strong) UILabel  *lineLab;
@property (nonatomic,assign) BOOL  isAdded;
@property (nonatomic,strong) JUDIAN_READ_PayLoadView  *emptyView;



@end

@implementation JUDIAN_READ_VipController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GTCountSDK trackCountEvent:@"vip_center" withArgs:@{@"exposureCount":@"曝光次数"}];
    [MobClick event:@"vip_center" attributes:@{@"exposureCount":@"曝光次数"}];

    if (@available(iOS 11,*)) {
        self.collectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectView];
    [self addNavView];
    [self.collectView addSubview:self.personView];
    self.collectView.clipsToBounds = YES;
    [self loadAnimation];
    
    if ([JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        [self loadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    if (![JUDIAN_READ_Account currentAccount].token) {
        NSDictionary *dic = @{@"vip_type":@"-1"};
        [self requestGuestInfo:dic];
    }else{
        [self updateInfo];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark  网络请求
- (void)loadData{
    [JUDIAN_READ_MyTool getChargeTypeWithParams:@{@"type":@"ios"} completionBlock:^(id result, id error) {
        if (result) {
            self.dataArr = result;
            [self.view addSubview:self.footView];
            self.info = self.dataArr.count >= 2 ? self.dataArr[1] : self.dataArr.firstObject;
            self.info.isSelected = YES;
            [self setPayInfo:self.info];
        }
        [self.collectView reloadData];
    }];
}

- (void)requestGuestInfo:(NSDictionary *)dic{
    [JUDIAN_READ_MyTool uploadVipStatusWithParams:dic completionBlock:^(id result, id error) {
        [self updateInfo];
    }];
}

- (void)updateInfo{
    JUDIAN_READ_Account *account = [JUDIAN_READ_Account currentAccount];
    self.lineLab.hidden = YES;
    
    //用户未登录
    if (!account.token) {
        self.nameLab.hidden = YES;
        self.typeImgV.hidden = YES;
        self.iconView.hidden = YES;
        self.vipLoginBtn.hidden = NO;
    }else{
        self.nameLab.hidden = NO;
        self.iconView.hidden = NO;
        self.vipLoginBtn.hidden = YES;
        self.nameLab.text = account.nickname;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:account.avatar] placeholderImage:[UIImage imageNamed:@"head_default_small"]];
    }
    
    if (account.vip_status.integerValue  == 1) {//开通会员
        self.typeImgV.hidden = NO;
        NSString *vipImgN = account.vip_type.intValue == 5 ? @"members_icon_crown_permanent" : @"members_icon_crown_annual";
        self.typeImgV.image = [UIImage imageNamed:vipImgN];
        NSString *type = account.vip_type.integerValue == ANNUAL_MEMBER ? @"年度会员" : @"永久会员";
        NSString *time = account.vip_type.integerValue == ANNUAL_MEMBER ? [NSString stringWithFormat:@"%@到期",account.end_time] : [NSString stringWithFormat:@"购买时间：%@",account.start_time];
        NSString *Str = [NSString stringWithFormat:@"您当前已是：%@",type];
        [self.statusLab setTitle:Str forState:UIControlStateNormal];
        self.timeLab.text = time;
        if (account.vip_type.integerValue == PERMENANT_MEMBER) {
            [self.footView removeFromSuperview];
            [self.collectView reloadData];
        }
    }else{
        if(account.vip_status.integerValue  == 2){//会员过期
            self.typeImgV.hidden = NO;
            [self.statusLab setTitle:@"会员已过期" forState:UIControlStateNormal];
            self.typeImgV.image = [UIImage imageNamed:@"members_icon_crown_overdue"];
            self.timeLab.text = [NSString stringWithFormat:@"%@到期",account.end_time];
        }else{//未开通
            self.typeImgV.hidden = YES;
            [self.statusLab setTitle:@"未开通会员" forState:UIControlStateNormal];
            self.timeLab.text = @"开通会员，畅想更多特权";
           
        }
    }
    
}


#pragma mark  懒加载
-  (UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat height = SCREEN_HEIGHT- 50;
        layout.minimumInteritemSpacing = 10;
        if (iPhoneX) {
            height = SCREEN_HEIGHT - 50 - BottomHeight;
        }
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.backgroundColor = [UIColor clearColor];
        CGFloat orignY = iPhone6Plus ? 190 : 180;
        _collectView.contentInset = UIEdgeInsetsMake(orignY+Height_NavBar, 0, 0, 0);
        _collectView.showsVerticalScrollIndicator = NO;
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_VipReusableView class]) bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReuse"];
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_VipReusableView class]) bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_SearchColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_SearchColCell"];
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_VipColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_VipColCell"];
        
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_CollectionViewCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_CollectionViewCell"];
        
        [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot2"];
        
    }
    return _collectView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"members_bg"]];
        _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headimageHeight);
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (void)addNavView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, Height_NavBar)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
    self.naView = view;
    [self.view addSubview:view];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, Height_StatusBar, 40, Height_NavBar-Height_StatusBar);
    btn.contentMode = UIViewContentModeCenter;
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"nav_return_white"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    [lab setText:@"会员中心" titleFontSize:17 titleColot:kColorWhite];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(btn);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(buyRecord) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setText:@"购买记录" titleFontSize:14 titleColot:kColorWhite];
    [view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn);
        make.trailing.equalTo(@(-15));
    }];
}


- (void)addWarmTipView:(UIView *)view {
    if (self.isAdded) {
        return;
    }
    self.isAdded = YES;
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0.5)];
    sepView.backgroundColor = KSepColor;
    [view addSubview:sepView];
    
    WeakSelf(that);
    UILabel* warmTipView = [[UILabel alloc]init];
    warmTipView.numberOfLines = 0;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic = @{NSFontAttributeName:kFontSize12,NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:kColor153};
    NSString *str = @"温馨提示：\n1.iOS端购买的会员只能在追书宝iOS客户端内使用；\n2.您的历史充值记录，可在充值记录中查看；\n3.如有其他疑问，请加客服QQ群：612489895;\n\n";
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:str attributes:dic];
    paraStyle.lineSpacing = 5;
    warmTipView.attributedText = attributeStr;

    [view addSubview:warmTipView];

    NSInteger width = CGRectGetWidth(self.view.frame) - 2 * 15;
    NSInteger height = [warmTipView getTextHeight:width] + 20;
    height = ceil(height);

    [warmTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(15);
        make.right.equalTo(that.view.mas_right).offset(-15);
        make.top.equalTo(@20);
        make.height.equalTo(@(height));
    }];
    
}

- (void)loadAnimation{
    
    
    
}

//设置支付方式
- (void)payType{
    JUDIAN_READ_PayTypeController *vc = [JUDIAN_READ_PayTypeController new];
    [self.navigationController pushViewController:vc animated:YES];
}




- (NSMutableArray *)rightArr{
    if (!_rightArr) {
        _rightArr = [NSMutableArray arrayWithObjects:@"尊贵标识",@"解锁书友",@"更多权益",nil];
    }
    return _rightArr;
}

- (NSMutableArray *)icons{
    if (!_icons) {
        _icons = [NSMutableArray arrayWithObjects:@"members_nterests_icon_crown",@"members_nterests_icon_unlock",@"members_nterests_icon_more",nil];
    }
    return _icons;
}

- (NSArray *)desTitles{
    if (!_desTitles) {
        _desTitles = @[@"彰显独特身份",@"突破交流限制",@"更多专享功能权益"];
    }
    return _desTitles;
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIImageView *)personView{
    if (!_personView) {
        _personView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"members_card"]];
        CGFloat orignY = iPhone6Plus ? -190 : -180;
        CGFloat h0 = iPhone6Plus ? 170 : 160;
        _personView.frame = CGRectMake(15, orignY + 15, SCREEN_WIDTH-30, h0);
        _personView.contentMode = UIViewContentModeScaleAspectFill;
        _personView.userInteractionEnabled = YES;
        [_personView doBorderWidth:0 color:nil cornerRadius:7];
        
        UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"members_card_light"]];
        [_personView addSubview:lineView];
        CGFloat h = iPhone6Plus ? 162 : 150;
        lineView.frame = CGRectMake(-75, 0, 75, h);
        
        WeakSelf(obj);
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position.x"];
        //2 设置属性
        basic.repeatCount = INFINITY;
        basic.autoreverses = NO;
        basic.speed = 1;
        basic.duration = 5;
        basic.toValue = [NSValue valueWithCGRect:CGRectMake((CGRectGetMaxX(obj.personView.frame)-50)*2, 0, 75, h)];
        //3 添加动画
        [lineView.layer addAnimation:basic forKey:nil];
    
        UIButton *lab = [UIButton buttonWithType:UIButtonTypeCustom];
        [lab setText:@"未开通会员" titleFontSize:17 titleColot:kColorBrown];
        lab.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.statusLab = lab;
        [_personView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@14);
            make.left.equalTo(@15);
        }];
        
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [timeLab setText:@"开通会员" titleFontSize:12 titleColot:kColorBrown];
        self.timeLab = timeLab;
        [_personView addSubview:timeLab];
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.statusLab.mas_left);
            make.top.equalTo(obj.statusLab.mas_bottom).offset(7);;
        }];
        
        self.vipLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.vipLoginBtn setText:@"去登录" titleFontSize:14 titleColot:kColorBrown];
        [self.vipLoginBtn addTarget:self action:@selector(loginIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.vipLoginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.vipLoginBtn doBorderWidth:0.5 color:kColorBrown cornerRadius:3];
        [_personView addSubview:self.vipLoginBtn];
        [self.vipLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.statusLab.mas_left);
            make.bottom.equalTo(@-37);
            make.width.equalTo(@60);
            make.height.equalTo(@23);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_default_small"]];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [iconView doBorderWidth:0.5 color:kColorWhite cornerRadius:33/2.0];
        [_personView addSubview:iconView];
        self.iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.statusLab.mas_left);
            make.height.width.equalTo(@33);
            make.bottom.equalTo(@-32);

        }];
        
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [nameLab setText:[NSString stringWithFormat:@"哈哈"] titleFontSize:14 titleColot:kColorBrown];
        [_personView addSubview:nameLab];
        self.nameLab = nameLab;
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(9);
            make.centerY.equalTo(obj.iconView);
            make.width.mas_lessThanOrEqualTo(@(SCREEN_WIDTH-9-33-60-30-5)).priorityLow();
        }];
        
        
        UIImageView *typeImgV = [[UIImageView alloc]init];
        typeImgV.contentMode = UIViewContentModeScaleAspectFill;
        [_personView addSubview:typeImgV];
        self.typeImgV = typeImgV;
        [typeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLab.mas_right).offset(5).priorityHigh();
            make.right.lessThanOrEqualTo(@-15).priorityHigh();
            make.centerY.equalTo(obj.iconView);
           

        }];
        [self updateInfo];
        
    }
    return _personView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50-BottomHeight, SCREEN_WIDTH, 50)];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        view.backgroundColor = KSepColor;
        [_footView addSubview:view];
        if(iPhoneX){
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
            view1.backgroundColor = KSepColor;
            [_footView addSubview:view1];
        }
        UILabel *lab = [[UILabel alloc]init];
        [_footView addSubview:lab];
        self.moneyLab = lab;
        [lab setText:@"" titleFontSize:19 titleColot:kThemeColor];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(@-120);
            make.centerY.equalTo(@0);
        }];
        
//        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectZero];
//        [_footView addSubview:lab1];
//        self.titleLab = lab1;
//        [lab1 setText:@"" titleFontSize:12 titleColot:kColor100];
//        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@15);
//            make.bottom.equalTo(@-4);
//            make.right.equalTo(@-120);
//        }];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyButton setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
        [buyButton setText:@"立即购买" titleFontSize:16 titleColot:kColorWhite];
        [buyButton addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:buyButton];
        self.payBtn = buyButton;
        
        UIButton *restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [restoreButton setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
        [restoreButton setText:@"恢复购买" titleFontSize:16 titleColot:kColor100];
        [restoreButton doBorderWidth:0.5 color:KSepColor cornerRadius:0];
        [restoreButton addTarget:self action:@selector(restoreMemberState) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:restoreButton];
        restoreButton.hidden = YES;
        self.restoreBtn = restoreButton;
        
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@113);
            make.top.equalTo(@0.5);
            make.height.equalTo(@49);
            make.right.equalTo(@0);
        }];
        
        
        [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@90);
            make.height.equalTo(@50);
            make.top.equalTo(@0);
            make.right.equalTo(buyButton.mas_left).offset(0);
        }];
        
        
    }
    return _footView;
}

#pragma collectionview代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([JUDIAN_READ_Account currentAccount].vip_type.intValue == PERMENANT_MEMBER) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        return self.dataArr.count;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0  && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        JUDIAN_READ_VipColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_VipColCell" forIndexPath:indexPath];
        [cell setDataWithModel:self.dataArr indexPath:indexPath];
        return cell;
        
    }
    JUDIAN_READ_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_CollectionViewCell" forIndexPath:indexPath];
    [cell setVipDataWithModel:self.icons model2:self.rightArr model3:self.desTitles  indexPath:indexPath];
    return cell;
}

- (void)setPayInfo:(JUDIAN_READ_VipModel *)model{
    NSString *str = [NSString stringWithFormat:@"实付：¥%@",model.price];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    [att addAttributes:@{NSForegroundColorAttributeName:kColor51,NSFontAttributeName:kFontSize12} range:NSMakeRange(0, 3)];
    [att addAttributes:@{NSFontAttributeName:kFontSize12} range:[str rangeOfString:@"¥"]];
    self.moneyLab.attributedText = att;
    
    self.restoreBtn.hidden = YES;
    if(model.original_price.intValue >= 298) {
        self.restoreBtn.hidden = NO;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0  && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        return CGSizeMake((SCREEN_WIDTH-24-15)/2, (SCREEN_WIDTH-24-15)/4);
    }
    return CGSizeMake((SCREEN_WIDTH-30)/3, 90);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0  && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 145);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0  && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        return CGSizeZero;
    }
    return  CGSizeMake(SCREEN_WIDTH, 35);

}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(obj);
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (indexPath.section == 0 && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
            JUDIAN_READ_VipReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot" forIndexPath:indexPath];
            view.leadSetBlock = ^{
                [obj payType];
            };
            view.refreshBlock = ^{
                [obj chargeAgin];
            };
            [view setVipSetDataWithModel:nil indexPath:indexPath];
            
            return view;
        }
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot2" forIndexPath:indexPath];
        [self addWarmTipView:view];
        return view;
        
    }else{
        JUDIAN_READ_VipReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headReuse" forIndexPath:indexPath];
        [view setVipDataWithModel:nil indexPath:indexPath];
        return view;
    }
}

- (void)chargeAgin{
    JUDIAN_READ_RechargeController *vc = [JUDIAN_READ_RechargeController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        for (JUDIAN_READ_VipModel *model in self.dataArr) {
            model.isSelected = NO;
        }
        JUDIAN_READ_VipModel *info = self.dataArr[indexPath.row];
        info.isSelected = YES;
        self.info = info;
        [self setPayInfo:info];
        [collectionView reloadData];
    }
   
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0 && [JUDIAN_READ_Account currentAccount].vip_type.intValue != PERMENANT_MEMBER) {
        return UIEdgeInsetsMake(0, 12, 0, 12);
    }
    
    return UIEdgeInsetsMake(17, 0, 25, 0);
    
}

- (void)buyRecord{
    JUDIAN_READ_BuyRecordController *vc = [JUDIAN_READ_BuyRecordController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}



//会员购买
- (void)goToPay{
    [GTCountSDK trackCountEvent:@"vip_center" withArgs:@{@"payType":@"IAP"}];
    [GTCountSDK trackCountEvent:@"vip_center" withArgs:@{@"payType":self.info.title}];
    [MobClick event:@"vip_center" attributes:@{@"payType":@"AP"}];
    [MobClick event:@"vip_center" attributes:@{@"payType":self.info.title}];

    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{click_pay : @"点击去支付按钮",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    [MobClick event:payRecord attributes:dictionary];
    
    [self charge];
}


#pragma mark 支付
- (void)charge{
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    if (!self.info.title) {
        self.info.title = @"";
    }
    if (!self.info.ID) {
        [MBProgressHUD showMessage:@"产品不能为空"];
        return;
    }
    
    NSDictionary* dictionary = @{click_pay_confirm : @"确认支付按钮",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    [MobClick event:payRecord attributes:dictionary];
    
    if ([JUDIAN_READ_Account currentAccount].token) {
        NSDictionary *dic = @{@"recharge_id":self.info.ID,@"payment_category":@"iap",@"type":@"ios"};
        WeakSelf(that);
        [JUDIAN_READ_MyTool createOrderWithParams:dic completionBlock:^(id result, id error) {
            if (result) {
                [self showLoadingView:YES];
                [that launchIap:result];
            }
        }];
    }else{
        [self showLoadingView:YES];
        [self launchIapForAppstore:self.info.ID];
    }
    
}


- (void)restoreMemberState {
    
    [self showLoadingView:YES];
    [NSUserDefaults saveUserDefaults:_IS_PERMANENT_MEMBER_ value:@"NO"];
    //[NSUserDefaults saveUserDefaults:_IS_PERMANENT_MEMBER_ value:@"NO"];
    static NSString* memberIdentifier = @"com.szjudian.zhuishubao.permanent";
    NSSet* dataSet = [[NSSet alloc] initWithObjects:memberIdentifier, nil];
    [JUDIAN_READ_IAPShare sharedHelper].iap = [[JUDIAN_READ_IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    [[JUDIAN_READ_IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        
        //NSInteger numberOfTransactions = payment.transactions.count;
        BOOL isSuccess = FALSE;
        for (SKPaymentTransaction *transaction in payment.transactions) {
            NSString *purchased = transaction.payment.productIdentifier;
            if([purchased isEqualToString:memberIdentifier]){
                //[NSUserDefaults saveUserDefaults:_IS_PERMANENT_MEMBER_ value:@"YES"];
                isSuccess = TRUE;
                break;
            }
        }
        
        [self showLoadingView:NO];
        
        if (isSuccess) {
            [MBProgressHUD showMessage:@"恢复成功"];
            JUDIAN_READ_Account* account = [JUDIAN_READ_Account currentAccount];
            account.vip_type = @"5";
            account.vip_status = @"1";
            [JUDIAN_READ_Account saveCurrentAccount:account];
            
            [NSUserDefaults saveUserDefaults:_IS_PERMANENT_MEMBER_ value:@"YES"];
            
            [self updateInfo];
            [self.collectView reloadData];
        }
        else {
            [MBProgressHUD showMessage:@"未购买永久会员"];
        }
        
    }];
    
}




#pragma mark服务端验证
- (void)launchIap:(NSDictionary*) result {
    
    NSString* productIdentifier = result[@"appstroe_pid"];
    NSString* orderId = result[@"trade_no"];
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productIdentifier, nil];
    [JUDIAN_READ_IAPShare sharedHelper].iap = [[JUDIAN_READ_IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#if _IS_RELEASE_VERSION_ == 1
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = YES;
#else
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = NO;
#endif
    
    WeakSelf(that);
    [[JUDIAN_READ_IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response && [JUDIAN_READ_IAPShare sharedHelper].iap.products.count > 0) {
             
             SKProduct* product =[[JUDIAN_READ_IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             [[JUDIAN_READ_IAPShare sharedHelper].iap buyProduct:product
                                                    onCompletion:^(SKPaymentTransaction* trans){
                                                        
                                                        if(trans.error)
                                                        {
                                                            [that payFailure];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                            
                                                            NSData* appstoreData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                            NSString* receipt = [appstoreData base64EncodedStringWithOptions:0];
                                                            
                                                            NSString* path = [[JUDIAN_READ_IAPShare sharedHelper] getChargeFilePath:orderId];
                                                            [receipt writeToFile:path atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
                                                            
                                                            [JUDIAN_READ_UserReadingModel addChargeHistory:orderId type:@"1"];
                                                            
                                                            [that verifyOrder:orderId receipt:receipt trans:trans];
                                                            
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                            [that payFailure];
                                                        }
                                                    }];
         }
         else {
             [that payFailure];
         }
     }];
}


#pragma mark appstore验证
- (void)launchIapForAppstore:(NSString*)index {
    
    NSString* productIdentifier = @"";
    
    if ([index isEqualToString:@"4"]) {
        productIdentifier = @"com.szjudian.zhuishubao.oneyear";
    }
    else if([index isEqualToString:@"5"]) {
        productIdentifier = @"com.szjudian.zhuishubao.permanent";
    }
    
    NSSet* dataSet = [[NSSet alloc] initWithObjects:productIdentifier, nil];
    [JUDIAN_READ_IAPShare sharedHelper].iap = [[JUDIAN_READ_IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
#if _IS_RELEASE_VERSION_ == 1
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = YES;
#else
    [JUDIAN_READ_IAPShare sharedHelper].iap.production = NO;
#endif
    
    WeakSelf(that);
    [[JUDIAN_READ_IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response && [JUDIAN_READ_IAPShare sharedHelper].iap.products.count > 0) {
             
             SKProduct* product =[[JUDIAN_READ_IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             [[JUDIAN_READ_IAPShare sharedHelper].iap buyProduct:product
                                                    onCompletion:^(SKPaymentTransaction* trans){
                                                        
                                                        if(trans.error)
                                                        {
                                                            [that payFailure];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                            
                                                            NSData* appstoreData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                            [[JUDIAN_READ_IAPShare sharedHelper].iap checkReceipt:appstoreData onCompletion:^(NSString *response, NSError *error) {
                                                                
                                                                //Convert JSON String to NSDictionary
                                                                NSDictionary* rec = [JUDIAN_READ_IAPShare toJSON:response];
                                                                if([rec[@"status"] integerValue] == 0)
                                                                {
                                                                    [[JUDIAN_READ_IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                                                    [that paySuccessForAppstore];
                                                                }
                                                                else if([rec[@"status"] integerValue] == 21007) {
                                                                    [that paySuccessForAppstore];
                                                                }
                                                                else {
                                                                    [that payFailure];
                                                                }
                                                            }];
                                                        }
                                                        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                            [that payFailure];
                                                        }
                                                    }];
         }
         else {
             [that payFailure];
         }
         
     }];
    
}


- (void)paySuccessForAppstore {
    [self insertRecord];
    //1.1 调用接口
    if (!self.info.ID) {
        self.info.ID = @"";
    }
    NSString *type = @"";
    JUDIAN_READ_Account *acc = [JUDIAN_READ_Account currentAccount];
    if (acc.vip_type.intValue > self.info.ID.intValue) {
        type = acc.vip_type;
    }else{
        type = self.info.ID;
    }
    NSDictionary *dic = @{@"vip_type":type,@"price":[NSString stringWithFormat:@"%d",self.info.price.intValue]};
    [self requestGuestInfo:dic];
}

- (void)paySuccess {
    [self insertRecord];
    if (self.refreshBlock) {
        self.refreshBlock();
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self refreshData];
}

- (void)insertRecord{
    
    [self showLoadingView:NO];
    [MBProgressHUD showMessage:@"购买成功"];
    
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    
    NSDictionary* dictionary = @{pay_success :  @"支付成功",
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"level":self.info.title
                                 };
    
    [MobClick event:payRecord attributes:dictionary];
}

- (void)payFailure {
    [self showLoadingView:NO];
    [MBProgressHUD showMessage:@"购买失败"];
}

- (void)verifyOrder:(NSString*)orderId receipt:(NSString*)receipt trans:(SKPaymentTransaction*)trans {
    
    if (!orderId || !receipt) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"trade_no" : orderId,
                                 @"type" : @"ios",
                                 @"receipt" : receipt
                                 };
    WeakSelf(that);
    [JUDIAN_READ_MyTool updateAppPayWithParams:dictionary completionBlock:^(id result, id error) {
        
        [[JUDIAN_READ_IAPShare sharedHelper] deleteChargeFile:orderId];
        [JUDIAN_READ_UserReadingModel deleteChargeHistory:orderId];
        
        if (result) {
            if ([result isEqualToString:@"1"]) {
                [[JUDIAN_READ_IAPShare sharedHelper].iap provideContentWithTransaction:trans];
            }
            [that paySuccess];
        }
        else {
            [that payFailure];
        }
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.mj_offsetY < -180-Height_NavBar+Height_StatusBar - 90) {
        scrollView.mj_offsetY = -180-Height_NavBar+Height_StatusBar - 90;
    }
    CGFloat x = (180+Height_NavBar)+1.0*scrollView.contentOffset.y;
    if (x < 0) {
        x = 0;
    }
    CGFloat alpha = x/15;
    self.naView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:alpha];
}



- (void)loginIn:(id)arg{
    JUDIAN_READ_WeChatLoginController *vc = [JUDIAN_READ_WeChatLoginController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData{
    [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
        [self updateInfo];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)showLoadingView:(BOOL)isShow {
    
    if (isShow) {
        self.emptyView = [JUDIAN_READ_PayLoadView showPayLoading];
    }else{
        [self.emptyView hiddenPayLoading];
    }

}


@end
