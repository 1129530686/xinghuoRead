//
//  JUDIAN_READ_UserSignatureCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserSignatureCell.h"
#import "JUDIAN_READ_ContentFeedbackEditorItem.h"


@interface JUDIAN_READ_UserSignatureCell ()
@property(nonatomic, weak)JUDIAN_READ_ContentFeedbackEditorItem* editorItem;
@end


@implementation JUDIAN_READ_UserSignatureCell

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
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB(0x66, 0x66, 0x66);
    titleLabel.text = @"我的个性签名";
    [self.contentView addSubview:titleLabel];
    
    JUDIAN_READ_ContentFeedbackEditorItem* editor = [[JUDIAN_READ_ContentFeedbackEditorItem alloc]initWithType:kUserSignatureType];
    _editorItem = editor;
    [self.contentView addSubview:editor];
    [editor updateTextFont:14];
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.contentView.mas_top).offset(14);
        make.height.equalTo(@(14));
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    [editor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(that.contentView.mas_bottom);
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
    }];
    
    [_editorItem.textView becomeFirstResponder];
}



- (void)updateTextView:(NSString*)text {
    _editorItem.textView.text = text;
    [_editorItem updateWordCount:text.length];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (NSString*)getEditorText {
    return _editorItem.textView.text;
}



@end
