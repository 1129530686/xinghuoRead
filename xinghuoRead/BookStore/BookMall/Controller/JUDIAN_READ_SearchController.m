//
//  JUDIAN_READ_SearchViewController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SearchController.h"
#import "JUDIAN_READ_BaseTextFiled.h"
#import "JUDIAN_READ_CollectionHeadReuseView.h"
#import "JUDIAN_READ_SearchColCell.h"
#import "JUDIAN_READ_FastSearchCell.h"
#import "JUDIAN_READ_NorvalColCell.h"
#import "JUDIAN_READ_FastSearchModel.h"
#import "JUDIAN_READ_CustomAlertView.h"
//#import "IQKeyboardManager.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_BookDetailModel.h"
#import "JUDIAN_READ_NoResultCell.h"
#import "JUDIAN_READ_LoadBookController.h"



@interface JUDIAN_READ_SearchController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CustomAlertViewDelegate>

@property (nonatomic,strong) JUDIAN_READ_BaseTextFiled  *mySearchBar;
@property (nonatomic,strong) NSMutableArray  *headTitleArr;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) NSMutableArray  *hotArr;
@property (nonatomic,strong) NSMutableArray  *historyArr;
@property (nonatomic,strong) NSMutableArray  *fastResultArr;
@property (nonatomic,strong) NSMutableArray  *resultArr;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UITableView  *fastResultView;
@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView  *collectView;
@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView  *resultView;
@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView  *pushTableView;
@property (nonatomic,strong) NSString  *searchType;
@property (nonatomic,strong) NSMutableArray  *pushArr;
@property (nonatomic,strong) UIView  *pushHeadView;
@property (nonatomic,strong) NSString  *searchStr;


@end

@implementation JUDIAN_READ_SearchController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mySearchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AdjustsScrollViewInsetNever(self,self.collectView);
    [self.view addSubview:self.collectView];
    [self loadData:YES];
    [self addItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}



