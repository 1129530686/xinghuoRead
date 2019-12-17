//
//
//  Created by hu on 05/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAlertViewDelegate;

@interface JUDIAN_READ_CustomAlertView : UIView

@property (nonatomic, weak) id<CustomAlertViewDelegate> delegate;
@property (nonatomic, strong) id<CustomAlertViewDelegate> strongDelegate;

//按钮颜色，默认为主题蓝（0x5e88ff）
@property (nonatomic, strong) UIColor *leftButtonTitleColor;
@property (nonatomic, strong) UIColor *rightButtonTitleColor;
//以下属性都有默认值，特殊情况才需要设置
@property (nonatomic, strong) UIFont  *titlefontSize;
@property (nonatomic, assign) CGFloat  messageFontSize;
@property (nonatomic, assign) CGFloat  messageHeight;
@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, strong) UIColor  *messageColor;
@property (nonatomic,assign) NSTextAlignment  textAlignment;//默认message居中
@property (nonatomic,assign) CGFloat  lineHeight;//行高
@property (nonatomic,assign) CGFloat  contentHeight;



/**
 * 如果只有一个按钮，则可以设置给leftButtonTitle或rightButtonTitle
 */
+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle;

@end

@protocol CustomAlertViewDelegate <NSObject>
@optional
/**
 * index从左往右代表按钮的位置：0,1
 */
- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index;
@end
