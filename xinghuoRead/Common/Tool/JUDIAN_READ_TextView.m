//
//  JUDIAN_READ_TextView.m
//
//
//  Created by apple on 2018-04-27.
//  Copyright © 2018 Hu. All rights reserved.
//

#import "JUDIAN_READ_TextView.h"

@interface JUDIAN_READ_TextView()
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation JUDIAN_READ_TextView
CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholder = @"";
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [self setPlaceholderFont:13];
        self.tintColor = kColor100;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor = kColor100;
    if (!self.placeholder) {
        _placeholder = @"";
    }
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [self setPlaceholderFont:13];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)textChanged:(NSNotification *)notification {
    if (self.placeholder.length == 0) {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if (self.text.length == 0) {
            [[self viewWithTag:999] setAlpha:1];
        }else {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)drawRect:(CGRect)rect {
    if (self.placeholder.length > 0)
    {
        UIEdgeInsets insets = self.textContainerInset;
        if (_placeHolderLabel == nil)
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left + 10, insets.top+4, self.bounds.size.width - (insets.left + insets.right + 2 * 5), 1)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            _placeHolderLabel.numberOfLines = 0;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        _placeHolderLabel.font = [UIFont systemFontOfSize:_placeholderFont];
        [_placeHolderLabel sizeToFit];
        [_placeHolderLabel setFrame:CGRectMake(insets.left+3, insets.top, self.bounds.size.width - (insets.left + insets.right + 3), CGRectGetHeight(_placeHolderLabel.frame))];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if (self.text.length == 0 && self.placeholder.length > 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)setPlaceholderFont:(NSInteger)placeholderFont{
    _placeholderFont = placeholderFont;
}

- (void)setPlaceHolderCenter:(BOOL)placeHolderCenterY{
    if (placeHolderCenterY) {
        _placeHolderLabel.centerY = self.centerY;
    }
}


@end