- (void)addItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-80, 33)];
    [view addSubview:self.mySearchBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(searchCancel)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 网络请求
//热门书籍
- (void)loadData:(BOOL)isHotSearch{
    NSMutableDictionary *dic = [@{@"isHotSearch":[NSString stringWithFormat:@"%d",isHotSearch]} mutableCopy];
    if (self.resultArr.count) {
        NSMutableArray *arr = [NSMutableArray array];
        for (JUDIAN_READ_BookDetailModel *info in self.resultArr) {
            [arr addObject:info.nid];
        }
        NSString *str = [arr componentsJoinedByString:@","];
        [dic setObject:str forKey:@"searchedBookIds"];
    }
    [JUDIAN_READ_BookMallTool getHotBookListWithParams:dic completionBlock:^(id result, id error) {
        if (result) {
            self.hotArr = result;
            if (self.pushTableView.window) {
                if (self.pushArr.count) {
                    [self.pushArr removeAllObjects];
                }
                [self.pushArr addObject:self.resultArr];
                [self.pushArr addObject:self.hotArr];
                [self.pushTableView reloadData];
            }
            
            [self.dataArr removeObjectAtIndex:0];
            [self.dataArr insertObject:self.hotArr atIndex:0];
        }
        if (self.collectView.window) {
            [self.collectView reloadData];
        }
    }];
}

//搜索结果
- (void)search{
    [MobClick event:click_search attributes:@{click_search:click_search}];
    [self.mySearchBar resignFirstResponder];
    [self.collectView removeFromSuperview];
    [self.fastResultView removeFromSuperview];
    if (!self.mySearchBar.text.length) {
        return;
    }
    if (!self.isPullDown) {
        self.pageSize = 1;
    }
    NSMutableDictionary *dic = [@{@"keywords":self.searchStr,@"page":[NSString stringWithFormat:@"%ld",self.pageSize],@"pageSize":@"20"}mutableCopy];
    if (self.searchType.length) {
        [dic setObject:self.searchType forKey:@"ktype"];
    }
   
    [JUDIAN_READ_BookMallTool getSearchBookListWithParams:dic completionBlock:^(id result, id error) {
        [self.resultView.mj_footer endRefreshing];
        if (result) {
            //下拉刷新
            if (!self.isPullDown) {
                [self.resultArr removeAllObjects];
            }
            //没有更多
            if([result count] < 20){
                [self.resultView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.resultArr addObjectsFromArray:result];
            
            //如果是下拉刷新
            if (!self.isPullDown && [result count] < 10) {
                [self loadData:NO];
                [self.resultView removeFromSuperview];
                [self.view addSubview:self.pushTableView];
            }else{
                [self.view addSubview:self.resultView];
                [self.resultView reloadData];
                [self.pushTableView removeFromSuperview];
            }
            if (![result count]) {
                [GTCountSDK trackCountEvent:click_search withArgs:@{@"type":@"有结果"}];
                [MobClick event:@"click_search" attributes:@{@"type" : @"有结果"}];

            }else{
                [GTCountSDK trackCountEvent:click_search withArgs:@{@"type":@"无结果"}];
                [MobClick event:@"click_search" attributes:@{@"type" : @"无结果"}];

            }
            
        }
        self.isPullDown = NO;

    }];
}

//快速搜索
- (void)fastSearch{
    [self.pushArr removeAllObjects];
//    [self.pushTableView reloadData];
    if (self.mySearchBar.text.length) {
        [self.resultView removeFromSuperview];
        [self.pushTableView removeFromSuperview];
        [self.collectView removeFromSuperview];
        [self.view addSubview:self.fastResultView];
    }else{
        [self.resultView removeFromSuperview];
        [self.pushTableView removeFromSuperview];
        [self.fastResultView removeFromSuperview];
        [self.view addSubview:self.collectView];
        [self.collectView reloadData];
    }

    if (!self.mySearchBar.text.length) {
        return;
    }
    NSDictionary *dic = @{@"keywords":self.mySearchBar.text};
    [JUDIAN_READ_BookMallTool getFastSearchBookListWithParams:dic completionBlock:^(id result, id error) {
        if (result) {
            self.fastResultArr = result;
        }
        [self.fastResultView reloadData];
    }];
    
}

#pragma mark textfield 代理
- (void)valueChange:(UITextField *)tf{
    UITextRange *rang = tf.markedTextRange; // 获取非=选中状态文字范围
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        [self fastSearch];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length]) {
        [self save:textField.text];
        [self.view addSubview:self.collectView];
        [self.fastResultView removeFromSuperview];
        self.searchType = @"";
        self.searchStr = textField.text;
        [self search];
        return YES;
    }
    return NO;
}


