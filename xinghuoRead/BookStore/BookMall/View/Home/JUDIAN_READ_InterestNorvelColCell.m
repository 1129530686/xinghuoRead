//
//  JUDIAN_READ_InterestNorvelColCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_InterestNorvelColCell.h"
#import "JUDIAN_READ_ImageLabelColCell.h"
#import "JUDIAN_READ_ReadListModel.h"

@interface JUDIAN_READ_InterestNorvelColCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) JUDIAN_READ_BaseCollectionView  *colView;
@property (nonatomic,strong) UICollectionViewFlowLayout  *layout;


@end

@implementation JUDIAN_READ_InterestNorvelColCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.colView];
    }
    return self;
}


#pragma mark 懒加载
- (JUDIAN_READ_BaseCollectionView *)colView{
    if (!_colView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-30-10*4)/5, 1.5*(SCREEN_WIDTH-30-10*4)/5+40);
        self.layout = layout;
        layout.minimumInteritemSpacing = 13;
        _colView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  1.5*(SCREEN_WIDTH-30-10*4)/5+40) collectionViewLayout:layout];
        [_colView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_ImageLabelColCell class]) bundle:nil] forCellWithReuseIdentifier:@"imageLabel"];
        _colView.showsHorizontalScrollIndicator = NO;
        _colView.delegate = self;
        _colView.dataSource = self;
    }
    return _colView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ImageLabelColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageLabel" forIndexPath:indexPath];
    [cell setBookHomeLikeDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_block) {
        _block(indexPath.row);
    }
    
}


- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.colView reloadData];
}





@end
