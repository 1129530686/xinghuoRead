//
//  JUDIAN_READ_CategoryReusableView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CategoryReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *centerLab;

//分类头部视图
- (void)setCategoryRightDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
