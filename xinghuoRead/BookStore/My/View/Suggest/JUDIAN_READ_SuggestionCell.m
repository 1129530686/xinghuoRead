//
//  JUDIAN_READ_SuggestionCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SuggestionCell.h"

@interface JUDIAN_READ_SuggestionCell ()<UITextViewDelegate>

@end

@implementation JUDIAN_READ_SuggestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bottomTextView doBorderWidth:0.5 color:kColor204 cornerRadius:3];
    self.bottomTextView.delegate = self;
    self.bottomTextView.placeholderFont = 14;
    self.bottomTextView.placeHolderCenterY = YES;
    self.countLab.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataWithBaseModel:(id )model indexPath:(NSIndexPath *)indexPath{
    self.bottomTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0);
    NSString *str = model[@"content"];
    if (indexPath.row == 0) {
//        if (str.length) {
//            self.countLab.hidden = NO;
//        }else{
//            self.countLab.hidden = YES;
//        }
        self.topLabel.text = @"用的不爽的，尽管吐槽吧～";
        self.bottomTextView.placeholder = @"请留下您宝贵的意见或建议(必填项)";
    }
    
    if (indexPath.row == 1) {
//        self.countLab.hidden = YES;
        self.topLabel.text = @"您的联系方式";
        self.bottomTextView.placeholder = @"请留下您的手机/QQ/微信（非必填）";
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.inputBlock) {
        WeakSelf(obj);
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
        }
        self.countLab.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
        self.inputBlock(obj,textView.text);
    }
}

@end
