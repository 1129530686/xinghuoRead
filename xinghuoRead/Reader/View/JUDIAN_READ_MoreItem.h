//
//  JUDIAN_READ_MoreItem.h
//  xinghuoRead
//
//  Created by judian on 2019/4/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_MoreItem : UIControl
- (instancetype)initWithTitle:(NSString*)title imageName:(NSString*)imageName bottomLine:(BOOL)bottomLine;
- (void)setViewStyle:(NSString*)imageName nightMode:(BOOL)nightMode;
@end

NS_ASSUME_NONNULL_END
