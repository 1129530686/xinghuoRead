//
//  JUDIAN_READ_NovelCopyRightView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelCopyRightView.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"
#import "UILabel+JUDIAN_READ_Label.h"


#define SIDE_EDGE 14
#define BOTTOM_EDGE 23
#define TOP_EDGE 34

@interface JUDIAN_READ_NovelCopyRightView ()
@property(nonatomic, weak)JUDIAN_READ_VerticalAlignmentLabel* ruleLabel;
@end



@implementation JUDIAN_READ_NovelCopyRightView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    JUDIAN_READ_VerticalAlignmentLabel* ruleLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    _ruleLabel = ruleLabel;
    ruleLabel.backgroundColor = [UIColor whiteColor];
    ruleLabel.attributedText = [self buildAttributedString];
    ruleLabel.numberOfLines = 0;
    [self.contentView addSubview:ruleLabel];
    
    CGFloat edge = SIDE_EDGE;

    WeakSelf(that);
    [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(edge);
        make.right.equalTo(that.contentView.mas_right).offset(-edge);
        make.top.equalTo(that.contentView.mas_top).offset(TOP_EDGE);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-BOTTOM_EDGE);
    }];

}



- (NSMutableAttributedString*)buildAttributedString {
    
    NSString* text = @"版权声明：本书数字版权由 甜悦读 提供并授权发行使用，如有 疑问，可通过“个人中心-意见反馈”联系我们。";
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x99, 0x99, 0x99) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}


- (CGFloat)getCellHeight:(CGFloat)width {
    CGFloat height = [_ruleLabel sizeWithAttributes:CGSizeMake(width - 2 * SIDE_EDGE, MAXFLOAT)].height;;
    return  ceil(height + TOP_EDGE + BOTTOM_EDGE);
}



@end
