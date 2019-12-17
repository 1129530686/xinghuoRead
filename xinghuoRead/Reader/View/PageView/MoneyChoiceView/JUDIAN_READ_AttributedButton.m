//
//  JUDIAN_READ_AttributedButton.m
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AttributedButton.h"

@interface JUDIAN_READ_AttributedButton ()

@property(nonatomic, copy)NSString* amount;
@end


@implementation JUDIAN_READ_AttributedButton

- (void)setTitleText:(NSString*)amount click:(BOOL)isClicked {
    _isClicked = isClicked;
    _amount = amount;
    
    [self setAttributedText];
}



- (void)setAttributedText {
    
    //1、3、18、50、88、188
    UIFont* amountFont = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    UIFont* yuanFont = [UIFont systemFontOfSize:12];
    
    NSString* text = [NSString stringWithFormat:@"%@元", _amount];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:amountFont range:NSMakeRange(0, _amount.length)];
    [attributedString addAttribute:NSFontAttributeName value:yuanFont range:NSMakeRange(_amount.length, 1)];
    
    if (_isClicked) {
        self.backgroundColor = RGB(0xff, 0xf1, 0xf5);
        [attributedString addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(0, text.length)];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(0x33, 0x33, 0x33) range:NSMakeRange(0, text.length)];
    }
    
    
    [self setAttributedTitle:attributedString forState:(UIControlStateNormal)];
    
}


- (void)setRoundBorder {
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = RGB(0xee, 0xee, 0xee).CGColor;
    self.layer.borderWidth = 0.5;

}


- (void)clickButton {
    _isClicked = !_isClicked;
    
    [self setAttributedText];
}



- (void)initDefaultState {
    _isClicked = FALSE;
    [self setAttributedText];
    
}

- (BOOL)getClickedState {
    return _isClicked;
}


@end
