//
//  JUDIAN_READ_NoResultCell.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_NoResultCell.h"

@implementation JUDIAN_READ_NoResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)loadBookAction:(id)sender {
    if (self.LoadBookBlock) {
        self.LoadBookBlock();
    }
}

- (void)setModel:(NSString *)model{
    NSString *str = [NSString stringWithFormat:@"找到0本，含“%@”的图书",model];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    [att addAttributes:@{NSForegroundColorAttributeName:kThemeColor} range:NSMakeRange(7, model.length)];
    self.topLab.attributedText = att;
}

@end
