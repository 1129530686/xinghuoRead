//
//  JUDIAN_READ_HorizontalStyleButton.h
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_HorizontalStyleButton : UIButton
@property(nonatomic, assign)BOOL isClicked;
- (instancetype)initWithTitle:(CGRect)frame imageFrame:(CGRect)imageFrame;
@end

NS_ASSUME_NONNULL_END
