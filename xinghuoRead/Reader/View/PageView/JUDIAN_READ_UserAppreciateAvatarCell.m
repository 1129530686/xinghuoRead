//
//  JUDIAN_READ_UserAppreciateAvatarCell.m
//  xinghuoRead
//
//  Created by judian on 2019/5/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppreciateAvatarCell.h"
#import "JUDIAN_READ_AppreciatedAvatarCell.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_CenterFlowLayout.h"
#import "JUDIAN_READ_UserAppreciatedChapterModel.h"

#define AVATER_CELL_IDENTIFIER @"avatar_cell_identifier"


@interface JUDIAN_READ_UserAppreciateAvatarCell ()
<UICollectionViewDelegate,
UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView* collectionView;
@property(nonatomic, copy)NSArray* dataArray;
@end


@implementation JUDIAN_READ_UserAppreciateAvatarCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addCollectionView];
    }
    
    return self;
}



- (void)addCollectionView {
    
    JUDIAN_READ_CenterFlowLayout *flowLayout = [[JUDIAN_READ_CenterFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:[JUDIAN_READ_CenterFlowLayout new]];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;

    [self.collectionView registerClass:[JUDIAN_READ_AppreciatedAvatarCell class] forCellWithReuseIdentifier:AVATER_CELL_IDENTIFIER];
    
    [self.contentView addSubview:self.collectionView];
    
    WeakSelf(that);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.width.equalTo(@(230));
        make.top.equalTo(that.contentView.mas_top).offset(13);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
}



#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identify = AVATER_CELL_IDENTIFIER;
    JUDIAN_READ_AppreciatedAvatarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (_dataArray.count > 0) {
        JUDIAN_READ_UserAppreciatedChapterModel* model = _dataArray[row];
        [cell setHeadImage:model.avatar];
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(26, 26);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 3;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



- (void)reloadAvatar:(NSArray*)array {
    _dataArray = array;
    [self.collectionView reloadData];
}


- (void)setViewStyle {
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.contentView.backgroundColor = [style getBgColor];
    self.collectionView.backgroundColor = [style getBgColor];
}

- (void)setDefaultStyle {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


@end
