//
//  JUDIAN_READ_NovelBottomBar.h
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^touchEventBlock)(_Nonnull id sender);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelBottomBar : UIView
@property(nonatomic, copy)touchEventBlock block;

- (void)setCacheText:(NSString*)text;
- (void)enableCachedButton:(BOOL)isCached;
- (BOOL)isButtonEnable;
- (void)updateFavouriteName:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
