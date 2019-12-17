//
//  JUDIAN_READ_ShelfTopView.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/14.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseView.h"

//NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ShelfTopView : JUDIAN_READ_BaseView

@property (nonatomic,copy) VoidBlock  touchBlock;
//设置底部文字颜色 默认51
@property (nonatomic,strong) UIColor  *bottomTextColor;
//设置底部文字大小 默认12
@property (nonatomic,strong) UIFont  *bottomTextFont;
//设置头部图片
@property (nonatomic,strong) NSString  *imgName;
//设置底部文字
@property (nonatomic,strong) NSString  *title;



- (instancetype)initWithFrame:(CGRect)frame imagesName:(NSString *)imagesName title:(NSString *)title;

//将顶部图片替换成文字
- (void)setTopTitle:(NSString *)topTitle;

//设置内部视图frame
- (void)changeTopViewFrame:(CGRect)frame bottomFrame:(CGRect)frame1;

@end

//NS_ASSUME_NONNULL_END
