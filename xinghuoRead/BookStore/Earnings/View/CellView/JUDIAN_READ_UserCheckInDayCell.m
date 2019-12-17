//
//  JUDIAN_READ_UserCheckInDayCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserCheckInDayCell.h"
#import "JUDIAN_READ_PointsSegmentView.h"

#define _SEGMENT_VIEW_TAG_ 2000
#define _CONNECTION_LINE_VIEW_TAG_ 2100


@interface JUDIAN_READ_UserCheckInDayCell ()
@property(nonatomic, weak)UIImageView* checkInImageView;
@property(nonatomic, weak)UILabel* continueDayLabel;
@property(nonatomic, weak)UIButton* appreciateButton;
@end

@implementation JUDIAN_READ_UserCheckInDayCell

- (void)awakeFromNib {
    [super awakeFromNib];

}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addCheckInView];
    }
    
    return self;
}




- (void)addCheckInView {
    UIImageView* imageView = [[UIImageView alloc]init];
    _checkInImageView = imageView;
    imageView.image = [UIImage imageNamed:@"check_in_bg_image"];
    [self.contentView addSubview:imageView];

    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-17);
    }];
    
    UILabel* continueDayLabel = [[UILabel alloc]init];
    _continueDayLabel = continueDayLabel;
    [imageView addSubview:continueDayLabel];
    
    [continueDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(14);
        make.right.equalTo(imageView.mas_right).offset(-14);
        make.height.equalTo(@(14));
        make.top.equalTo(imageView.mas_top).offset(30);
    }];

    
    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _appreciateButton = appreciateButton;
    [appreciateButton setBackgroundImage:[UIImage imageNamed:@"user_appeciate_money_tip"] forState:UIControlStateNormal];
    appreciateButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [appreciateButton setTitle:@"签到" forState:UIControlStateNormal];
    [appreciateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appreciateButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:appreciateButton];
    
    [appreciateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.width.equalTo(@(207));
        make.height.equalTo(@(40));
        make.bottom.equalTo(imageView.mas_bottom).offset(16);
    }];
    
    
    
    
    
    [self addPointsView:imageView];
    [self addConnectionLineView:imageView];
}




- (void)addPointsView:(UIView*)view {
    
    CGFloat lineWidth = 12;
    CGFloat width = 33;
    if (iPhone6Plus) {
        width = 40;
    }
    
    CGFloat centerX = (SCREEN_WIDTH - 2 * 14 - width * 7 - 6 * lineWidth) / 2;
    CGFloat height = POINTS_BG_WIDTH + 12 + 7;
    
    
    for (NSInteger index = 0; index < 7; index++) {
        
        JUDIAN_READ_PointsSegmentView* segmentView = [[JUDIAN_READ_PointsSegmentView alloc]init];
        segmentView.tag = _SEGMENT_VIEW_TAG_ + index;
        [view addSubview:segmentView];
        
        [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
            make.bottom.equalTo(view.mas_bottom).offset(-37);
            make.left.equalTo(@(centerX));
        }];

        if (index < 6) {
            centerX += width;
            centerX += lineWidth;
        }
    }
    
}




- (void)addConnectionLineView:(UIView*)view {
    //points_connect_image
    
    for (NSInteger index = 0; index < 6; index++) {
        UIImageView* middleLineView = [[UIImageView alloc]init];
        middleLineView.tag = _CONNECTION_LINE_VIEW_TAG_ + index;
  
        UIView* leftView = [view viewWithTag:(_SEGMENT_VIEW_TAG_ + index)];
        UIView* rightView = [view viewWithTag:(_SEGMENT_VIEW_TAG_ + index + 1)];
        
        [view insertSubview:middleLineView belowSubview:leftView];
        
        [middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_centerX);
            make.right.equalTo(rightView.mas_centerX);
            make.top.equalTo(leftView.mas_top).offset(16);
            make.height.equalTo(@(4));
        }];
    }

}




- (NSMutableAttributedString*)createDayText:(NSString*)day {
    if (day.length <= 0) {
        return nil;
    }
    
    NSString* text = [NSString stringWithFormat:@"您已连续签到%@天", day];
    NSRange range = [text rangeOfString:day];
    
    UIColor* color = nil;
    color = RGB(0x33, 0x33, 0x33);
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.location)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range.location)];
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(range.location, range.length)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(range.location, day.length)];
    
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(text.length - 1, 1)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(text.length - 1, 1)];
    
    
    return attributedText;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void)updateDaySegment:(NSInteger)whichDay {
    for (NSInteger index = 0; index < _countArray.count; index++) {
        JUDIAN_READ_PointsSegmentView* segmentView =  [_checkInImageView viewWithTag:_SEGMENT_VIEW_TAG_ + index];
        UIImageView* middleLineView = [_checkInImageView viewWithTag:_CONNECTION_LINE_VIEW_TAG_ + index];
        
        JUDIAN_READ_UserCheckInDayModel* model = _countArray[index];
        
        if ((index + 1) <= whichDay) {
            [segmentView updatePoints:(index + 1) count:model.coin checkIn:YES];
        }
        else {
            [segmentView updatePoints:(index + 1) count:model.coin checkIn:FALSE];
        }
        
        if ((index + 1) <= (whichDay - 1)) {
            middleLineView.image = [UIImage imageNamed:@"points_connect_hightlight_image"];
        }
        else {
            middleLineView.image = [UIImage imageNamed:@"points_connect_image"];
        }
    }

    _continueDayLabel.attributedText = [self createDayText:[NSString stringWithFormat:@"%ld", (long)whichDay]];
}




- (void)handleTouchEvent:(UIButton*)sender {
    if (_block) {
        _block(@"");
    }
}




- (void)updateCell:(JUDIAN_READ_UserCheckInGoldListModel*)model {
    if (!model) {
        return;
    }
    
    self.countArray = model.reward_rule;
    [self updateDaySegment:model.signin_days.intValue];
    
    if (model.today_signin.intValue == 1) {
        [_appreciateButton setTitle:@"今日已签到" forState:UIControlStateNormal];
        [_appreciateButton setBackgroundImage:[UIImage imageNamed:@"user_checked_in_image"] forState:UIControlStateNormal];
        _appreciateButton.userInteractionEnabled = NO;
    }
    
}





@end
