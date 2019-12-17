//
//  JUDIAN_READ_CoinHeadFooterView.h
//  universalRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CoinHeadFooterView : UITableViewHeaderFooterView
@property (nonatomic,strong) UIButton *leadBtn;


- (void)setCoinDataWithModel:(id )model;//金币明细

@end

NS_ASSUME_NONNULL_END