#pragma collectionview代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([collectionView isEqual:self.resultView]) {
        return 1;
    }
    if ([collectionView isEqual:self.pushTableView]) {
        return self.pushArr.count;
    }
    if (self.historyArr.count) {
        return 2;
    }else{
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([collectionView isEqual:self.resultView]) {
        return self.resultArr.count;
    }
    if ([collectionView isEqual:self.pushTableView]) {
        if ([self.pushArr[0] count] == 0 && section == 0) {
            return 1;
        }
        return [self.pushArr[section] count];
    }
    
    if (section == 0 && [self.dataArr[section] count] >= 6) {
        return 6;
    }
    return [self.dataArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.resultView]) {
        JUDIAN_READ_NorvalColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_NorvalColCell" forIndexPath:indexPath];
        [cell setSearchDataWithModel:self.resultArr indexPath:indexPath];
        return cell;
    }
    if ([collectionView isEqual:self.pushTableView]) {
        if (!indexPath.section && ![self.pushArr[indexPath.section] count]) {
            JUDIAN_READ_NoResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_NoResultCell" forIndexPath:indexPath];
            [cell setModel:self.mySearchBar.text];
            WeakSelf(obj);
            cell.LoadBookBlock = ^{
                JUDIAN_READ_LoadBookController *vc = [JUDIAN_READ_LoadBookController new];
                vc.searchTitle = self.searchStr;
                [obj.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
        JUDIAN_READ_NorvalColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pushReuse" forIndexPath:indexPath];
        [cell setSearchPushDataWithModel:self.pushArr indexPath:indexPath];
        return cell;
    }
    JUDIAN_READ_SearchColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_SearchColCell" forIndexPath:indexPath];
    [cell setSearchDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.pushTableView]) {
        if ([self.pushArr[0] count]==0 && indexPath.section == 0) {
            return CGSizeMake(SCREEN_WIDTH, 226);
        }else{
            return CGSizeMake(SCREEN_WIDTH, 1.35*(SCREEN_WIDTH-30-54)/4+25);
        }
    }
    
    if ([collectionView isEqual:self.resultView]) {
        return CGSizeMake(SCREEN_WIDTH, 1.35*(SCREEN_WIDTH-30-54)/4+25);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH-30, 30);
    }else{
        return CGSizeMake((SCREEN_WIDTH-50)/2, 30);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([collectionView isEqual:self.resultView]) {
        return CGSizeZero;
    }
    if ([collectionView isEqual:self.pushTableView]) {
        return self.resultArr.count && !section ? CGSizeMake(SCREEN_WIDTH, 10) : CGSizeZero;
    }
    return section == 0 ? CGSizeMake(SCREEN_WIDTH-30, 30) : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([collectionView isEqual:self.resultView]) {
        return CGSizeZero;
    }
    if ([collectionView isEqual:self.pushTableView]) {
//        return section == 0 || !self.resultArr.count ? CGSizeZero : CGSizeMake(SCREEN_WIDTH, 54);
        return section == 0 ? CGSizeZero : CGSizeMake(SCREEN_WIDTH, 54);
    }
    return CGSizeMake(SCREEN_WIDTH, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.pushTableView]) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            JUDIAN_READ_CollectionHeadReuseView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pushReuse" forIndexPath:indexPath];
            [view setSearchPushDataWithModel:[NSNull null] indexPath:indexPath];
            return view;
        }else{
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse" forIndexPath:indexPath];
            view.backgroundColor = KSepColor;
            return view;
        }
    }
    
    //尾部
    if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse" forIndexPath:indexPath];
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 0.5)];
        [view addSubview:sepView];
        sepView.backgroundColor = [self.dataArr.lastObject count] ? kBackColor : kColorWhite;
        return view;
    }
    //头部
    JUDIAN_READ_CollectionHeadReuseView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReuse" forIndexPath:indexPath];
    WeakSelf(obj);
    view.refreshBlock = ^{
        if (indexPath.section == 0) {
            [MobClick event:click_change_refresh attributes:@{source_record:hot_search}];
            [GTCountSDK trackCountEvent:click_change_refresh withArgs:@{source_record:hot_search}];
            [obj loadData:YES];
            if (obj.collectView.numberOfSections >= 1) {
                [obj.collectView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
        }else{
//            [obj.collectView reloadSections:[NSIndexSet indexSetWithIndex:1]];
            [obj.mySearchBar endEditing:YES];
            JUDIAN_READ_CustomAlertView *alertV = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:nil message:@"确定要清空历史记录吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
            alertV.delegate = obj;
        }
    };
    [view setSearchDataWithModel:self.headTitleArr indexPath:indexPath];
    return view;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.resultView]) {
        
        if (indexPath.row >= self.resultArr.count) {
            return;
        }
        
        JUDIAN_READ_ReadListModel *info = self.resultArr[indexPath.row];
        
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:search_result_page];
        
        [MobClick event:pv_app_introduce_page attributes:@{source_record:search_result_page}];
        [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{source_record:search_result_page}];

    }else if ([collectionView isEqual:self.pushTableView]){
        
        if (indexPath.section >= self.pushArr.count) {
            return;
        }
        
        NSArray* subArray = self.pushArr[indexPath.section];
        if (indexPath.row >= subArray.count) {
            return;
        }
        
        JUDIAN_READ_ReadListModel *info = self.pushArr[indexPath.section][indexPath.row];

        NSString* source = ((indexPath.section == 1) ? search_null_page : search_result_page);

        [MobClick event:pv_app_introduce_page attributes:@{source_record : source}];
        [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{source_record : source}];
        
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:source];

    }else{
        if (indexPath.section == 0) {
            [MobClick event:pv_app_introduce_page attributes:@{source_record:hot_search_page}];
            [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{source_record:hot_search_page}];

            if (indexPath.section >= self.dataArr.count) {
                return;
            }
            
            NSArray *arr = self.dataArr[indexPath.section];
            
            if (indexPath.row >= arr.count) {
                return;
            }
            
            JUDIAN_READ_ReadListModel *info = arr[indexPath.row];
            
            [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:hot_search_page];

        }else{
            
            [MobClick event:pv_app_introduce_page attributes:@{source_record:search_history_page}];
            [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{source_record:search_history_page}];

            if (indexPath.section >= self.dataArr.count) {
                return;
            }
            
            NSArray *arr = self.dataArr[indexPath.section];
            NSString *str = indexPath.section == 0 ? [arr[indexPath.row] title] : arr[indexPath.row];
            self.mySearchBar.text = [str stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
            self.searchStr = str;
            [self search];
        }
       
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([collectionView isEqual:self.resultView]) {
        return UIEdgeInsetsMake(0, 15, 0, 15);
    }
    if ([collectionView isEqual:self.pushTableView]) {
        
        
        int y = section == 0 && [self.pushArr[section] count] ? 13 : 0;
        return UIEdgeInsetsMake(y, 15, 0, 15);
        
    }
    return UIEdgeInsetsMake(0, 15, 15, 15);
}



//存储搜索记录
- (void)save:(NSString *)record{
    if (!record.length) {
        return;
    }
    
    if(![self.historyArr containsObject:record]){
        [self.historyArr insertObject:record atIndex:0];
        if(self.historyArr.count > 8){
            [self.historyArr removeLastObject];
        }
        
        [NSUserDefaults saveUserDefaults:@"searchRecord" value:self.historyArr];
    }
}


#pragma mark  懒加载
-  (JUDIAN_READ_BaseCollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) collectionViewLayout:layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.alwaysBounceVertical = YES;
        _collectView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.showsVerticalScrollIndicator = NO;
        [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse"];
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_CollectionHeadReuseView class]) bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReuse"];
        [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_SearchColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_SearchColCell"];
        
        WeakSelf(obj);
        _collectView.emptyCallBack = ^(int type){
            obj.pageSize = 1;
            [obj loadData:YES];
        };

        
    }
    return _collectView;
}


