//
//  JUDIAN_READ_BorderButton.h
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BorderButton : UIButton
@property(nonatomic, assign)BOOL isClicked;

- (void)changeButtonStyle:(BOOL)isFillet;

@end

NS_ASSUME_NONNULL_END
