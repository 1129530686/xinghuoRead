//
//  JUDIAN_READ_SuggestView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/25.
//  Copyright © 2019年 judian. All rights reserved.
//
#import "JUDIAN_READ_TextView.h"
#import "JUDIAN_READ_SuggestView.h"
#import "UIView+JUDIAN_READ_Frame.h"


#define VIEW_HEIGHT 326

@interface JUDIAN_READ_SuggestView ()<UITextViewDelegate>

@property (nonatomic,strong) UIView  *backView;
@property (nonatomic,strong) UILabel  *desLab;

@property (nonatomic,strong) UITextView  *textView;
@property (nonatomic,strong) JUDIAN_READ_TextView  *inputTextView;
@property (nonatomic,strong) UILabel  *countLab;
@property (nonatomic, assign) NSInteger yPos;
@end

@implementation JUDIAN_READ_SuggestView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.backView];
        [self initUI];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}



-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    self.backView.y = _yPos - kbSize.height;
}



-(void)keyboardWillHide:(NSNotification*)notification{
    self.backView.y = _yPos;
}




- (void)initUI{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setText:@"意见反馈" titleFontSize:17 titleColot:kColor51];
    [self.backView addSubview:lab];
    
    UILabel *desLab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lab.frame), SCREEN_WIDTH-30, 40)];
    desLab.numberOfLines = 0;
    NSString *str = @"欢迎您开放脑洞，提出产品的使用感受或建议，我们将 尽快处理您提交的宝贵意见~";
    NSMutableDictionary *dic = [@{NSFontAttributeName:kFontSize14,NSForegroundColorAttributeName:kColor100} mutableCopy];
    desLab.attributedText = [self changeTextToAttributeStr:dic str:str];
    self.desLab = desLab;
    [self.backView addSubview:desLab];
    
    NSString *str1 = @"追书宝QQ群：612489895\n客服微信号：zhuishubao520";
    NSMutableDictionary *dic1 = [@{NSFontAttributeName:kFontSize12,NSForegroundColorAttributeName:kColor153} mutableCopy];
    self.textView.attributedText = [self changeTextToAttributeStr:dic1 str:str1];
    [self.backView addSubview:self.textView];
    
    [self.backView addSubview:self.inputTextView];
    
    [self.backView addSubview:self.countLab];
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-18);
        make.bottom.equalTo(@(-71-BottomHeight));
    }];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(self.inputTextView.frame)+18, SCREEN_WIDTH, 50);
    [btn doBorderWidth:0.5 color:kColor204 cornerRadius:0];
    [btn setText:@"提交" titleFontSize:17 titleColot:kThemeColor];
    [btn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:btn];

}

- (void)commitAction{
    
    [self removeFromSuperview];
    
    if (self.commitBlock) {
        if (!self.inputTextView.text.length) {
            [MBProgressHUD showMessage:@"反馈意见不能为空"];
            return;
        }
        self.commitBlock(self.inputTextView.text, nil);
    }
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
}


- (NSMutableAttributedString *)changeTextToAttributeStr:(NSMutableDictionary *)dic str:(NSString *)str{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 4;
    [dic setObject:paraStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str attributes:dic];
    return  attributeStr;
}



- (UIView *)backView{
    _yPos = SCREEN_HEIGHT - VIEW_HEIGHT - BottomHeight;
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, _yPos, SCREEN_WIDTH, VIEW_HEIGHT + BottomHeight)];
        _backView.backgroundColor = kColorWhite;
    }
    return _backView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(11, CGRectGetMaxY(self.desLab.frame)+6, SCREEN_WIDTH-22, 56)];
        _textView.scrollEnabled = NO;
        _textView.editable = NO;
        
    }
    return _textView;
}


- (JUDIAN_READ_TextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[JUDIAN_READ_TextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.textView.frame), SCREEN_WIDTH-30, 100)];
        [_inputTextView doBorderWidth:0.5 color:kColor204 cornerRadius:3];
        _inputTextView.delegate = self;
        _inputTextView.placeholderFont = 12;
        _inputTextView.font = kFontSize14;
        _inputTextView.textColor = kColor51;
        _inputTextView.placeholder = @"请大胆输入您的想法，比如想要某某阅读功能，某某页面体验不好，某某功能体验不好…";
        
    }
    return _inputTextView;
}

- (UILabel *)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc]initWithFrame:CGRectZero];
        [_countLab setText:@"" titleFontSize:11 titleColot:kColor153];
    }
    return _countLab;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:199];
    }
    self.countLab.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
    
    self.countLab.hidden = textView.text.length ? NO : YES;
    
    if (self.inputBlock) {
        WeakSelf(obj);
        self.inputBlock(obj,textView.text);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




@end
