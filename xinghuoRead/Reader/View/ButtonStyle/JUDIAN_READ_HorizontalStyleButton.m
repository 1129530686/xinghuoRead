//
//  JUDIAN_READ_HorizontalStyleButton.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_HorizontalStyleButton.h"


@interface JUDIAN_READ_HorizontalStyleButton ()
@property(nonatomic, assign)CGRect titleFrame;
@property(nonatomic, assign)CGRect imageFrame;
@end






@implementation JUDIAN_READ_HorizontalStyleButton


- (instancetype)initWithTitle:(CGRect)frame imageFrame:(CGRect)imageFrame {
    
    self = [super init];
    if (self) {
        
        _titleFrame = frame;
        _imageFrame = imageFrame;
        
        [self configureStyle];
    }
    
    return self;
}



-(void)configureStyle{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}




-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = contentRect.size.width - _titleFrame.size.width;
    CGFloat titleW = _titleFrame.size.width;
    CGFloat titleY = (contentRect.size.height - _titleFrame.size.height) / 2;
    
    return CGRectMake(titleX, titleY, titleW, _titleFrame.size.height);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = _imageFrame.origin.x;
    CGFloat y = (contentRect.size.height - _imageFrame.size.height) / 2;
    
    return CGRectMake(x, y, _imageFrame.size.width, _imageFrame.size.height);
}


@end
