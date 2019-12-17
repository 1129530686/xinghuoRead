//
//  JUDIAN_READ_RecruitSubordinateProfitCell.m
//  universalRead
//
//  Created by judian on 2019/10/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_RecruitSubordinateProfitCell.h"


@interface JUDIAN_READ_RecruitSubordinateProfitCell ()
@property(nonatomic, assign)NSInteger cellHeight;
@end



@implementation JUDIAN_READ_RecruitSubordinateProfitCell

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
    
    UIImageView* titleView = [[UIImageView alloc] init];
    titleView.image = [UIImage imageNamed:@"recruit_subordinate_title"];
    [self.contentView addSubview:titleView];
    
    
    UIImageView* profitView = [[UIImageView alloc] init];
    profitView.image = [UIImage imageNamed:@"recruit_subordinate_profit_tip"];
    [self.contentView addSubview:profitView];
    
    
    UIImageView* workContentView = [[UIImageView alloc] init];
    workContentView.image = [UIImage imageNamed:@"recruit_subordinate_work_tip"];
    [self.contentView addSubview:workContentView];
    
    
    CGFloat titleWidth = (SCREEN_WIDTH - 21 * 2);
    CGFloat titleHeight = ceil(titleWidth * 0.23);// 75 / 320
    
    
    CGFloat profitWidth = (SCREEN_WIDTH - 10 * 2);
    CGFloat profitHeight = ceil(titleWidth * 0.83);// 570 / 686

    
    CGFloat workWidth = (SCREEN_WIDTH - 13 * 2);
    CGFloat workHeight = ceil(titleWidth * 0.3);// 196 / 667
    
    
    WeakSelf(that);
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(titleWidth));
        make.height.equalTo(@(titleHeight));
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(@(46));
    }];
    
    
    [profitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(profitWidth));
        make.height.equalTo(@(profitHeight));
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(titleView.mas_bottom).offset(10);
    }];
    
    
    [workContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(workWidth));
        make.height.equalTo(@(workHeight));
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.bottom.equalTo(profitView).offset(30);
    }];
    
    _cellHeight = 46;
    _cellHeight += titleHeight;
    
    _cellHeight += 10;
    _cellHeight += profitHeight;
    
    _cellHeight += 30;
 
}



- (NSInteger)getCellHeight {
    return _cellHeight;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}




@end



@interface JUDIAN_READ_RecruitSubordinateRuleCell ()
@property(nonatomic, assign)NSInteger cellHeight;
@end


@implementation JUDIAN_READ_RecruitSubordinateRuleCell

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
    UIImageView* ruleView = [[UIImageView alloc] init];
    ruleView.image = [UIImage imageNamed:@"recruit_subordinate_rule_tip"];
    [self.contentView addSubview:ruleView];
    
    CGFloat ruleWidth = (SCREEN_WIDTH - 10 * 2);
    CGFloat ruleHeight = ceil(ruleWidth * 0.6);// 395 / 667
    
    
    WeakSelf(that);
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ruleWidth));
        make.height.equalTo(@(ruleHeight));
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(@(33));
    }];
    
    _cellHeight = 33;
    _cellHeight += ruleHeight;
}




- (NSInteger)getCellHeight {
    return _cellHeight;
}


@end



@interface JUDIAN_READ_RecruitSubordinateWxCodeCell ()
@property(nonatomic, assign)NSInteger cellHeight;
@property(nonatomic, weak)UILabel* codeLabel;
@end


@implementation JUDIAN_READ_RecruitSubordinateWxCodeCell

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
    UIImageView* wxView = [[UIImageView alloc] init];
    wxView.image = [UIImage imageNamed:@"recruit_subordinate_wx_bg"];
    [self.contentView addSubview:wxView];
    
    UIImageView* editorView = [[UIImageView alloc] init];
    editorView.image = [UIImage imageNamed:@"recruit_subordinate_wx_editor"];
    [self.contentView addSubview:editorView];
   
    
    UIButton* copyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [copyButton addTarget:self action:@selector(handleButtonTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:copyButton];
    
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [copyButton addSubview:lineView];
    

    UILabel* codeLabel = [[UILabel alloc] init];
    _codeLabel = codeLabel;
    codeLabel.text = @"000000008888668";
    codeLabel.textColor = [UIColor whiteColor];
    codeLabel.textAlignment = NSTextAlignmentRight;
    codeLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.contentView addSubview:codeLabel];
    
    
    CGFloat wxWidth = (SCREEN_WIDTH - 10 * 2);
    CGFloat wxHeight = ceil(wxWidth * 0.38);// 253 / 670

    
    WeakSelf(that);
    [wxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wxWidth));
        make.height.equalTo(@(wxHeight));
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(@(33));
    }];
    
    [editorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(40);
        make.right.equalTo(that.contentView.mas_right).offset(-40);
        make.height.equalTo(@(33));
        make.centerY.equalTo(wxView.mas_centerY).offset(-10);
    }];
    
    
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(editorView.mas_height);
        make.right.equalTo(editorView.mas_right).offset(-10);
        make.centerY.equalTo(editorView.mas_centerY);
    }];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(editorView.mas_left).offset(10);
        make.right.equalTo(copyButton.mas_left).offset(-34);
        make.height.equalTo(@(18));
        make.centerY.equalTo(editorView.mas_centerY);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(copyButton.titleLabel.mas_left);
        make.right.equalTo(copyButton.titleLabel.mas_right);
        make.height.equalTo(@(1));
        make.bottom.equalTo(copyButton.titleLabel.mas_bottom).offset(2);
    }];
    
    _cellHeight = 33;
    _cellHeight += wxHeight;
}




- (NSAttributedString*)createUnderLineText:(NSString*)text {

    if (text.length <= 0) {
            return nil;
        }

    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //[paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];
    
    [attributedText addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInteger:kCTUnderlineStyleSingle] range:NSMakeRange(0, text.length)];
    return attributedText;
}




- (NSInteger)getCellHeight {
    return _cellHeight;
}


- (void)handleButtonTouch:(UIButton*)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _codeLabel.text;
    [MBProgressHUD showSuccess:@"复制成功"];
}


@end
