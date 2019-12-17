//
//  JUDIAN_READ_UITextFieldWithClearButton.m
//  xinghuoRead
//
//  Created by judian on 2019/7/25.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UITextFieldWithClearButton.h"

@implementation JUDIAN_READ_UITextFieldWithClearButton

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGFloat yPos = (bounds.size.height - 14) / 2.0f;
    return CGRectMake(self.frame.size.width - 14 , yPos + bounds.origin.y, 14, 14);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"editor_clear_tip"] forState:UIControlStateNormal];
}

@end
