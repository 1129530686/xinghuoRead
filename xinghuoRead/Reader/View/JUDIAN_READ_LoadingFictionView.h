//
//  JUDIAN_READ_LoadingFictionView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_LoadingFictionView : UIView

- (void)playAnimation:(BOOL)isPlay;
- (void)updateImageArray:(BOOL)isNight;

- (instancetype)initSquareView;

@end

NS_ASSUME_NONNULL_END
