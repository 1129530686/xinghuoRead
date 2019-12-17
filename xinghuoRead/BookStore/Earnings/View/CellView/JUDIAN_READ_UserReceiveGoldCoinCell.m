//
//  JUDIAN_READ_UserReceiveGoldCoinCell.m
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserReceiveGoldCoinCell.h"
#import "JUDIAN_READ_UserReceiveGoldCoinsContainer.h"
#import "UILabel+JUDIAN_READ_Label.h"


#define DOT_IMAGE_VIEW_TAG 100
#define BUTTON_VIEW_TAG 150
#define TITLE_VIEW_TAG 200
#define COUNT_VIEW_TAG 250
#define DIFF_TIME_VIEW_TAG 300

@interface JUDIAN_READ_UserReceiveGoldCoinCell ()
@property(nonatomic, weak)JUDIAN_READ_UserGoldCoinProgressView* container;
@end



@implementation JUDIAN_READ_UserReceiveGoldCoinCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self addGoldCoinsView];
    }
    
    return self;
}



- (void)addGoldCoinsView {
    
#if 0
    JUDIAN_READ_UserReceiveGoldCoinsContainer* container = [[JUDIAN_READ_UserReceiveGoldCoinsContainer alloc]init];
    [self.contentView addSubview:container];
    
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top).offset(17);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
#else
    
    JUDIAN_READ_UserGoldCoinProgressView* container = [[JUDIAN_READ_UserGoldCoinProgressView alloc] init];
    _container = container;
    [self.contentView addSubview:container];
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
#endif
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)updateCell:(NSArray*)array duration:(NSString*)duration {
    [_container updateView:array duration:duration];
}

- (void)setBlock:(modelBlock)block {
    _container.block = block;
}


@end


@interface JUDIAN_READ_UserGoldCoinProgressView ()
@property(nonatomic, assign)NSInteger diffTimeStrIndex;
@property(nonatomic, assign)NSInteger whichSegment;
@property(nonatomic, copy)NSString* diffTimeStr;
@property(nonatomic, copy)NSArray* goldCoinArray;
@property(nonatomic, assign)NSInteger currentDuration;
@end




@implementation JUDIAN_READ_UserGoldCoinProgressView


- (instancetype)init {
    self = [super init];
    if (self) {
        _diffTimeStrIndex = -1;
        _whichSegment = -1;
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UIView* previousView = nil;
    for (NSInteger index = 0; index < 6; index++) {
        
        UIButton* minuteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        minuteButton.userInteractionEnabled = NO;
        minuteButton.tag = BUTTON_VIEW_TAG + index;
        [minuteButton setBackgroundImage:[UIImage imageNamed:@"waiting_gold_button"] forState:UIControlStateNormal];
        minuteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [minuteButton setTitle:@"待完成" forState:UIControlStateNormal];
        [minuteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [minuteButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:minuteButton];
        
        
        UIImageView* dotImageView = [[UIImageView alloc] init];
        dotImageView.tag = DOT_IMAGE_VIEW_TAG + index;
        dotImageView.image = [UIImage imageNamed:@"unreceive_gold_state_dot"];
        [self addSubview:dotImageView];
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.tag = TITLE_VIEW_TAG + index;
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = RGB(0x33, 0x33, 0x33);
        [self addSubview:titleLabel];
        
        
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"ingots_small_tip"];
        [self addSubview:imageView];
        
        UILabel* countLabel = [[UILabel alloc] init];
        countLabel.tag = COUNT_VIEW_TAG + index;
        countLabel.text = @"";
        countLabel.font = [UIFont systemFontOfSize:12];
        countLabel.textColor = RGB(0xff, 0xa0, 0x30);
        [self addSubview:countLabel];
        
        
        UILabel* diffTimeLabel = [[UILabel alloc] init];
        diffTimeLabel.tag = DIFF_TIME_VIEW_TAG + index;
        diffTimeLabel.text = @"";
        diffTimeLabel.font = [UIFont systemFontOfSize:12];
        diffTimeLabel.textColor = RGB(0x99, 0x99, 0x99);
        [self addSubview:diffTimeLabel];
        
        
        WeakSelf(that);
        if (previousView) {
            [minuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(67));
                make.height.equalTo(@(27));
                make.top.equalTo(previousView.mas_bottom).offset(20);
                make.right.equalTo(that.mas_right).offset(-14);
            }];
        }
        else {
            
            [minuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(67));
                make.height.equalTo(@(27));
                make.top.equalTo(that.mas_top).offset(20);
                make.right.equalTo(that.mas_right).offset(-14);
            }];
        }
        
        
        [dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(10));
            make.height.equalTo(@(10));
            make.left.equalTo(that.mas_left).offset(14);
            make.centerY.equalTo(minuteButton.mas_centerY);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(that.mas_left).offset(38);
            make.height.equalTo(@(14));
            make.centerY.equalTo(minuteButton.mas_centerY);
            make.width.equalTo(@(0));
        }];
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(10);
            make.width.equalTo(@(18));
            make.height.equalTo(@(9));
            make.centerY.equalTo(minuteButton.mas_centerY);
        }];
        
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(3);
            make.right.equalTo(minuteButton.mas_left).offset(-10);
            make.height.equalTo(@(12));
            make.centerY.equalTo(minuteButton.mas_centerY);
        }];
        
        
        [diffTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_left);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.height.equalTo(@(12));
            make.right.equalTo(minuteButton.mas_left);
        }];
        
        
        previousView = minuteButton;
    }
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.width <= 0) {
        return;
    }
    
    [self setNeedsDisplay];
    
}



- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
    
    if (_goldCoinArray.count <= 0) {
        return;
    }

    UIImageView* view1 = [self viewWithTag:DOT_IMAGE_VIEW_TAG + _diffTimeStrIndex];
    UIImageView* view2 = nil;
    UIImage* dotImage = [UIImage imageNamed:@"received_gold_state_dot"];
    
    //红色实线
    NSInteger whichIndex = _diffTimeStrIndex;
    if (whichIndex < 0) {
        //whichIndex = 0;
    }
    
    NSInteger index = (whichIndex - 1);
    while (TRUE) {
        
        if (index < 0) {
            view2.image = dotImage;
            break;
        }
        
        view1.image = dotImage;
        view2 = [self viewWithTag:DOT_IMAGE_VIEW_TAG + index];
        
        UIBezierPath *line1Path = [UIBezierPath bezierPath];
        [line1Path moveToPoint:CGPointMake(view1.centerX,  view1.frame.origin.y)];
        [line1Path addLineToPoint:CGPointMake(view2.centerX, view2.frame.origin.y)];
        [line1Path setLineWidth:2];
        [READER_SETTING_PANEL_BUTTON_CLICKED_COLOR setStroke];
        [line1Path stroke];
        
        view1 = view2;
        index--;
    }
    
    //红色虚线
    view1 = [self viewWithTag:DOT_IMAGE_VIEW_TAG + whichIndex];
    view2 = [self viewWithTag:DOT_IMAGE_VIEW_TAG + whichIndex + 1];
    
    CGFloat dashSetting[] = {6,2};
    
    if ((whichIndex >= 0) && view2) {
        view1.image = dotImage;
        
        UIBezierPath *line1Path = [UIBezierPath bezierPath];
        [line1Path moveToPoint:CGPointMake(view1.centerX,  view1.frame.origin.y)];
        [line1Path addLineToPoint:CGPointMake(view2.centerX, view2.frame.origin.y)];
        [line1Path setLineWidth:2];
        
        [READER_SETTING_PANEL_BUTTON_CLICKED_COLOR setStroke];
        [line1Path setLineDash:dashSetting count:2 phase:0];
        [line1Path stroke];

    }
    
    //灰色虚线
    NSInteger count = _goldCoinArray.count;
    NSInteger grayIndex = 0;
    view1 = [self viewWithTag:DOT_IMAGE_VIEW_TAG + whichIndex + 1];
    for (grayIndex =  whichIndex + 2; grayIndex < count; grayIndex++) {
        
        view2 = [self viewWithTag:DOT_IMAGE_VIEW_TAG + grayIndex];
        
        UIBezierPath *line1Path = [UIBezierPath bezierPath];
        [line1Path moveToPoint:CGPointMake(view1.centerX,  view1.frame.origin.y)];
        [line1Path addLineToPoint:CGPointMake(view2.centerX, view2.frame.origin.y)];
        [line1Path setLineDash:dashSetting count:2 phase:0];
        [RGB(0xee, 0xee, 0xee) setStroke];
        [line1Path stroke];
        
        view1 = view2;
    }
    
    

}


