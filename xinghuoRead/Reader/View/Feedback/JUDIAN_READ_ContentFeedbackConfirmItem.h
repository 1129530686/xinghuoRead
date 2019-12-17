//
//  JUDIAN_READ_ContentFeedbackComfirmItem.h
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^buttonClickBlock)(id cmd);

@interface JUDIAN_READ_ContentFeedbackConfirmItem : UIView
@property(nonatomic ,copy)buttonClickBlock block;
@end

NS_ASSUME_NONNULL_END
