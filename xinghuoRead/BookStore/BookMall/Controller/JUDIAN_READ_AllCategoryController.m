//
//  JUDIAN_READ_AllCategoryController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_AllCategoryController.h"
#import "JUDIAN_READ_CategoryLeftCell.h"
#import "JUDIAN_READ_ImageLabelColCell.h"
#import "JUDIAN_READ_CategoryReusableView.h"
#import "JUDIAN_READ_ChildCategoryController.h"
#import "JUDIAN_READ_ScrollHeadView.h"

@interface JUDIAN_READ_AllCategoryController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray  *leftArr;
@property (nonatomic,strong) NSMutableArray  *leafNewArr;
@property (nonatomic,strong) NSMutableDictionary  *rightDic;
@property (nonatomic,strong) JUDIAN_READ_ScrollHeadView  *headView;
@property (nonatomic,strong) NSMutableArray  *collectArr;


@end

@implementation JUDIAN_READ_AllCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    [self.view addSubview:self.headView];
    [self loadParentData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.hideBar = YES;
    [super viewWillAppear:animated];
}

//加载父分类
- (void)loadParentData{
    [JUDIAN_READ_BookMallTool getParentCategoryListWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *arr1 = [NSMutableArray array];
            for (NSDictionary *dic in result) {
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
                [arr addObject:dic1];
                [arr1 addObject:dic1[@"name"]];
            }
            self.leafNewArr = arr1;
            self.headView.titles = arr1;
            self.leftArr = arr;
            [self loadCategory];
        }
    }];
}

- (void)loadCategory{    
    int i = 0;
    for (NSDictionary *dic in self.leftArr) {
        NSDictionary *newDic = @{@"cat_id":dic[@"value"]};
        [JUDIAN_READ_BookMallTool getCategoryWithParams:newDic completionBlock:^(id result, id error) {
            if (result) {
                [self.rightDic setObject:result forKey:newDic[@"cat_id"]];
            }
            UICollectionView *view = self.collectArr[i];
            [view reloadData];
        }];
        i++;
    }
   

}

#pragma mark 懒加载
- (NSMutableDictionary *)rightDic{
    if (!_rightDic) {
        _rightDic = [NSMutableDictionary dictionary];
    }
    return _rightDic;
}


- (JUDIAN_READ_ScrollHeadView *)headView{
    if (!_headView) {
        _headView = [[JUDIAN_READ_ScrollHeadView alloc]initWithFrame:CGRectMake(0, Height_StatusBar, SCREEN_WIDTH, ScreenHeight-Height_StatusBar) titles:@[@"",@"",@"",@""] leftIcon:@"reader_left_back_tip_n"];
        _headView.selectItem = self.section;
        _headView.subViewArr = self.collectArr;
        WeakSelf(obj);
        _headView.touchBlock = ^(id btnIndex, id btnTag) {
            if ([btnIndex intValue]) {
                UICollectionView *view = obj.collectArr[[btnIndex intValue]-1];
                [view reloadData];
            }else{
                [obj.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    return _headView;
}

- (NSMutableArray *)collectArr{
    if (!_collectArr) {
        _collectArr = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.itemSize = CGSizeMake((SCREEN_WIDTH-80-32)/2.0, (SCREEN_WIDTH-80-32)/4.0 + 40);
            layout.minimumInteritemSpacing = 20;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.footerReferenceSize = CGSizeZero;
            JUDIAN_READ_BaseCollectionView *rightCollectionView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, Height_Content) collectionViewLayout:layout];
            [rightCollectionView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_ImageLabelColCell" bundle:nil] forCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell"];
            [rightCollectionView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_CategoryReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JUDIAN_READ_CategoryReusableView"];
            rightCollectionView.delegate = self;
            rightCollectionView.dataSource = self;
            rightCollectionView.backgroundColor = kColorWhite;
            rightCollectionView.showsVerticalScrollIndicator = NO;
            [_collectArr addObject:rightCollectionView];
        }
    }
    return _collectArr;
}



#pragma mark collectionview 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = [self returnArrByView:collectionView];
    return [arr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ImageLabelColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell" forIndexPath:indexPath];
    NSArray *arr = [self returnArrByView:collectionView];
    [cell setCategoryRightDataWithModel:arr indexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
  
    return UIEdgeInsetsMake(13, 40, 5, 40);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [self returnArrByView:collectionView];
    JUDIAN_READ_ChildCategoryController *vc = [JUDIAN_READ_ChildCategoryController new];
    vc.category = arr[indexPath.row];
    vc.isPublish = [collectionView isEqual:self.collectArr[2]] ? YES : NO;
    [self.navigationController pushViewController:vc animated:YES];
    
    [GTCountSDK trackCountEvent:@"click_subtype_list" withArgs:@{self.leftArr[self.section][@"name"]:[arr[indexPath.row] name]}];
    [MobClick event:@"click_subtype_list" attributes:@{self.leftArr[self.section][@"name"]:[arr[indexPath.row] name]}];

}

- (NSArray *)returnArrByView:(UICollectionView *)view{
    if ([view isEqual:self.collectArr[0]]) {
        return self.rightDic[@"17"];
    }else if ([view isEqual:self.collectArr[1]]){
        return self.rightDic[@"18"];
    }else if ([view isEqual:self.collectArr[2]]){
        return self.rightDic[@"23"];
    }else{
        return self.rightDic[@"19"];
    }
}




@end
