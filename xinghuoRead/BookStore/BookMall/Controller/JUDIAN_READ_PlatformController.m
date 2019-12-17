//
//  JUDIAN_READ_PlatformController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/16.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_PlatformController.h"
#import "JUDIAN_READ_TypeCell.h"
#import "JUDIAN_READ_BookLeaderboardController.h"

#define TopHeight 85
#define BotHeight 120


@interface JUDIAN_READ_PlatformController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView *colView;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UILabel  *desLab;


@end

@implementation JUDIAN_READ_PlatformController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聚合";
    [self loadData];
    [self loadDesData];
    [self.view addSubview:self.colView];
    [self.colView addSubview:self.headView];
    [self.colView addSubview:self.footView];
}
#pragma mark 网络请求
- (void)loadData{
    [JUDIAN_READ_BookMallTool getContentCompanyWithParams:@{@"pageSize":@"500"} completionBlock:^(id _Nullable result, id _Nullable error) {
        if (result) {
            self.dataArr = result;
        }
        [self.colView reloadData];

    }];
}

- (void)loadDesData{
    [JUDIAN_READ_MyTool getAboutUsWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            NSString *str = [NSString stringWithFormat:@"如果您有什么意见或建议，\n可以通过添加微信：%@，与我们联系。",result[@"wx"]];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            NSDictionary *dic = @{NSFontAttributeName:kFontSize12,NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:kColor153};
            NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:str attributes:dic];
            paraStyle.lineSpacing = 5;
            self.desLab.attributedText = attributeStr;
        }
    }];
    
}


#pragma mark 懒加载
- (JUDIAN_READ_BaseCollectionView *)colView{
    if (!_colView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //(SCREEN_WIDTH - 28 - 14)/3.0;
        CGFloat w = (SCREEN_WIDTH - 42)/3.0;
        layout.itemSize = CGSizeMake(w, w/3.24);
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, BotHeight);
        layout.minimumInteritemSpacing = 7;
        layout.minimumLineSpacing = 10;
        JUDIAN_READ_BaseCollectionView *collectView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) collectionViewLayout:layout];
        collectView.backgroundColor = kColorWhite;
        collectView.contentInset = UIEdgeInsetsMake(TopHeight, 0, 0, 0);
        collectView.delegate = self;
        collectView.dataSource = self;
        [collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_TypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"JUDIAN_READ_TypeCell"];
        [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reuse"];
        _colView = collectView;
        WeakSelf(weakself);
        collectView.emptyCallBack = ^(int type){
            weakself.pageSize = 1;
            [weakself loadData];
        };
    }
    return _colView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(15, -TopHeight, SCREEN_WIDTH-30, TopHeight)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 43)];
        [lab setText:@"追书宝" titleFontSize:19 titleColot:kColor51];
        lab.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:lab];
        
        UILabel *desLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH-30, 17)];
        desLab.textAlignment = NSTextAlignmentCenter;
        [desLab setText:@" " titleFontSize:17 titleColot:kColor51];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:@"为您聚合了150多个小说平台 内容免费看"];
        [att addAttributes:@{NSForegroundColorAttributeName:kThemeColor} range:NSMakeRange(att.length - 5, 5)];
        desLab.attributedText = att;
        [_headView addSubview:desLab];
    }
    return _headView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, BotHeight)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH-30, 14)];
        [lab setText:@"我们在持续努力为您聚合更多的小说平台…" titleFontSize:14 titleColot:kColor100];
        lab.textAlignment = NSTextAlignmentCenter;
        [_footView addSubview:lab];
        
        UIView *sepV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame)+20, SCREEN_WIDTH-30, 0.5)];
        sepV.backgroundColor = KSepColor;
        [_footView addSubview:sepV];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+CGRectGetMaxY(sepV.frame), SCREEN_WIDTH-30, 35)];
        lab1.numberOfLines = 2;
        self.desLab = lab1;
        [_footView addSubview:lab1];
    }
    return _footView;
}

#pragma mark col代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_TypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_TypeCell" forIndexPath:indexPath];
    [cell setPlatFormDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell addSubview:self.footView];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [GTCountSDK trackCountEvent:@"pv_content_provider_details" withArgs:@{@"source":@"聚合平台列表页"}];
    [MobClick event:@"pv_content_provider_details" attributes:@{@"source" : @"聚合平台列表页"}];
    
    NSNumber* editorId = self.dataArr[indexPath.row][@"id"];
    NSString* editorStr = [NSString stringWithFormat:@"%ld", (long)editorId.intValue];
    NSString* pressName = self.dataArr[indexPath.row][@"company"];
    [JUDIAN_READ_BookLeaderboardController enterLeaderboardController:self.navigationController editorid:editorStr  channel:nil pressName:pressName];

    [GTCountSDK trackCountEvent:@"pv_content__provider_details" withArgs:@{@"source":@"聚合平台列表页"}];
    [MobClick event:@"pv_content__provider_details" attributes:@{@"source":@"聚合平台列表页"}];

}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 14, 0, 14);
}


#if 0
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == 2) {
        return 26;
    }
    
    if (section == 4) {
        return 26;
    }
    
    return 0.01;
}
#endif


@end
