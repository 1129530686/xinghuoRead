//
//  UIImage+JUDIAN_READ_Blur.h
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JUDIAN_READ_Blur)

+ (UIImage*)takeSnapShot:(UIView*)view;
+ (UIImage*)generateQrCode:(NSString*)content;

- (UIImage *)createCornerImage:(CGSize)size;
- (instancetype)scaleImage;
@end

NS_ASSUME_NONNULL_END
