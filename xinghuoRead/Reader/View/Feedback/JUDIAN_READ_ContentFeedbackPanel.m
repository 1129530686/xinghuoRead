//
//  JUDIAN_READ_ContentFeedbackPanel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentFeedbackPanel.h"
#import "JUDIAN_READ_ContentFeedbackTipItem.h"
#import "JUDIAN_READ_ContentFeedbackTitleItem.h"
#import "JUDIAN_READ_ContentFeedbackCatagoryItem.h"
#import "JUDIAN_READ_ContentFeedbackEditorItem.h"
#import "JUDIAN_READ_ContentFeedbackConfirmItem.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_UITextFieldWithClearButton.h"

#define CONTAINER_HEIGHT 383


@interface JUDIAN_READ_ContentFeedbackPanel()
@property(nonatomic, strong)UIControl* container;
@property(nonatomic, strong)JUDIAN_READ_FeedbackContactItem* contactItem;
@property(nonatomic, strong)JUDIAN_READ_ContentFeedbackCatagoryItem* catagoryItem;
@property(nonatomic, weak)JUDIAN_READ_ContentFeedbackEditorItem* editor;
@property(nonatomic, weak)UIView* maskView;
@property(nonatomic, weak)UITextField* userQQTextField;

@property(nonatomic, copy)NSString* bookName;
@property(nonatomic, copy)NSString* chapterName;

@end



@implementation JUDIAN_READ_ContentFeedbackPanel


- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [self addViews];
    }
    return self;
}



- (void)keyboardDidShow:(NSNotification *) notification{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger bottomOffset = keyboardSize.height;
    
    WeakSelf(that);
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [that.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(that.mas_bottom).offset(-bottomOffset);
        }];
        
        [that layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardDidHide:(NSNotification *) notification{
    WeakSelf(that);
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        
        [that.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(that.mas_bottom).offset(0);
        }];
        
        [that layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
    }];
}


