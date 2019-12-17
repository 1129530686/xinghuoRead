//
//  JUDIAN_READ_CoinHeadFooterView.m
//  universalRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CoinHeadFooterView.h"
#import "JUDIAN_READ_GoldCoinListModel.h"


@implementation JUDIAN_READ_CoinHeadFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leadBtn];
    }
    return self;
}

- (UIButton *)leadBtn{
    if (!_leadBtn) {
        _leadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leadBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _leadBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.leadBtn.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, self.contentView.height);
}

- (void)setCoinDataWithModel:(id )model{//金币明细
    JUDIAN_READ_GoldCoinListModel *info = model;
    NSString *str = info.date;
    self.contentView.backgroundColor = kBackColor;
    [self.leadBtn setText:str titleFontSize:12 titleColot:kColor100];
}

@end
