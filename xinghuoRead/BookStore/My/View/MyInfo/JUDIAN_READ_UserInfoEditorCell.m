//
//  JUDIAN_READ_UserInfoEditorCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserInfoEditorCell.h"
#import "JUDIAN_READ_UITextFieldWithClearButton.h"

#define LIMIT_COUNT 20


@interface JUDIAN_READ_UserInfoEditorCell ()

@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UITextField* textField;
@property(nonatomic, weak)UILabel* countLabel;

@end



@implementation JUDIAN_READ_UserInfoEditorCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UILabel* titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.text = @"";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    [self.contentView addSubview:titleLabel];
    
    
    UITextField* textField = [[JUDIAN_READ_UITextFieldWithClearButton alloc] init];
    _textField = textField;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = RGB(0x33, 0x33, 0x33);
    //textField.placeholder = @"";
    [self.contentView addSubview:textField];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:lineView];
    
    
    UILabel* countLabel = [[UILabel alloc] init];
    _countLabel = countLabel;
    countLabel.font = [UIFont systemFontOfSize:11];
    countLabel.textColor = RGB(0x99, 0x99, 0x99);
    [self.contentView addSubview:countLabel];
    [self updateWordCount:0];
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.contentView.mas_top).offset(14);
        make.height.equalTo(@(14));
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(54));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(textField.mas_bottom);
    }];
    
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(11));
        make.top.equalTo(lineView.mas_bottom).offset(7);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:textField];
    
    [_textField becomeFirstResponder];
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
    UIColor* color = RGB(0xcc, 0xcc, 0xcc);
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    
    return attributedText;
}



- (void)updateInfo:(NSString*)title placeholder:(NSString*)placeholder content:(NSString*)content {
    _titleLabel.text = title;
    _textField.text = content;
    _textField.attributedPlaceholder = [self createAttributedText:placeholder];
    
    [self updateWordCount:content.length];
}



-(void)textFieldEditChanged:(NSNotification *)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > LIMIT_COUNT)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:LIMIT_COUNT];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:LIMIT_COUNT];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, LIMIT_COUNT)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    [self updateWordCount:textField.text.length];
}



- (void)updateWordCount:(NSInteger)count {
    
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)count, (long)LIMIT_COUNT];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (NSString*)getEditorText {
    return _textField.text;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
