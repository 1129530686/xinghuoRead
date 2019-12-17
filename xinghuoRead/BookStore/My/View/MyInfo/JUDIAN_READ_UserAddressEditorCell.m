//
//  JUDIAN_READ_UserAddressEditorCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAddressEditorCell.h"
#import "JUDIAN_READ_FeedbackTextView.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_UITextFieldWithClearButton.h"

@interface JUDIAN_READ_UserAddressEditorCell ()
@property(nonatomic, weak)UITextField* textField;

@end



@implementation JUDIAN_READ_UserAddressEditorCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addEditorView];
    }
    return self;
}



- (void)addEditorView {
    
    UITextField* textField = [[JUDIAN_READ_UITextFieldWithClearButton alloc] init];
    _textField = textField;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = RGB(0x33, 0x33, 0x33);
    [self.contentView addSubview:textField];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    WeakSelf(that);
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(that.contentView.mas_height);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];

}



- (void)updateCell:(NSString*)text placeholder:(NSString*)placeholder type:(NSInteger)type {
    _textField.text = text;
    _textField.attributedPlaceholder = [self createAttributedText:placeholder];
    _textField.keyboardType = type;
}

- (NSString*)getEditorText {
    return _textField.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [text length])];
    UIColor* color = RGB(0x99, 0x99, 0x99);
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    
    return attributedText;
}


@end



#pragma mark JUDIAN_READ_UserAddressChoiceCell

@interface JUDIAN_READ_UserAddressChoiceCell ()
@property(nonatomic, weak)UILabel* addressLabel;
@end


@implementation JUDIAN_READ_UserAddressChoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addEditorView];
    }
    return self;
}



- (void)addEditorView {

    UIImageView* rightArrowImageView = [[UIImageView alloc]init];
    _rightArrowImageView = rightArrowImageView;
    rightArrowImageView.image = [UIImage imageNamed:@"list_next"];
    [self.contentView addSubview:rightArrowImageView];
    
    UILabel* addressLabel = [[UILabel alloc] init];
    _addressLabel = addressLabel;
    addressLabel.textColor = RGB(0x33, 0x33, 0x33);
    addressLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:addressLabel];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    WeakSelf(that);
    
    [rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(7));
        make.height.equalTo(@(12));
        make.right.equalTo(that.contentView.mas_right).offset(-12);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(rightArrowImageView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
}



- (void)updateCell:(NSString*)text placeholder:(NSString*)placeholder {
    if (text.length > 0) {
        _addressLabel.textColor = RGB(0x33, 0x33, 0x33);
        _addressLabel.text = text;
    }
    else {
        _addressLabel.textColor =RGB(0x99, 0x99, 0x99);
        _addressLabel.text = placeholder;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end



#pragma mark JUDIAN_READ_UserAddressDetailCell

@interface JUDIAN_READ_UserAddressDetailCell ()<UITextViewDelegate>
@property(nonatomic, weak)JUDIAN_READ_FeedbackTextView* textView;
@property(nonatomic, weak)UILabel* placehodlerLabel;
@property(nonatomic, weak)UIButton* clearButton;
@end


@implementation JUDIAN_READ_UserAddressDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addEditorView];
    }
    return self;
}