- (void)updateView:(NSArray*)array duration:(NSString*)duration {
    
    if (array.count <= 0) {
        return;
    }
    
    NSInteger currentDuration = [duration intValue];
    _currentDuration = currentDuration;
    NSInteger index = 0;
    _diffTimeStr = @"";
    
    _goldCoinArray = array;
    
    _diffTimeStrIndex = _goldCoinArray.count - 1;
    
    NSInteger diff = 0;
    for (JUDIAN_READ_UserIgnotsModel* model in array) {
        diff = currentDuration - [model.min intValue];
        if (diff < 0 && _diffTimeStr.length <= 0) {
            _diffTimeStr = [NSString stringWithFormat:@"还差%ld分钟", labs(diff)];
            _diffTimeStrIndex = index - 1;
        }
        
        UILabel* titleLabel = [self viewWithTag:TITLE_VIEW_TAG + index];
        titleLabel.text = [NSString stringWithFormat:@"阅读%@分钟", model.min];
        
        UILabel* countLabel = [self viewWithTag:COUNT_VIEW_TAG + index];
        countLabel.text = [NSString stringWithFormat:@"+%@元宝", model.coin];
    
        index++;

        CGFloat width = [titleLabel getTextWidth:14];
        width = ceil(width);
        
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
        }];
    }
    
    
    UILabel* diffTimeLabel = [self viewWithTag:DIFF_TIME_VIEW_TAG + _diffTimeStrIndex + 1];
    diffTimeLabel.text = _diffTimeStr;
    
    if (_diffTimeStrIndex == (_goldCoinArray.count - 1)) {
        if (diff < 0) {
            _diffTimeStrIndex--;
        }
    }

    for (NSInteger index = _diffTimeStrIndex; index >= 0; index--) {
        [self updateButtonState:index];
    }

    [self setNeedsDisplay];
}



- (void)handleTouchEvent:(UIButton*)sender {
    if (_block) {
        NSNumber* number = @(sender.tag - BUTTON_VIEW_TAG);
        _block(number);
    }
}


- (void)updateButtonState:(NSInteger)buttonIndex {
    
    JUDIAN_READ_UserIgnotsModel* model =  _goldCoinArray[buttonIndex];
    if ([model.isGet isEqualToString:@"1"]) {
        UIButton* button = [self viewWithTag:BUTTON_VIEW_TAG + buttonIndex];
        [button setBackgroundImage:[UIImage imageNamed:@"received_gold_button"] forState:UIControlStateNormal];
        [button setTitle:@"已领取" forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }
    else if ([model.isGet isEqualToString:@"0"]) {
        UIButton* button = [self viewWithTag:BUTTON_VIEW_TAG + buttonIndex];
        if (_currentDuration >= model.min.intValue) {
            [button setBackgroundImage:[UIImage imageNamed:@"receive_gold_button"] forState:UIControlStateNormal];
            [button setTitle:@"待领取" forState:UIControlStateNormal];
            button.userInteractionEnabled = YES;
        }
        else {
            [button setTitle:@"待完成" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    

    
    
}




@end


