//
//  JUDIAN_READ_BorderButton.m
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BorderButton.h"
#import "JUDIAN_READ_TextStyleManager.h"

@implementation JUDIAN_READ_BorderButton

- (void)changeButtonStyle:(BOOL)isFillet {
    NSInteger width = 1;
    if(isFillet) {
        self.layer.cornerRadius = KBackgroundCircleWidth / 2;
        
        if (_isClicked) {
            self.layer.borderWidth = width;
        }
        else {
            self.layer.borderWidth = 0;
        }

        self.layer.masksToBounds = YES;
    }
    else {
        
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = width;
    }

    if (_isClicked) {
        UIColor* color = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
        self.layer.borderColor = color.CGColor;
        [self setTitleColor:color forState:(UIControlStateNormal)];
    }
    else {
        
        BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
        if (nightMode) {
            UIColor* titleColor = RGB(0x99, 0x99, 0x99);
            self.layer.borderColor = titleColor.CGColor;
            [self setTitleColor:titleColor forState:(UIControlStateNormal)];
        }
        else {
            
            if (self.tag == kLightGrayTag) {
                self.layer.borderWidth = 1;
                self.layer.borderColor = RGB(0xdd, 0xdd, 0xdd).CGColor;
            }
            else {
                self.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
            }

            [self setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
        }
    }
}




@end