- (void)addViews {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIControl* emptyView = [[UIControl alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:emptyView];
    

    _container = [[UIControl alloc]init];
    [_container addTarget:self action:@selector(closeKeyboard) forControlEvents:(UIControlEventTouchUpInside)];
    _container.backgroundColor = [UIColor whiteColor];
    [self addSubview:_container];
    
    WeakSelf(that);
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(bottomOffset));
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(CONTAINER_HEIGHT));
        //make.bottom.equalTo(that.mas_bottom).offset(CONTAINER_HEIGHT - bottomOffset);
        make.bottom.equalTo(that.mas_bottom).offset(0);
    }];
    
    
    JUDIAN_READ_ContentFeedbackTipItem* tipItem = [[JUDIAN_READ_ContentFeedbackTipItem alloc]init];
    [_container addSubview:tipItem];
    
    [tipItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(56));
        make.top.equalTo(that.container.mas_top);
    }];
    
    
    _contactItem = [[JUDIAN_READ_FeedbackContactItem alloc]init];
    [_contactItem addTarget:self action:@selector(closeKeyboard) forControlEvents:(UIControlEventTouchUpInside)];
    [_container addSubview:_contactItem];
    [_contactItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(38));
        make.top.equalTo(tipItem.mas_bottom);
    }];
    
    
    _catagoryItem = [[JUDIAN_READ_ContentFeedbackCatagoryItem alloc]init];
    [_catagoryItem addTarget:self action:@selector(closeKeyboard) forControlEvents:(UIControlEventTouchUpInside)];
    [_container addSubview:_catagoryItem];
    
    
    [_catagoryItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(70));
        make.top.equalTo(that.contactItem.mas_bottom).offset(20);
    }];


    JUDIAN_READ_ContentFeedbackEditorItem* editor = [[JUDIAN_READ_ContentFeedbackEditorItem alloc]initWithType:kFeedEditorType];
    _editor = editor;
    [_container addSubview:editor];
    
    [editor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left).offset(14);
        make.right.equalTo(that.container.mas_right).offset(-14);
        make.height.equalTo(@(73));
        make.top.equalTo(that.catagoryItem.mas_bottom).offset(13);
    }];
    
    
    UIView* textFieldContainer = [[UIView alloc] init];
    textFieldContainer.layer.borderColor = RGB(0xcc, 0xcc, 0xcc).CGColor;
    textFieldContainer.layer.borderWidth = 0.5;
    textFieldContainer.layer.cornerRadius = 3;
    [_container addSubview:textFieldContainer];
    
    
    UITextField* userQQTextField = [[JUDIAN_READ_UITextFieldWithClearButton alloc] init];
    _userQQTextField = userQQTextField;
    _userQQTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userQQTextField.textColor = RGB(0x33, 0x33, 0x33);
    _userQQTextField.placeholder = @"请输入您的手机/微信/QQ(非必填)";
    _userQQTextField.font = [UIFont systemFontOfSize:13];
    [_container addSubview:_userQQTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_userQQTextField];
    
    
    
    [textFieldContainer mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(that.container.mas_left).offset(14);
        make.right.equalTo(that.container.mas_right).offset(-14);
        make.height.equalTo(@(40));
        make.top.equalTo(editor.mas_bottom).offset(13);

    }];
    
    
    [userQQTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldContainer.mas_left).offset(10);
        make.right.equalTo(textFieldContainer.mas_right).offset(-10);
        make.height.equalTo(@(40));
        make.centerY.equalTo(textFieldContainer.mas_centerY);
    }];
    
    
    JUDIAN_READ_ContentFeedbackConfirmItem* confirmItem = [[JUDIAN_READ_ContentFeedbackConfirmItem alloc]init];
    confirmItem.block = ^(id  _Nonnull cmd) {

        NSString* content = that.editor.textView.text;
        if (!that.editor.textView.text) {
            content = @"";
        }

        NSString* errorCatagoryTip = [that.catagoryItem getClickedButton];
        if (errorCatagoryTip.length <= 0 && content.length <= 0) {
            [MBProgressHUD showError:@"请选择报错类型"];
            return;
        }
        
        if(that.bookName.length <= 0 || that.chapterName.length <= 0) {
            return;
        }
                
        NSString* contact = that.userQQTextField.text;
        if (contact.length <= 0) {
            contact = @"";
        }
        
        if (errorCatagoryTip.length <= 0) {
            errorCatagoryTip = @"6";
        }

        NSDictionary* dictionary =  @{
          @"cmd":cmd,
          @"type": [NSString stringWithFormat:@"%@", errorCatagoryTip],
          @"content":content,
          @"contact" : contact,
          @"bookName" : that.bookName,
          @"chapterName" :that.chapterName
          };

        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: dictionary];
    };
    
    [_container addSubview:confirmItem];
    
    [confirmItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(50));
        make.bottom.equalTo(that.container.mas_bottom);
        
    }];

}



-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;

    NSInteger limit = 40;
    NSString *toBeString = textField.text;
    if (toBeString.length - 1 > limit && toBeString.length > 1) {
        textField.text = [toBeString substringToIndex:limit];
    }
}


- (void)closeKeyboard {
    [self hideSelf];
}



- (void)addToKeyWindow:(UIView*)container {
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [container addSubview:self];
    

    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        UIView* maskView = [[UIView alloc]init];
        _maskView = maskView;
        maskView.userInteractionEnabled = NO;
        maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
        [container addSubview:maskView];
        
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(container.mas_width);
            make.height.equalTo(container.mas_height);
            make.left.equalTo(container.mas_left);
            make.bottom.equalTo(container.mas_bottom);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_container clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
}


- (void)showView {
    
    //WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        //that.container.transform = CGAffineTransformMakeTranslation(0, -CONTAINER_HEIGHT);
        
    }completion:^(BOOL finished) {
        
    }];
}



- (void)setFictionInfo:(NSString*)bookName chapterName:(NSString*)chapterName {
    _bookName = bookName;
    _chapterName = chapterName;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideSelf];
}


- (void)hideSelf {
    [_maskView removeFromSuperview];
    [self removeSelf];
}


- (void)removeSelf {
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, CONTAINER_HEIGHT);
    }completion:^(BOOL finished) {
        [that  removeFromSuperview];
    }];
}




- (void)setViewStyle {
    

}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}





@end
