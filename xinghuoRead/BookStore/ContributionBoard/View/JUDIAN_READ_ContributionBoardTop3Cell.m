//
//  JUDIAN_READ_ContributionBoardTop3Cell.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContributionBoardTop3Cell.h"
#import "UIImage+JUDIAN_READ_Blur.h"


#define HEAD_IMAGE_WIDTH 53


@interface JUDIAN_READ_ContributionBoardTop3Cell ()
@property(nonatomic, weak)JUDIAN_READ_UserContributionMoneyView* top1View;
@property(nonatomic, weak)JUDIAN_READ_UserContributionMoneyView* top2View;
@property(nonatomic, weak)JUDIAN_READ_UserContributionMoneyView* top3View;
@end



@implementation JUDIAN_READ_ContributionBoardTop3Cell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addViews];
    }
    return self;
}



- (void)addViews {
    
    UIView* bgView = [[UIView alloc] init];
    bgView.layer.zPosition = -100;
    bgView.backgroundColor = [UIColor whiteColor];
   
    WeakSelf(that);

    NSInteger count = 8;
    if (iPhoneX) {
        count = 10;
    }
#if 1
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(66 * 5));
        make.top.equalTo(that.contentView.mas_top).offset(40);
    }];
#endif
    JUDIAN_READ_UserContributionMoneyView* top2View = [[JUDIAN_READ_UserContributionMoneyView alloc]init];
    _top2View = top2View;
    [top2View addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:top2View];

    JUDIAN_READ_UserContributionMoneyView* top1View = [[JUDIAN_READ_UserContributionMoneyView alloc]init];
    _top1View = top1View;
    [top1View addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:top1View];

    UIView* leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [top1View addSubview:leftLineView];
    
    UIView* rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [top1View addSubview:rightLineView];
    

    JUDIAN_READ_UserContributionMoneyView* top3View = [[JUDIAN_READ_UserContributionMoneyView alloc]init];
    _top3View = top3View;
    [top3View addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:top3View];

    

    
    
    NSInteger width = SCREEN_WIDTH - 2 * 14;
    NSInteger smallWidth = width * 0.32;
    
    [top2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(0);
        make.width.equalTo(@(smallWidth));
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    [top3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.contentView.mas_right).offset(-0);
        make.width.equalTo(@(smallWidth));
        make.top.equalTo(that.contentView.mas_top).offset(20);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    [top1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.top2View.mas_right);
        make.right.equalTo(that.top3View.mas_left);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(top1View.mas_left);
        make.top.equalTo(top1View.mas_top).offset(20);
        make.bottom.equalTo(top1View.mas_bottom).offset(-30);
        make.width.equalTo(@(0.5));
    }];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(top1View.mas_right);
        make.top.equalTo(top1View.mas_top).offset(20);
        make.bottom.equalTo(top1View.mas_bottom).offset(-30);;
        make.width.equalTo(@(0.5));
    }];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)updateCell:(NSArray*)array {
    
    if (array.count <= 0) {
        [_top2View updateDefaultUser:@"contribution_small_head"];
        [_top2View updateHead:CGSizeMake(53, 53) level:@"2"];
        
        [_top1View updateDefaultUser:@"contribution_big_head"];
        [_top1View updateHead:CGSizeMake(67, 67) level:@"1"];
        
        [_top3View updateDefaultUser:@"contribution_small_head"];
        [_top3View updateHead:CGSizeMake(53, 53) level:@"3"];
        return;
    }
    
    [_top2View updateUserContribution:array[1]];
    [_top2View updateHead:CGSizeMake(53, 53) level:@"2"];
    
    [_top1View updateUserContribution:array[0]];
    [_top1View updateHead:CGSizeMake(67, 67) level:@"1"];
    
    [_top3View updateUserContribution:array[2]];
    [_top3View updateHead:CGSizeMake(53, 53) level:@"3"];
}


- (void)handleTouchEvent:(UIControl*)sender {
    
    if (!_block) {
        return;
    }

    if (sender == _top1View) {
        _block(@(0));
    }
    else if(sender == _top2View) {
        _block(@(1));
    }
    else {
        _block(@(2));
    }
}



@end



@interface JUDIAN_READ_UserContributionMoneyView ()

@property(nonatomic, weak)UIImageView* imageView;
@property(nonatomic, weak)UIImageView* cornerView;

