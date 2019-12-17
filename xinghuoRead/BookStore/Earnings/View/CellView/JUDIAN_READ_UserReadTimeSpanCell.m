//
//  JUDIAN_READ_UserReadTimeSpanCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserReadTimeSpanCell.h"


@interface JUDIAN_READ_UserReadTimeSpanCell ()
@property(nonatomic, weak)UILabel* timeSpanLabel;
@end


@implementation JUDIAN_READ_UserReadTimeSpanCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self addReadTimeSpanView];
    }
    
    return self;
}



- (void)addReadTimeSpanView {
    
    UILabel* timeSpanLabel = [[UILabel alloc]init];
    _timeSpanLabel = timeSpanLabel;
    [self.contentView addSubview:timeSpanLabel];
    
    WeakSelf(that);
    [timeSpanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(17));
        make.top.equalTo(that.contentView.mas_top).offset(27);
    }];
    
}



- (NSMutableAttributedString*)createTimeSpanText:(NSString*)span {
    if (span.length <= 0) {
        return nil;
    }
    
    NSString* text = [NSString stringWithFormat:@"今日阅读时长 %@分钟", span];
    NSRange range = [text rangeOfString:span];
    
    UIColor* color = nil;
    color = RGB(0x33, 0x33, 0x33);
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.location)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, range.location)];
    
    
    color = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    NSRange spanRange = NSMakeRange(range.location, span.length + 2);
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:spanRange];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:spanRange];
    
    
    return attributedText;
}


- (void)updateTimeSpan:(NSString*)span {
    _timeSpanLabel.attributedText = [self createTimeSpanText:span];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
