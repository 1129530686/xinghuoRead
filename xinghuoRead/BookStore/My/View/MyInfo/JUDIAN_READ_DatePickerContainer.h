//
//  JUDIAN_READ_DatePickerContainer.h
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dateChangeBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_DatePickerContainer : UIView

@property(nonatomic, copy)dateChangeBlock block;

- (void)showView;
- (void)hideView;

- (void)setDefaultDate:(NSString*)dateStr;

@end

NS_ASSUME_NONNULL_END
