//
//  JUDIAN_READ_ChildCategoryController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ChildCategoryController.h"
#import "JUDIAN_READ_CategoryModel.h"
#import "JUDIAN_READ_NorvalColCell.h"
#import "JUDIAN_READ_CategoryHeadView.h"
#import "JUDIAN_READ_BookDetailModel.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"

@interface JUDIAN_READ_ChildCategoryController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView  *resultView;
@property (nonatomic,strong) NSMutableArray  *resultArr;
@property (nonatomic,strong) NSMutableArray  *headArr;
@property (nonatomic,strong) NSString  *tag;
@property (nonatomic,strong) NSString  *status;
@property (nonatomic,strong) JUDIAN_READ_CategoryHeadView  *headView;

@end

@implementation JUDIAN_READ_ChildCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.category.name;
    [self loadData];
    [self loadHeadData];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.resultView];
}

#pragma mark 网络请求
- (void)loadHeadData{
    [JUDIAN_READ_BookMallTool getSelectConditionWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            self.headArr = result;
            if (self.isPublish) {
                self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
                self.resultView.frame = CGRectMake(0, 50, SCREEN_WIDTH, Height_Content-50);
            }else{
                self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 91);
                self.resultView.frame = CGRectMake(0, 91, SCREEN_WIDTH, Height_Content-91);
            }
            [self.headView setLeftDataWithModel:self.headArr isHiddenTop:self.isPublish];

        }
    }];
}

- (void)loadData{

    NSMutableDictionary *dic = [@{@"page":[NSString stringWithFormat:@"%ld",self.pageSize],@"cat_id":self.category.value} mutableCopy];
    
    if (self.tag.length) {
        [dic setObject:self.tag forKey:@"tag"];
    }else{
        [dic setObject:@"" forKey:@"tag"];
    }
    if (self.status.length) {
        [dic setObject:self.status forKey:@"update_status"];
    }else{
        [dic setObject:@"" forKey:@"update_status"];
    }
   
    [JUDIAN_READ_BookMallTool getSelectConditionBookWithParams:dic completionBlock:^(id result, id error) {
        [self.resultView.mj_header endRefreshing];
        [self.resultView.mj_footer endRefreshing];
        if (result) {
            CGFloat y = self.isPublish ? 50 : 91;
            self.resultView.frame = CGRectMake(0, y, SCREEN_WIDTH, Height_Content-y);
            //下拉刷新
            if (!self.isPullDown) {
                [self.resultArr removeAllObjects];
            }
            //没有更多
            if([result count] < 20){
                [self.resultView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.resultArr addObjectsFromArray:result];
        }
        self.isPullDown = NO;
        [self.resultView reloadData];
    }];
    
}

#pragma mark 懒加载
-  (JUDIAN_READ_BaseCollectionView *)resultView{
    if (!_resultView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 8);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 1.35*(SCREEN_WIDTH-30-54)/4 + 28);
        _resultView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content-91) collectionViewLayout:layout];
        _resultView.delegate = self;
        _resultView.dataSource = self;
        _resultView.backgroundColor = [UIColor whiteColor];
        _resultView.showsVerticalScrollIndicator = NO;
        [_resultView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_NorvalColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_NorvalColCell"];
        [_resultView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
        WeakSelf(weakself);
        _resultView.emptyCallBack = ^(int type){
            [weakself loadHeadData];
            weakself.pageSize = 1;
            [weakself loadData];
        };
        _resultView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.isPullDown = NO;
            weakself.pageSize = 1;
            [weakself loadData];
        }];
        _resultView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakself.isPullDown = YES;
            weakself.pageSize++;
            [weakself loadData];
        }];
    }
    return _resultView;
}

- (JUDIAN_READ_CategoryHeadView *)headView{ 
    if (!_headView) {
        _headView = [[[NSBundle mainBundle]loadNibNamed:@"JUDIAN_READ_CategoryHeadView" owner:self options:nil] lastObject];
        _headView.frame = CGRectZero;
        WeakSelf(obj);
        _headView.selectBlock = ^(id v1,id v2){
            obj.status = v1;
            obj.tag = v2;
            obj.pageSize = 1;
            obj.isPullDown = NO;
            [obj loadData];
        };
    }
    return _headView;
}

- (NSMutableArray *)resultArr{
    if (!_resultArr) {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}

#pragma mark collectionview 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.resultArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_NorvalColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_NorvalColCell" forIndexPath:indexPath];
    [cell setChildCategoryDataWithModel:self.resultArr indexPath:indexPath tag:self.tag];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:pv_app_introduce_page attributes:@{@"source":norval_category_page}];
    [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{@"source":norval_category_page}];
    
    JUDIAN_READ_BookDetailModel *info = self.resultArr[indexPath.row];
    [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:norval_category_page];
    
}



@end
