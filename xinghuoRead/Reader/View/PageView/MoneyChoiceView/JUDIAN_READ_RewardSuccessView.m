//
//  JUDIAN_READ_RewardSuccessView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/18.
//  Copytitle © 2019年 judian. All titles reserved.
//

#import "JUDIAN_READ_RewardSuccessView.h"
#import "JUDIAN_READ_ImageLabelColCell.h"
//#import "JUDIAN_READ_Reader_xxxxx_CommandHandler.h"


@interface JUDIAN_READ_RewardSuccessView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView  *collectView;
@property (nonatomic,strong) NSMutableArray  *titleArr;
@property (nonatomic,strong) NSMutableArray  *icons;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *footView;

@property (nonatomic,assign) BOOL  isPaySuccess;

@end

@implementation JUDIAN_READ_RewardSuccessView




- (instancetype)initWithType:(BOOL)isSuccess {
    self = [super init];
    if (self) {
        _isPaySuccess = isSuccess;
        [self initUI];
    }
    return self;
}




- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectView];

}

#pragma mark 懒加载
- (JUDIAN_READ_BaseCollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 50;
        _collectView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) collectionViewLayout:layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.contentInset = UIEdgeInsetsMake(150, 0, 160, 0);
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.showsVerticalScrollIndicator = NO;
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_ImageLabelColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell"];
        [_collectView addSubview:self.headView];
        [_collectView addSubview:self.footView];
    }
    return _collectView;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, -150, SCREEN_WIDTH, 150)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.isPaySuccess) {
            [btn setImage:[UIImage imageNamed:@"reader_appreciate_success_tip"] forState:UIControlStateNormal];
            [btn setText:@"赞赏成功" titleFontSize:20 titleColot:kColor51];
        }else{
            [btn setImage:[UIImage imageNamed:@"reader_appreciate_failure_tip"] forState:UIControlStateNormal];
            [btn setText:@"赞赏失败" titleFontSize:20 titleColot:kColor51];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        btn.userInteractionEnabled = NO;
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_headView addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
        if (self.isPaySuccess) {
            [lab setText:@"独乐乐不如众乐乐，将好文分享出去吧" titleFontSize:15 titleColot:kColor100];
        }else{
            [lab setText:@"请重新支付" titleFontSize:15 titleColot:kColor100];
        }
        lab.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:lab];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@50);
            make.centerX.equalTo(@0);
            make.width.equalTo(@SCREEN_WIDTH);
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(15);
            make.centerX.equalTo(@0);
        }];
        
        
    }
    return _headView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Content-160-150, SCREEN_WIDTH, 160)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 45);
        [btn doBorderWidth:1 color:kThemeColor cornerRadius:5];
        if (self.isPaySuccess) {
            [btn setText:@"确定" titleFontSize:18 titleColot:kThemeColor];
        }else{
            [btn setText:@"重新付款" titleFontSize:18 titleColot:kThemeColor];
        }
        [btn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        
    }
    return _footView;
}

- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"QQ好友",@"QQ空间",@"微博",@"复制粘贴",nil];
    }
    return _titleArr;
}

- (NSMutableArray *)icons{
    if (!_icons) {
        _icons = [NSMutableArray arrayWithObjects:@"weixin_logo",@"weixin_friend_logo",@"qq_logo",@"qq_zone_logo",@"weibo_logo",@"copy_link_logo",nil];
    }
    return _icons;
}



#pragma mark collecionview代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-50*2-110)/3, 75);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(0, 55, 0, 55);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ImageLabelColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell" forIndexPath:indexPath];
    if (self.isPaySuccess) {
        [cell setRewardDataWithModel:self.titleArr icons:self.icons indexPath:indexPath];
    }
    return cell;
}


#pragma mark 分享
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isPaySuccess) {
        if (_block) {
            [self removeFromSuperview];
            _block(@(indexPath.row));
        }
    }
}

#pragma mark  btn 点击事件
- (void)confirm{
    if (self.isPaySuccess) {
        [_viewController.navigationController popViewControllerAnimated:YES];
    }else{
        [self removeFromSuperview];
    }
}


@end
