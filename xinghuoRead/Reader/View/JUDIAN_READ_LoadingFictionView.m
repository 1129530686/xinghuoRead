//
//  JUDIAN_READ_LoadingFictionView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_LoadingFictionView.h"

@interface JUDIAN_READ_LoadingFictionView ()
@property(nonatomic, weak)UIImageView* lodingView;
@end


@implementation JUDIAN_READ_LoadingFictionView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        
    }
    return self;
}



- (instancetype)initSquareView {
    self = [super init];
    if (self) {
        [self addSquareViews];
        
    }
    return self;
}


- (void)addViews {
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.animationDuration = 1;
    [self addSubview:imageView];
    _lodingView = imageView;
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(@(34));
        make.centerX.equalTo(that.mas_centerX);
        make.centerY.equalTo(that.mas_centerY);
    }];

}



- (void)addSquareViews {
    
    UIView* squareView = [[UIView alloc]init];
    squareView.backgroundColor = RGBA(0x00, 0, 0, 0.5);
    squareView.layer.cornerRadius = 10;
    squareView.layer.masksToBounds = YES;
    [self addSubview:squareView];
    
    
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.animationDuration = 1;
    [self addSubview:imageView];
    _lodingView = imageView;
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50));
        make.height.equalTo(@(34));
        make.centerX.equalTo(that.mas_centerX);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
    [squareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
        make.centerX.equalTo(that.mas_centerX);
        make.centerY.equalTo(that.mas_centerY);
    }];
    
    
}




- (void)updateImageArray:(BOOL)isNight {
    
    UIImage* image = nil;
    NSArray* array = nil;
    
    if (isNight) {
        array = @[@"loading_tip_1_n",@"loading_tip_2_n",@"loading_tip_3_n",@"loading_tip_4_n",@"loading_tip_5_n"];
    }
    else {
        array = @[@"loading_tip_1",@"loading_tip_2",@"loading_tip_3",@"loading_tip_4",@"loading_tip_5"];
    }
    
    NSMutableArray* imageArray = [NSMutableArray array];
    for (NSString* element in array) {
        image = [UIImage imageNamed:element];
        [imageArray addObject:image];
    }
    
    _lodingView.animationImages = imageArray;
}


- (void)playAnimation:(BOOL)isPlay {
    if (isPlay) {
        [_lodingView startAnimating];
    }
    else {
        [_lodingView stopAnimating];
    }
}



@end