- (void) hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


-  (JUDIAN_READ_BaseCollectionView *)resultView{
    if (!_resultView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _resultView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) collectionViewLayout:layout];
        _resultView.delegate = self;
        _resultView.dataSource = self;
        _resultView.backgroundColor = [UIColor whiteColor];
        _resultView.showsVerticalScrollIndicator = NO;
        _resultView.contentInset = UIEdgeInsetsMake(13, 0, 0, 0);
        [_resultView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_NorvalColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_NorvalColCell"];

        WeakSelf(weakself);
        _resultView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakself.isPullDown = YES;
            weakself.pageSize++;
            [weakself search];
        }];
    }
    return _resultView;
}

- (JUDIAN_READ_BaseTextFiled *)mySearchBar{
    if (!_mySearchBar) {
        _mySearchBar = [[JUDIAN_READ_BaseTextFiled alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80, 33) placeHolder:@"请输入书名、作者" textFont:[UIFont systemFontOfSize:13] searchImage:nil];
        [_mySearchBar addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
        _mySearchBar.paddingLeft = 12;
        _mySearchBar.textColor = kColor51;
        _mySearchBar.returnKeyType = UIReturnKeySearch;
        [_mySearchBar doBorderWidth:0 color:nil cornerRadius:3];
        _mySearchBar.backgroundColor = kBackColor;
        _mySearchBar.delegate = self;
    }
    return _mySearchBar;
}

- (UITableView *)fastResultView{
    if (!_fastResultView) {
        _fastResultView = [[UITableView alloc]initWithFrame:ViewFrame style:UITableViewStylePlain];
        _fastResultView.delegate = self;
        _fastResultView.dataSource = self;
        _fastResultView.separatorStyle = UITableViewCellSelectionStyleNone;
        _fastResultView.rowHeight = 47;
        [_fastResultView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_FastSearchCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_FastSearchCell"];
        [_fastResultView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_FastSearchCell" bundle:nil] forCellReuseIdentifier:@"fastResultView"];
    }
    return _fastResultView;
}


- (JUDIAN_READ_BaseCollectionView *)pushTableView{
    if (!_pushTableView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pushTableView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content) collectionViewLayout:layout];
        _pushTableView.delegate = self;
        _pushTableView.dataSource = self;
        _pushTableView.backgroundColor = [UIColor whiteColor];
        _pushTableView.showsVerticalScrollIndicator = NO;
        [_pushTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_CollectionHeadReuseView class]) bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pushReuse"];
        [_pushTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_NorvalColCell class]) bundle:nil]  forCellWithReuseIdentifier:@"pushReuse"];
        [_pushTableView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse"];
        [_pushTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_NoResultCell class]) bundle:nil]  forCellWithReuseIdentifier:@"JUDIAN_READ_NoResultCell"];
        
    }
    return _pushTableView;
}

