//
//  JUDIAN_READ_ShareLogo.h
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ShareLogo : UIControl
- (instancetype)initWithImage:(NSString*)imageName title:(NSString*)title height:(NSInteger)height;
- (void)setViewStyle;
@end

NS_ASSUME_NONNULL_END
