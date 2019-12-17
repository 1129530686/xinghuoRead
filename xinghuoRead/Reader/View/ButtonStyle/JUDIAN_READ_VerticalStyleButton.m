//
//  JUDIAN_READ_Button.m
//  xinghuoRead
//
//  Created by judian on 2019/4/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_VerticalStyleButton.h"


@interface JUDIAN_READ_VerticalStyleButton ()
@property(nonatomic, assign)CGRect titleFrame;
@property(nonatomic, assign)CGRect imageFrame;
@end

@implementation JUDIAN_READ_VerticalStyleButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self configureStyle];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configureStyle];
    }
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureStyle];
    }
    return self;
}


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
    self.titleLabel.font = [UIFont systemFontOfSize:11];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width;
    return CGRectMake(titleX, _titleFrame.origin.y, titleW, _titleFrame.size.height);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = (CGRectGetWidth(contentRect) - _imageFrame.size.width) / 2;
    return CGRectMake(x, 0, _imageFrame.size.width, _imageFrame.size.height);
}

@end
