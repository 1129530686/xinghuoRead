//
//  JUDIAN_READ_LoginCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/28.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_LoginCell.h"

@implementation JUDIAN_READ_LoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.inputTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.inputTF setValue:kColor153 forKeyPath:@"_placeholderLabel.textColor"];
    self.inputTF.tintColor = kColor100;
    self.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.trailBtn doBorderWidth:0 color:nil cornerRadius:3];
    [self.trailBtn setBackgroundColor:KSepColor];
    [self.trailBtn setTitleColor:kColor204 forState:UIControlStateNormal];
}
- (IBAction)trailBtnAction:(id)sender {
    if (self.getBlock) {
        WeakSelf(obj);
        self.getBlock(obj, sender);
    }
}

- (void)valueChange:(UITextField *)tf{
    if (self.tfBlock) {
        WeakSelf(obj);
        self.tfBlock(obj, tf.text);
    }
}


- (void)setKeyboardType:(UIKeyboardType)type {
    self.inputTF.keyboardType = type;
}


- (void)setDataWithIndexPath:(NSIndexPath *)indexPath model:(nonnull id)model{
    self.trailBtn.hidden = indexPath.row ? NO : YES;
    self.trailBtnWidth.constant = indexPath.row ? 93:0;
    self.inputTF.placeholder = indexPath.row ? @"验证码":@"手机号";
    self.trailConstant.constant = indexPath.row ? 123 : 15;

    if (indexPath.row == 0) {
        [self.inputTF becomeFirstResponder];
    }
    
    if ([model[@"mobile"] length] == 11) {
        self.trailBtn.userInteractionEnabled = YES;
        [self.trailBtn setBackgroundColor:RGB(255, 241, 245)];
        [self.trailBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    }else{
        self.trailBtn.userInteractionEnabled = NO;
        [self.trailBtn setBackgroundColor:KSepColor];
        [self.trailBtn setTitleColor:kColor204 forState:UIControlStateNormal];
    }
}

- (void)setChangePhoneDataWithIndexPath:(NSIndexPath *)indexPath model:(id)model placeArr:(NSArray *)places{
    self.trailBtn.hidden = indexPath.row == 2 ? NO : YES;
    self.trailBtnWidth.constant = indexPath.row == 2 ? 93:0;
    self.inputTF.placeholder = places[indexPath.row];
    self.trailConstant.constant = indexPath.row == 2 ? 123 : 15;
    
    if ([model[@"old_mobile"] length] == 11 && [model[@"mobile"] length] == 11) {
        self.trailBtn.userInteractionEnabled = YES;
        [self.trailBtn setBackgroundColor:RGB(255, 241, 245)];
        [self.trailBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    }else{
        self.trailBtn.userInteractionEnabled = NO;
        [self.trailBtn setBackgroundColor:KSepColor];
        [self.trailBtn setTitleColor:kColor204 forState:UIControlStateNormal];
    }
    
}

- (void)setMWithDrawDataWithIndexPath:(NSIndexPath *)indexPath model:(id)model placeArr:(NSArray *)places{
    self.trailBtn.hidden = YES;
    self.trailBtnWidth.constant = 0;
    self.inputTF.font = kFontSize14;
    self.inputTF.placeholder = places[indexPath.row];
    self.trailBtnSpace.constant = 0;
}

@end