- (UIView *)pushHeadView{
    if (!_pushHeadView) {
        _pushHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, -267, SCREEN_WIDTH, 280)];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-118)/2, 55, 118, 120)];
        imgV.image = [UIImage imageNamed:@"default_search"];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 185, SCREEN_WIDTH, 15)];
        [lab setText:@"没有找到相关内容" titleFontSize:14 titleColot:kColor153];
        lab.textAlignment = NSTextAlignmentCenter;
        [_pushHeadView addSubview:imgV];
        [_pushHeadView addSubview:lab];
    }
    return _pushHeadView;
}



- (NSMutableArray *)headTitleArr{
    if (!_headTitleArr) {
        _headTitleArr = [NSMutableArray arrayWithObjects:@"热门搜索",@"搜索历史",nil];
    }
    return _headTitleArr;
}

- (NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

- (NSMutableArray *)historyArr{
    if (!_historyArr) {
        NSMutableArray *arr = [NSUserDefaults getUserDefaults:@"searchRecord"];
        _historyArr = [NSMutableArray array];
        [_historyArr addObjectsFromArray:arr];
    }
    return _historyArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:self.hotArr];
        [_dataArr addObject:self.historyArr];
    }
    return _dataArr;
}

- (NSMutableArray *)resultArr{
    if (!_resultArr) {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}

- (NSMutableArray *)pushArr{
    if (!_pushArr) {
        _pushArr = [NSMutableArray array];
    }
    return _pushArr;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _headView.backgroundColor = kBackColor;
    }
    return _headView;
}

- (void)searchCancel{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fastResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_FastSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_FastSearchCell" forIndexPath:indexPath];
    [cell setSearchDataWithModel:self.fastResultArr indexPath:indexPath keyWords:self.mySearchBar.text];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_FastSearchModel *model = self.fastResultArr[indexPath.row];
    self.searchType = model.ktype;
    self.mySearchBar.text = [model.title stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    [self save:model.title];
    self.searchStr = model.title;
    [self search];
}


- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index{
    if (index == 1) {
        [self.historyArr removeAllObjects];
        [NSUserDefaults removeUserDefaults:@"searchRecord"];
        [self.collectView reloadData];
    }
}


- (void)keyboardWillAppear:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    //获取键盘的frame
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //设置tableview的contentInset属性，改变tableview的显示范围
    WeakSelf(obj);
    obj.collectView.contentInset = UIEdgeInsetsMake(20, 0, keyboardFrame.size.height, 0);
    obj.collectView.scrollEnabled = YES;

}

- (void)keyboardWillBeHidden:(NSNotification *)noti {
    self.collectView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 键盘回收
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
#if 0
    if ([scrollView isEqual:self.resultView] && scrollView.contentOffset.y > 0) {
        [self.mySearchBar resignFirstResponder];
    }
    if ([scrollView isEqual:self.fastResultView] && scrollView.contentOffset.y > 0) {
        [self.mySearchBar resignFirstResponder];
    }
#endif
    if (scrollView.contentOffset.y > 0) {
        [self.mySearchBar resignFirstResponder];
    }
}




@end
