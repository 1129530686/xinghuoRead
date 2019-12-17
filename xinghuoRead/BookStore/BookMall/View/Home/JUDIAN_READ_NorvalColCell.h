//
//  JDNorvalCell.h
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NorvalColCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *authorLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *popularLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet UIImageView *sortImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLead;

//书城首页强推数据
- (void)setPushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)setv0PushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
//搜索数据
- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

//搜索推荐
- (void)setSearchPushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

//子分类
- (void)setChildCategoryDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath tag:(NSString *)tag;



@end

NS_ASSUME_NONNULL_END
