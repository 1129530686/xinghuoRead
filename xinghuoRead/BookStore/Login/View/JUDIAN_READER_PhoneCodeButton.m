//
//  PhoneCodeButton.m
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "JUDIAN_READER_PhoneCodeButton.h"

@interface JUDIAN_READER_PhoneCodeButton ()
@property (assign, nonatomic) NSTimeInterval durationToValidity;

@end

@implementation JUDIAN_READER_PhoneCodeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:kThemeColor forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = kThemeColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.enabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:kThemeColor forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = kThemeColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.enabled = YES;
    }
    
    return self;
    
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];

    [self setTitleColor:kThemeColor forState:UIControlStateNormal];
    [self setBackgroundColor:RGB(255, 241, 245)];
    
    if (enabled) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)startUpTimer{
    _durationToValidity = 60;
    
    if (self.isEnabled) {
        self.enabled = NO;
    }
    
    [self setTitle:[NSString stringWithFormat:@"%.0fs 后重试", _durationToValidity] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:KSepColor];
    [self setTitleColor:kColor204 forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    if (!self.isEnabled) {
        self.enabled = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%.0fs 后重试", _durationToValidity];//防止 button_title 闪烁
        [self setTitle:[NSString stringWithFormat:@"%.0fs 后重试", _durationToValidity] forState:UIControlStateNormal];
    }else{
        
        [self invalidateTimer];
    }
}

@end
