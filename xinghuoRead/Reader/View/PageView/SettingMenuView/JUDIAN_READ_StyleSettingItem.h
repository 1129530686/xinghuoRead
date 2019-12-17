//
//  JUDIAN_READ_StyleSettingItem.h
//  xinghuoRead
//
//  Created by judian on 2019/5/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_StyleSettingItem : UIControl
- (instancetype)initWithImage:(NSString*)imageName title:(NSString*)title;
- (void)updateMargin:(CGFloat)imageTop textTop:(CGFloat)textTop;
- (void)setViewStyle:(NSString*)imageName;
@end

NS_ASSUME_NONNULL_END
