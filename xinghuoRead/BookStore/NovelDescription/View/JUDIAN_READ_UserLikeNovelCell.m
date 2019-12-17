//
//  JUDIAN_READ_UserLikeNovelCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/9.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserLikeNovelCell.h"


@interface JUDIAN_READ_UserLikeNovelCell ()
@property(nonatomic, weak)JUDIAN_READ_UserCollectNovelView* rateView;
@property(nonatomic, weak)JUDIAN_READ_UserCollectNovelView* readCountView;
@property(nonatomic, weak)JUDIAN_READ_UserCollectNovelView* appreciateView;
@end



@implementation JUDIAN_READ_UserLikeNovelCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {
    
    JUDIAN_READ_UserCollectNovelView* rateView = [[JUDIAN_READ_UserCollectNovelView alloc] initWithFrame:frame];
    [rateView addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    _rateView = rateView;
    [self.contentView addSubview:rateView];
    
    JUDIAN_READ_UserCollectNovelView* readCountView = [[JUDIAN_READ_UserCollectNovelView alloc] initWithFrame:frame];
    _readCountView = readCountView;
    [self.contentView addSubview:readCountView];
    
    
    UIView* vLineView1 = [[UIView alloc] init];
    vLineView1.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:vLineView1];
    
    UIView* vLineView2 = [[UIView alloc] init];
    vLineView2.backgroundColor = RGB(0xee, 0xee, 0xee);
    [self.contentView addSubview:vLineView2];

    JUDIAN_READ_UserCollectNovelView* appreciateView = [[JUDIAN_READ_UserCollectNovelView alloc] initWithFrame:frame];
    _appreciateView = appreciateView;
    [self.contentView addSubview:appreciateView];
    
    
    WeakSelf(that);
    [rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.width.equalTo(that.contentView.mas_width).multipliedBy(0.33f);
        make.top.equalTo(that.contentView.mas_top);
        make.height.equalTo(that.contentView.mas_height);
    }];
    
    
    [readCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rateView.mas_right);
        make.width.equalTo(that.contentView.mas_width).multipliedBy(0.33f);
        make.top.equalTo(that.contentView.mas_top);
        make.height.equalTo(that.contentView.mas_height);
    }];
    
    
    [appreciateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readCountView.mas_right);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top);
        make.height.equalTo(that.contentView.mas_height);
    }];
    
    
    [vLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(33));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.right.equalTo(rateView.mas_right);
        make.width.equalTo(@(0.5));
    }];
    
    [vLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(33));
        make.centerY.equalTo(that.contentView.mas_centerY);
        make.right.equalTo(readCountView.mas_right);
        make.width.equalTo(@(0.5));
    }];
    
    
    
}



- (void)updateCell:(JUDIAN_READ_NovelSummaryModel*)model {
    
    NSString* score = nil;
    NSString* readCount = nil;
    NSString* appreciateCount = nil;
    
    if (model) {
        score = [NSString stringWithFormat:@"%.1f", model.evaluate_score.floatValue];
        CGFloat limit = 10000.0f;
        CGFloat tenThousand = 0.0f;
        if (model.attention_num.integerValue >= limit) {
            tenThousand = model.attention_num.integerValue / limit;
            readCount = [NSString stringWithFormat:@"%.1f万", tenThousand];
        }
        else {
            readCount = [NSString stringWithFormat:@"%ld", model.attention_num.longValue];
        }
        
        if (model.fensi_num.longValue > limit) {
            tenThousand = model.fensi_num.integerValue / limit;
            appreciateCount = [NSString stringWithFormat:@"%.1f万", tenThousand];
        }
        else {
            appreciateCount = [NSString stringWithFormat:@"%ld", model.fensi_num.longValue];
        }

    }
    else {
        score = @"0.0";
        readCount = @"0";;
        appreciateCount = @"0";;
    }

    [_rateView updateCell:score content:@"评分"];
    [_readCountView updateCell:readCount content:@"人气"];
    [_appreciateView updateCell:appreciateCount content:@"粉丝"];
}


- (void)handleTouchEvent:(id)sender {
    if (_block) {
        _block(nil);
    }
}

@end


@interface JUDIAN_READ_UserCollectNovelView ()
@property(nonatomic, weak)UILabel* titleLabel;
@property(nonatomic, weak)UILabel* contentLabel;
@end

@implementation JUDIAN_READ_UserCollectNovelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews:frame];
    }
    
    return self;
}



- (void)addViews:(CGRect)frame {
    
    UILabel* titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    
    UILabel* contentLabel = [[UILabel alloc] init];
    _contentLabel = contentLabel;
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textColor = RGB(0x99, 0x99, 0x99);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    CGFloat offset = 10;
    CGFloat top = (frame.size.height - 17 - 12 - offset) / 2;
    
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(17));
        make.top.equalTo(that.mas_top).offset(top);
    }];
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(12));
        make.top.equalTo(titleLabel.mas_bottom).offset(7);
    }];
    
    
}



- (void)updateCell:(NSString*)title content:(NSString*)content {
    _titleLabel.text = title;
    _contentLabel.text = content;
}






@end