@property(nonatomic, weak)UILabel* userNameLabel;
@property(nonatomic, weak)UILabel* userIdLabel;
@property(nonatomic, weak)UILabel* userMoneyLabel;

@end




@implementation JUDIAN_READ_UserContributionMoneyView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    
    return self;
    
}


- (void)addViews {
    
    UIImageView* cornerView = [[UIImageView alloc] init];
    _cornerView = cornerView;
    [self addSubview:cornerView];
    

    UIImageView* imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = HEAD_IMAGE_WIDTH / 2.0f;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 2;
    //imageView.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:imageView];
    
    NSInteger fontOffset = 0;
    if (iPhone6Plus) {
        fontOffset = 2;
    }
    
    UILabel* userNameLabel = [[UILabel alloc] init];
    _userNameLabel = userNameLabel;
    userNameLabel.font = [UIFont systemFontOfSize:14 + fontOffset];
    userNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:userNameLabel];
    
    
    UILabel* userMoneyLabel = [[UILabel alloc] init];
    userMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _userMoneyLabel = userMoneyLabel;
    [self addSubview:userMoneyLabel];
    
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(HEAD_IMAGE_WIDTH));
        make.height.equalTo(@(HEAD_IMAGE_WIDTH));
        make.centerX.equalTo(that.mas_centerX);
        make.top.equalTo(that.mas_top).offset(28);
    }];
    
    [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(30));
        make.height.equalTo(@(25));
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_top).offset(-19);
    }];
    
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(8);
        make.right.equalTo(that.mas_right).offset(-8);
        make.height.equalTo(@(14 + fontOffset));
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    
    [userMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(8);
        make.right.equalTo(that.mas_right).offset(-8);
        make.height.equalTo(@(12 + fontOffset));
        make.top.equalTo(userNameLabel.mas_bottom).offset(13);
    }];
    

}


- (void)updateHead:(CGSize)size level:(NSString*)level {
    
    _imageView.layer.cornerRadius = size.width / 2.0f;
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
    }];
    
    if ([level isEqualToString:@"1"]) {
        _imageView.layer.borderColor = RGB(0xff, 0xf1, 0x5b).CGColor;
        _cornerView.image = [UIImage imageNamed:@"contribution_top1_tip"];
    }
    else if ([level isEqualToString:@"2"]) {
        _imageView.layer.borderColor = RGB(0x99, 0xc5, 0xda).CGColor;
        _cornerView.image = [UIImage imageNamed:@"contribution_top2_tip"];
    }
    
    else if ([level isEqualToString:@"3"]) {
        _imageView.layer.borderColor = RGB(0xff, 0xbc, 0x80).CGColor;
        _cornerView.image = [UIImage imageNamed:@"contribution_top3_tip"];
    }
    
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.width <= 0) {
        return;
    }
    
    [self addCornerLayer:self.bounds];
}



- (void)addCornerLayer:(CGRect)frame {
    
    if (self.layer.mask) {
        return;
    }
    
    if (frame.size.width <= 0) {
        return;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;

    self.layer.mask = maskLayer;
}







- (NSMutableAttributedString*)createAttributedText:(NSString*)text rmbTip:(NSString*)rmbTip {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSInteger fontOffset = 0;
    if (iPhone6Plus) {
        fontOffset = 2;
    }
    
    NSString* money = [NSString stringWithFormat:@"%@%@", rmbTip, text];
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:money];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10 + fontOffset] range:NSMakeRange(0, rmbTip.length)];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 + fontOffset weight:UIFontWeightMedium] range:NSMakeRange(rmbTip.length, [money length] - rmbTip.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR range:NSMakeRange(0, [money length])];
    
    return attributedText;
}


- (void)updateUserContribution:(JUDIAN_READ_UserContributionModel*)model {
    
    NSString* urlStr = model.avatar;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    _userNameLabel.text = model.nickname;
    _userIdLabel.text = model.uidb;
    
     NSString* money = [NSString stringWithFormat:@"%.1f", model.totalMoney.floatValue];
    _userMoneyLabel.attributedText = [self createAttributedText:money rmbTip:@"¥ "];
    
}


- (void)updateDefaultUser:(NSString*)imageNmae {
    _imageView.image = [UIImage imageNamed:imageNmae];
    _userNameLabel.text = @"虚位以待";
    _userIdLabel.text = @"";
    _userMoneyLabel.attributedText = nil;
}




@end





