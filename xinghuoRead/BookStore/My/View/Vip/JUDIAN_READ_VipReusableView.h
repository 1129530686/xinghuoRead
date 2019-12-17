//
//  JUDIAN_READ_VipReusableView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/1.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_VipReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *leadbtn;
@property (weak, nonatomic) IBOutlet UILabel *centerLab;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (nonatomic,copy) VoidBlock  refreshBlock;
@property (nonatomic,copy) VoidBlock  leadSetBlock;


- (void)setVipDataWithModel:(nullable id)model indexPath:(NSIndexPath *)indexPath;//会员中心头部试图
- (void)setVipSetDataWithModel:(nullable id)model indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
