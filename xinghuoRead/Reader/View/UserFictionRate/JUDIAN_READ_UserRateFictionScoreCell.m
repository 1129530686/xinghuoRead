//
//  JUDIAN_READ_UserRateFictionScoreCell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserRateFictionScoreCell.h"
#import "UIView+Common.h"
#import "JUDIAN_READ_UserRateButton.h"


#define SCORE_BUTTON_TAG 100

@implementation JUDIAN_READ_UserRateFictionScoreCell

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

    CGFloat width = (SCREEN_WIDTH - 2 * 14 - 4 * 8) / 5;
    CGFloat height = 30;
    
    NSInteger xPos = 14;
    NSInteger yPos = 13;
    NSInteger row = 0;
    
    for (NSInteger index = 0; index < 10; index++) {

        row++;
        
        JUDIAN_READ_UserRateButton* button = [JUDIAN_READ_UserRateButton buttonWithType:(UIButtonTypeCustom)];
        button.isSelected = FALSE;
        button.frame = CGRectMake(xPos, yPos, width, height);
        button.tag = SCORE_BUTTON_TAG + index;
        button.backgroundColor = RGB(0xee, 0xee, 0xee);
        NSString* score = [NSString stringWithFormat:@"%ld分", (long)(index + 1)];
        [button setTitle:score forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:RGB(0x66, 0x66, 0x66) forState:(UIControlStateNormal)];
        //[button clipCorner:CGSizeMake(3, 3)];
        [button setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_bg"] forState:(UIControlStateNormal)];
        //[button setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_bg"] forState:(UIControlStateHighlighted)];
        
        [self.contentView addSubview:button];

        [button addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (row == 5) {
            row = 0;
            xPos = 14;
            yPos += 30;
            yPos += 7;
        }
        else {
            xPos += width;
            xPos += 8;
        }

    }
    
    //JUDIAN_READ_UserRateButton* button = [self.contentView viewWithTag:SCORE_BUTTON_TAG + 9];
    //button.isSelected = TRUE;
    //[button setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_high_light_bg"] forState:(UIControlStateNormal)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)handleTouchEvent:(JUDIAN_READ_UserRateButton*)sender {
    
    for (NSInteger index = 0; index < 10; index++) {
        JUDIAN_READ_UserRateButton* button = [self.contentView viewWithTag:SCORE_BUTTON_TAG + index];
        button.isSelected = FALSE;
        [button setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_bg"] forState:(UIControlStateNormal)];
    }
    
    sender.isSelected = TRUE;
    if (sender.isSelected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_high_light_bg"] forState:(UIControlStateNormal)];
        //[sender setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_high_light_bg"] forState:(UIControlStateHighlighted)];
    }
    else {
        [sender setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_bg"] forState:(UIControlStateNormal)];
        //[sender setBackgroundImage:[UIImage imageNamed:@"reader_rate_level_bg"] forState:(UIControlStateHighlighted)];
    }
    
}



- (NSString*)getScore {
    
    NSString* score = @"";
    for (NSInteger index = 0; index < 10; index++) {
        JUDIAN_READ_UserRateButton* button = [self.contentView viewWithTag:SCORE_BUTTON_TAG + index];
        if (button.isSelected) {
            score = [NSString stringWithFormat:@"%ld", (long)(index + 1)];
            break;
        }
    }
    
    return score;
}



- (void)updateCell:(NSInteger)index {

    if (index < 0) {
        return;
    }
    JUDIAN_READ_UserRateButton* button = [self.contentView viewWithTag:SCORE_BUTTON_TAG + index];
    [self handleTouchEvent:button];
}



@end
