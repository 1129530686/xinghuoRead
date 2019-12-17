//
//  JUDIAN_READ_AttributedButton.h
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AttributedButton : UIButton
@property(nonatomic, assign)BOOL isClicked;
- (void)setTitleText:(NSString*)amount click:(BOOL)isClicked;
- (void)setRoundBorder;
- (BOOL)getClickedState;
- (void)clickButton;
- (void)initDefaultState;

@end

NS_ASSUME_NONNULL_END
