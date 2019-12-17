//
//  JUDIAN_READ_InfoHeadReuseView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/18.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_InfoHeadReuseView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *leadBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *trailBtn;
@property (nonatomic,copy) CompletionBlock  TouchBlock;

- (void)setPersonInfoDataWithModel:(id)model section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
