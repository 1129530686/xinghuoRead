//
//  JUDIAN_READ_TextStyleModel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/28.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TextStyleModel : NSObject<NSCoding>

//字体大小
@property(nonatomic, assign)NSInteger textSize;

//字体颜色
@property(nonatomic, assign)NSInteger textColorIndex;

//护眼模式
@property(nonatomic, assign)BOOL eyeMode;

//背景颜色
@property(nonatomic, assign)NSInteger bgColorIndex;

//亮度
@property(nonatomic, assign)CGFloat brightness;

//行间距
@property(nonatomic, assign)NSInteger LineSpacing;

//段间距
@property(nonatomic, assign)NSInteger paragraphSpacing;

//文本左右间距
@property(nonatomic, assign)NSInteger textSpacing;

//夜间模式
@property(nonatomic, assign)BOOL nightMode;

//翻页样式
@property(nonatomic, assign)NSInteger pageStyle;

- (void)initStyle;

- (void)decreaseFontSize;
- (void)increaseFontSize;

- (void)adjustSamllLineSpace;
- (void)adjustMiddleLineSpace;
- (void)adjustBigLineSpace;

- (UIColor*)getTextColor;
- (UIColor*)getBgColor;
- (BOOL)getEyeMode;


- (BOOL)isMinFontSize;
- (BOOL)isMaxFontSize;
- (NSInteger)getLineSpaceLevel;
- (NSInteger)getBgColorLevel;
- (NSInteger)getParagraphSpacing;

- (NSInteger)getChapterTitleFontSize;
- (NSInteger)getPageScrollLevel;
- (BOOL)isNightMode;
@end

NS_ASSUME_NONNULL_END
