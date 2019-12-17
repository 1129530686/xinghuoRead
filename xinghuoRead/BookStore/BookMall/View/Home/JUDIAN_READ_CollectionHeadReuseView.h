//
//  JDCollectionHeadReuseView.h
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CollectionHeadReuseView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *leadLab;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (nonatomic,copy) VoidBlock  refreshBlock;
@property (nonatomic,copy) VoidBlock  leadSetBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailConstant;

- (void)setHomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//首页头部试图

- (void)setV0HomeDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//首页头部试图

- (void)setSearchDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//搜索头部试图

- (void)setSearchPushDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;//搜索推荐头部试图



@end

NS_ASSUME_NONNULL_END
