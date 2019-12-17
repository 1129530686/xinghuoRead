//
//  UIImage+JUDIAN_READ_Blur.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "UIImage+JUDIAN_READ_Blur.h"
#import <CoreImage/CoreImage.h>

#define kDefaultWidth 300.0f

@implementation UIImage (JUDIAN_READ_Blur)



- (UIImage *)createCornerImage:(CGSize)size {

    CGPathRef pathRef = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.size.width, self.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:size].CGPath;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), pathRef);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect bound = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(bound.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, bound);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (instancetype)scaleImage {
    if (self.size.width < kDefaultWidth) {
        return self;
    }
    //计算缩放的高
    CGFloat newHeight = kDefaultWidth * self.size.height / self.size.width;
    CGSize newSize = CGSizeMake(kDefaultWidth, newHeight);
    //开启上下文绘制
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



+ (UIImage*)takeSnapShot:(UIView*)view {
    CGSize size = CGSizeMake(view.frame.size.width, view.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage*)generateQrCode:(NSString*)content {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(5.0f, 5.0f);
    CIImage *output = [image imageByApplyingTransform: transform];
    UIImage *newImage = [UIImage imageWithCIImage:output scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    return newImage;
}




@end
