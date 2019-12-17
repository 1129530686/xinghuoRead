//
//  JUDIAN_READ_PointsSegmentView.m
//  xinghuoRead
//
//  Created by judian on 2019/6/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PointsSegmentView.h"

@interface JUDIAN_READ_PointsSegmentView ()
@property(nonatomic,weak)UILabel* dayLabel;
@property(nonatomic,weak)UIImageView* pointsImageView;
@property(nonatomic,weak)UIImageView* ignotsImageView;
@property(nonatomic,weak)UILabel* countLabel;
@end



@implementation JUDIAN_READ_PointsSegmentView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    UIImageView* imageView = [[UIImageView alloc]init];
    _pointsImageView = imageView;
    [self addSubview:imageView];
    
    
    UILabel* dayLabel = [[UILabel alloc]init];
    _dayLabel = dayLabel;
    dayLabel.text = @"";
    dayLabel.font = [UIFont systemFontOfSize:12];
    dayLabel.textColor = RGB(0x99, 0x99, 0x99);
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dayLabel];
    
    
    UIImageView* ignotsImageView = [[UIImageView alloc] init];
    _ignotsImageView = ignotsImageView;
    ignotsImageView.image = [UIImage imageNamed:@"ingots_received_middle_tip"];
    [self addSubview:ignotsImageView];
    

    UILabel* countLabel = [[UILabel alloc] init];
    _countLabel = countLabel;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textColor = RGB(0xff, 0xa0, 0x30);
    [self addSubview:countLabel];

    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(POINTS_BG_WIDTH));
        make.top.equalTo(that.mas_top);
        make.left.equalTo(that.mas_left);
    }];
    
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(7);
        make.height.equalTo(@(12));
        make.centerX.equalTo(imageView.mas_centerX);
        make.width.equalTo(@(40));
    }];
    
    
    [ignotsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(24));
        make.height.equalTo(@(12));
        make.centerX.equalTo(imageView.mas_centerX).offset(-1);
        make.bottom.equalTo(imageView.mas_bottom).offset(-6);
    }];
    
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left);
        make.right.equalTo(imageView.mas_right);
        make.height.equalTo(@(11));
        make.bottom.equalTo(ignotsImageView.mas_top).offset(-2);
    }];

}




- (void)updatePoints:(NSInteger)whichDay count:(NSString*)count checkIn:(BOOL)checkIn {
    
    NSString* imageName = @"";
    NSString* dayText = @"";
    
    UIColor* textColor = nil;
    NSString* receiveStateImage = @"";
    if (checkIn) {
        textColor = RGB(0xff, 0xa0, 0x30);
        imageName = @"received_gold_day_bg";
        receiveStateImage = @"ingots_received_middle_tip";
    }
    else {
        textColor = RGB(0x99, 0x99, 0x99);
        imageName = @"unreceive_gold_day_bg";
        receiveStateImage = @"ingots_unreceive_middle_tip";
    }
    
    dayText = [NSString stringWithFormat:@"%ld天", (long)whichDay];
    
    _pointsImageView.image = [UIImage imageNamed:imageName];
    _dayLabel.text = dayText;
    _dayLabel.textColor = textColor;
    
    _countLabel.text = [NSString stringWithFormat:@"+%@", count];
    _countLabel.textColor = textColor;
    
    _ignotsImageView.image = [UIImage imageNamed:receiveStateImage];
}




@end
