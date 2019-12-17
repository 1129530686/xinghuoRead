//
//  JUDIAN_READ_VerticalAlignmentLabel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_VerticalAlignmentLabel.h"

@implementation JUDIAN_READ_VerticalAlignmentLabel


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alignmentStyle = TextInMiddle;
    }
    
    return self;
}



- (void)setAlignmentStyle:(VerticalAlignmentStyle)alignmentStyle {
    _alignmentStyle = alignmentStyle;
    [self setNeedsDisplay];
}



- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textBounds = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    switch(self.alignmentStyle) {
        case TextInTop:
            textBounds.origin.y = bounds.origin.y;
            break;
        case TextInMiddle:
            textBounds.origin.y = bounds.origin.y + (bounds.size.height - textBounds.size.height) / 2.0;
            break;
        case TextInBottom:
            textBounds.origin.y = bounds.origin.y + bounds.size.height - textBounds.size.height;
            break;
        default:
            textBounds.origin.y = bounds.origin.y + (bounds.size.height - textBounds.size.height) / 2.0;
            break;
    }
    
    return textBounds;
}


-(void)drawTextInRect:(CGRect)rect {
    CGRect actualBounds = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualBounds];
}

@end