- (void)addEditorView {
    
    JUDIAN_READ_FeedbackTextView* textView = [[JUDIAN_READ_FeedbackTextView alloc]init];
    _textView = textView;
    
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = RGB(0x33, 0x33, 0x33);
    textView.delegate = self;
    [textView  setTextContainerInset:UIEdgeInsetsMake(0, -2, 0, 0)];
    [self.contentView addSubview:textView];
    
    UILabel* placehodlerLabel = [[UILabel alloc]init];
    _placehodlerLabel = placehodlerLabel;
    placehodlerLabel.text = @"";
    
    
    placehodlerLabel.font = [UIFont systemFontOfSize:14];
    placehodlerLabel.textColor = RGB(0x99, 0x99, 0x99);
   
    
    [self.contentView addSubview:placehodlerLabel];
    

    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    UIButton* clearButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _clearButton = clearButton;
    [clearButton setBackgroundImage:[UIImage imageNamed:@"editor_clear_tip"] forState:(UIControlStateNormal)];
    [clearButton addTarget:self action:@selector(handleTouchEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:clearButton];

    
    WeakSelf(that);
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-28);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-10);
    }];
    
    
    [placehodlerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_top);
        make.left.equalTo(textView.mas_left).offset(0);
        make.height.equalTo(@(14));
        make.width.equalTo(@(0));
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];

    
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(14));
        make.height.equalTo(@(14));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        //make.top.equalTo(textView.mas_top).offset(4);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
}


- (NSString*)getEditorText {
    return _textView.text;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self showPlaceholder:textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger length = textView.text.length + (text.length - range.length);
    [self showPlaceholder:length];
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }

    if (length <= 60) {
        return YES;
    }
    
    return NO;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    _clearButton.hidden = YES;
}

- (void)updateCell:(NSString*)text placeholder:(NSString*)placeholder {
    _textView.text = text;
    _placehodlerLabel.text = placeholder;
    
    CGFloat placehodlerWidth = [_placehodlerLabel getTextWidth:14];
    placehodlerWidth = ceil(placehodlerWidth);
    
    [self showPlaceholder:_textView.text.length];
    
    _clearButton.hidden = YES;
    
    [_placehodlerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(placehodlerWidth));
    }];
}


- (void)showPlaceholder:(NSInteger)length {
    
    if (length <= 0) {
        _clearButton.hidden = YES;
        _placehodlerLabel.hidden = NO;
    }
    else {
        _clearButton.hidden = NO;
        _placehodlerLabel.hidden = YES;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}



- (void)handleTouchEvent {
    _textView.text = @"";
    _clearButton.hidden = YES;
}



@end


@implementation JUDIAN_READ_UserDefaultAddressSwitch


@end


#pragma mark JUDIAN_READ_UserAddressDefaultCell
@interface JUDIAN_READ_UserAddressDefaultCell ()
@property(nonatomic, weak)JUDIAN_READ_UserDefaultAddressSwitch* defaultAddress;
@end



@implementation JUDIAN_READ_UserAddressDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UILabel* defaultTipLabel = [[UILabel alloc] init];
    defaultTipLabel.text = @"设为默认地址";
    defaultTipLabel.textColor = RGB(0x33, 0x33, 0x33);
    defaultTipLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:defaultTipLabel];
    
    
    JUDIAN_READ_UserDefaultAddressSwitch* defaultAddress = [JUDIAN_READ_UserDefaultAddressSwitch buttonWithType:(UIButtonTypeCustom)];
    [defaultAddress addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _defaultAddress = defaultAddress;
    [defaultAddress setImage:[UIImage imageNamed:@"default_address_off_tip"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:defaultAddress];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    WeakSelf(that);
    [defaultAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(58));
        make.height.equalTo(@(27));
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    [defaultTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(defaultAddress.mas_left).offset(-14);
        make.height.equalTo(@(14));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
}


- (void)handleTouchEvent:(JUDIAN_READ_UserDefaultAddressSwitch*)sender {
    sender.on = !sender.on;
    [self updateSwitchImage];
}


- (void)updateCell:(BOOL)on {
    _defaultAddress.on = on;
    [self updateSwitchImage];
}

- (BOOL)getDefaultState {
    return _defaultAddress.on;
}



- (void)updateSwitchImage {
    if (_defaultAddress.on) {
        [_defaultAddress setImage:[UIImage imageNamed:@"default_address_on_tip"] forState:(UIControlStateNormal)];
    }
    else {
        [_defaultAddress setImage:[UIImage imageNamed:@"default_address_off_tip"] forState:(UIControlStateNormal)];
    }
}



@end

