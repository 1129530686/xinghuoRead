//
//  JUDIAN_READ_UserRateFictionCountCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserRateFictionCountCell.h"

@interface JUDIAN_READ_UserRateFictionCountCell ()
@property(nonatomic, weak)UILabel* fictionNameLabel;
@property(nonatomic, weak)UILabel* rateCountLabel;
@end


@implementation JUDIAN_READ_UserRateFictionCountCell

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
    
    UILabel* fictionNameLabel = [[UILabel alloc] init];
    _fictionNameLabel = fictionNameLabel;
    fictionNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    fictionNameLabel.font = [UIFont systemFontOfSize:14];
    fictionNameLabel.text = @"";//
    fictionNameLabel.numberOfLines = 2;
    fictionNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:fictionNameLabel];
    
    UILabel* rateCountLabel = [[UILabel alloc] init];
    _rateCountLabel = rateCountLabel;
    rateCountLabel.textColor = RGB(0x99, 0x99, 0x99);
    rateCountLabel.font = [UIFont systemFontOfSize:12];
    rateCountLabel.text = @"";//
    rateCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:rateCountLabel];
    
    
    
    UILabel* scoreTipLabel = [[UILabel alloc] init];
    scoreTipLabel.textColor = RGB(0x33, 0x33, 0x33);
    scoreTipLabel.font = [UIFont systemFontOfSize:14];
    scoreTipLabel.text = @"满意是10分，你觉得这本书能打几分？";
    scoreTipLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:scoreTipLabel];
    
    
    UILabel* scoreCountTipLabel = [[UILabel alloc] init];
    scoreCountTipLabel.textColor = RGB(0x99, 0x99, 0x99);
    scoreCountTipLabel.font = [UIFont systemFontOfSize:12];
    scoreCountTipLabel.text = @"点击下列选项  添加评分";
    scoreCountTipLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:scoreCountTipLabel];
    
    
    WeakSelf(that);
    [fictionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(34));
        make.top.equalTo(that.contentView.mas_top).offset(30);
    }];
    
    [rateCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(12));
        make.top.equalTo(fictionNameLabel.mas_bottom).offset(10);
    }];
    
    
    [scoreTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.top.equalTo(rateCountLabel.mas_bottom).offset(50);
    }];
    
    
    
    [scoreCountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(12));
        make.top.equalTo(scoreTipLabel.mas_bottom).offset(10);
    }];
    
    
    
}


- (void)upateCell:(NSString*)bookName author:(NSString*)author count:(NSString*)count {
    _fictionNameLabel.text = [NSString stringWithFormat:@"《%@》—— %@", bookName, author];
    [_fictionNameLabel sizeToFit];
    _rateCountLabel.text = [NSString stringWithFormat:@"已有%@人评分", count];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
