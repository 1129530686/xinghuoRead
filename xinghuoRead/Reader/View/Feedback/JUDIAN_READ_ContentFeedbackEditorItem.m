//
//  JUDIAN_READ_ContentFeedbackEditorItem.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentFeedbackEditorItem.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_FeedbackTextView.h"


@interface JUDIAN_READ_ContentFeedbackEditorItem ()<UITextViewDelegate>
@property(nonatomic, weak)UILabel* placehodlerLabel;
@property(nonatomic, weak)UILabel* countLabel;
@property(nonatomic, assign)NSInteger wordCountLimit;
@property(nonatomic, assign)NSInteger editorType;
@end


@implementation JUDIAN_READ_ContentFeedbackEditorItem


- (instancetype)initWithType:(NSInteger)type {
    self = [super init];
    if (self) {
        _editorType = type;
        [self addViews];
    }
    return self;
}


- (void)addViews {
 
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
    self.layer.masksToBounds = YES;
    
    JUDIAN_READ_FeedbackTextView* textView = [[JUDIAN_READ_FeedbackTextView alloc]init];
    _textView = textView;
    
    textView.font = [UIFont systemFontOfSize:12];
    textView.textColor = RGB(0x33, 0x33, 0x33);
    textView.delegate = self;
    [textView  setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self addSubview:textView];
    
    UILabel* placehodlerLabel = [[UILabel alloc]init];
    _placehodlerLabel = placehodlerLabel;
    placehodlerLabel.textColor = RGB(0x99, 0x99, 0x99);
    
    UILabel* countLabel = [[UILabel alloc]init];
    _countLabel = countLabel;
    
    NSInteger fontSize = 12;
    NSInteger offset = 6;
    if (_editorType == kFeedEditorType) {
        fontSize = 13;
        _wordCountLimit = 200;
        offset = 0;
        textView.font = [UIFont systemFontOfSize:fontSize];
        [textView setTextContainerInset:UIEdgeInsetsMake(0, -6, 0, 0)];
        placehodlerLabel.textColor = RGB(0xcc, 0xcc, 0xcc);
        placehodlerLabel.text = @"请描述具体原因，我们会尽快处理";
        countLabel.hidden = YES;
    }
    else {
        fontSize = 14;
        _wordCountLimit = 140;
        placehodlerLabel.textColor = RGB(0xcc, 0xcc, 0xcc);
        placehodlerLabel.text = @"填写个性签名，更容易被别人发现哦~";
        countLabel.hidden = NO;
    }
    
    placehodlerLabel.font = [UIFont systemFontOfSize:fontSize];
    
    CGFloat placehodlerWidth = [placehodlerLabel getTextWidth:fontSize];
    
    [self addSubview:placehodlerLabel];
    
    countLabel.text = [NSString stringWithFormat:@"0/%ld", _wordCountLimit];
    countLabel.font = [UIFont systemFontOfSize:10];
    countLabel.textColor = RGB(0x99, 0x99, 0x99);
    countLabel.textAlignment = NSTextAlignmentRight;
    //CGFloat countLabelWidth = [countLabel getTextWidth:10];
    
    [self addSubview:countLabel];
    
    
    WeakSelf(that);
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.mas_top).offset(10);
        make.left.equalTo(that.mas_left).offset(10);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(60));
    }];
    
    
    [placehodlerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textView.mas_top).offset(2);
        make.left.equalTo(textView.mas_left).offset(offset);
        make.height.equalTo(@(fontSize));
        make.width.equalTo(@(placehodlerWidth));
        
    }];
    
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(that.mas_bottom).offset(-7);
        make.left.equalTo(that.mas_left).offset(10);
        make.right.equalTo(that.mas_right).offset(-10);
       // make.width.equalTo(@(countLabelWidth));
        make.height.equalTo(@(10));
    }];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSInteger length = textView.text.length + (text.length - range.length);
    if (length <= 0) {
        _placehodlerLabel.hidden = NO;
    }
    else {
        _placehodlerLabel.hidden = YES;
    }
    
    if (length <= _wordCountLimit) {
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", length, _wordCountLimit];
        return YES;
    }
    
    return  NO;


}



- (void)updateTextFont:(NSInteger)size {
    _textView.font = [UIFont systemFontOfSize:size];
}



- (void)updateWordCount:(NSInteger)length {
    
    if (length <= 0) {
        _placehodlerLabel.hidden = NO;
    }
    else {
        _placehodlerLabel.hidden = YES;
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", length, _wordCountLimit];
}



@end
