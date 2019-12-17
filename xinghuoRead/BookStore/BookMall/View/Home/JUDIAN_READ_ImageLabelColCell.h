//
//  JDImageLabelColCell.h
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ImageLabelColCell : JUDIAN_READ_BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (weak, nonatomic) IBOutlet UIImageView *freeLabel;


//书城首页分类
- (void)setTypeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

//分类
- (void)setCategoryRightDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

//vip特权
- (void)setRightDataWithModel:(id)model icons:(NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath;

//赞赏
- (void)setRewardDataWithModel:(id)model icons:(NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath;

//书架分区0
- (void)setShelfDataWithModel:(id)model icons:(nullable NSMutableArray *)icons indexPath:(NSIndexPath *)indexPath;


- (void)setBookHomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)setBookHomeLikeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
