//
//  JUDIAN_READ_FeedbackCatagoryButton.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FeedbackCatagoryButton.h"

@interface JUDIAN_READ_FeedbackCatagoryButton ()

@end


@implementation JUDIAN_READ_FeedbackCatagoryButton

- (void)changeButtonStyle {
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    if (_isClicked) {
        [self setBackgroundColor:RGB(0xff, 0xf1, 0xf5)];
        [self setTitleColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR forState:(UIControlStateNormal)];
    }
    else {
        [self setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
        [self setTitleColor:RGB(0x66, 0x66, 0x66) forState:(UIControlStateNormal)];
    }

}

@end
