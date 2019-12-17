//
//  JUDIAN_READ_SuggestDetailCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SuggestDetailCell.h"
#import "JUDIAN_READ_SuggestModel.h"

@implementation JUDIAN_READ_SuggestDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDataWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_SuggestModel *info = model[indexPath.row];
    if (info.answer_content.length && info.answer_content) {
        self.verticalSpace.constant = 0;
        self.BackView.height = 0;
        self.botTimeLab.text = @"";
        self.replyLab.attributedText = [[NSAttributedString alloc]initWithString:@""];
    }else{
        self.verticalSpace.constant = 9;
        NSString *str = [NSString stringWithFormat:@"追书宝回复意见：%@",info.answer_content];
        self.BackView.height = [str heightForFont:kFontSize13 width:SCREEN_WIDTH-50] + 30 + 12;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
        [att addAttributes:@{NSForegroundColorAttributeName:kColor153} range:NSMakeRange(0, 8)];
        self.replyLab.attributedText = att;
        self.botTimeLab.text = info.answer_time;
    }

    self.topTimeLab.text = info.create_time;
    self.suggestLab.text = info.content;
}

@end
