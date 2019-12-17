//
//  JUDIAN_READ_NovelSummaryView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelSummaryView.h"
#import "UIImage+JUDIAN_READ_Blur.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"


@interface JUDIAN_READ_NovelSummaryView ()
@property(nonatomic, weak)UIImageView* backgroudView;
@property(nonatomic, weak)UIImageView* thumbView;
@property(nonatomic, weak)UILabel* novelNameLabel;
@property(nonatomic, weak)UILabel* novelStateLabel;
@property(nonatomic, weak)UILabel* novelAuthorLabel;
@property(nonatomic, weak)UILabel* novelCatagoryLabel;
@end



@implementation JUDIAN_READ_NovelSummaryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



#if 0
- (id)init {
    self = [super init];
    if (self) {
        [self addViews];
    }
    
    return self;
}
#endif



- (void)addViews {
    
    UIImageView* backgroudView = [[UIImageView alloc]init];
    backgroudView.backgroundColor = [UIColor lightGrayColor];
    //UIImage* image = [UIImage imageNamed:@"default_h2_image"];
    //backgroudView.image = image;//[image blurWithCoreImage:80];
    _backgroudView = backgroudView;
    [self addSubview:backgroudView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.5;
    [backgroudView addSubview:effectView];
    
    
    UIImageView* thumbView = [[UIImageView alloc]init];
    thumbView.image = [UIImage imageNamed:@"default_v_image"];
    _thumbView = thumbView;
    [self addSubview:thumbView];
    
    
    JUDIAN_READ_VerticalAlignmentLabel* novelNameLabel = [[JUDIAN_READ_VerticalAlignmentLabel alloc]init];
    [novelNameLabel setAlignmentStyle:(TextInTop)];
    novelNameLabel.numberOfLines = 3;
    //novelNameLabel.textColor = [UIColor whiteColor];
    //novelNameLabel.font = [UIFont systemFontOfSize:19];
    novelNameLabel.text = @"";
    _novelNameLabel = novelNameLabel;
    [self addSubview:novelNameLabel];
    
    
    UILabel* novelStateLabel = [[UILabel alloc]init];
    novelStateLabel.textColor = [UIColor whiteColor];
    novelStateLabel.font = [UIFont systemFontOfSize:12];
    novelStateLabel.text = @"";
    _novelStateLabel = novelStateLabel;
    [self addSubview:novelStateLabel];
    
    UILabel* novelAuthorLabel = [[UILabel alloc]init];
    novelAuthorLabel.textColor = [UIColor whiteColor];
    novelAuthorLabel.font = [UIFont systemFontOfSize:12];
    novelAuthorLabel.text = @"";
    _novelAuthorLabel = novelAuthorLabel;
    [self addSubview:novelAuthorLabel];
    
    
    
    UILabel* novelCatagoryLabel = [[UILabel alloc]init];
    _novelCatagoryLabel = novelCatagoryLabel;
    novelCatagoryLabel.textColor = RGB(0xee, 0xee, 0xee);
    novelCatagoryLabel.font = [UIFont systemFontOfSize:10];
    novelCatagoryLabel.text = @"";
    novelCatagoryLabel.textAlignment = NSTextAlignmentCenter;
    
    novelCatagoryLabel.layer.cornerRadius = 2;
    novelCatagoryLabel.layer.borderColor = RGB(0xee, 0xee, 0xee).CGColor;
    novelCatagoryLabel.layer.borderWidth = 0.5;
    novelCatagoryLabel.hidden = YES;
    [self addSubview:novelCatagoryLabel];
    
#if 0
    UIImageView* freeImageView = [[UIImageView alloc]init];
    freeImageView.image = [UIImage imageNamed:@"label_free"];
    [self addSubview:freeImageView];
#endif
    
    WeakSelf(that);
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top);
        make.height.equalTo(that.mas_height);
    }];
    

    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.width.equalTo(that.mas_width);
        make.top.equalTo(that.mas_top);
        make.height.equalTo(that.mas_height);
    }];
  
    
    [thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(79));
        make.height.equalTo(@(112));
        make.bottom.equalTo(that.mas_bottom).offset(-20);
    }];
    
    
    [novelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thumbView.mas_right).offset(16);
        make.top.equalTo(thumbView.mas_top).offset(0);
        make.height.equalTo(@(38));
        make.right.equalTo(that.mas_right).offset(-16);
    }];
    
    [novelStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thumbView.mas_right).offset(18);
        make.top.equalTo(novelNameLabel.mas_bottom).offset(13);
        make.height.equalTo(@(12));
        make.right.equalTo(that.mas_right).offset(-16);
    }];
    
    
    [novelAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thumbView.mas_right).offset(18);
        make.top.equalTo(novelStateLabel.mas_bottom).offset(25);
        make.height.equalTo(@(12));
        make.width.equalTo(@(0));
    }];
    
    
    [novelCatagoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(novelAuthorLabel.mas_right).offset(10);
        make.centerY.equalTo(novelAuthorLabel.mas_centerY);
        make.height.equalTo(@(16));
        make.width.equalTo(@(60));
    }];
    
#if 0
    [freeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //16 24
        make.left.equalTo(thumbView.mas_left).offset(7);
        make.top.equalTo(thumbView.mas_top).offset(-1);
        make.width.equalTo(@(16));
        make.height.equalTo(@(24));
    }];
#endif
}



- (void)setHeadViewWithModel:(JUDIAN_READ_NovelSummaryModel*)model {

    WeakSelf(that);
    UIImage* defaultImage = [UIImage imageNamed:@"default_v_image"];

    [_thumbView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:defaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        that.backgroudView.image = [image imageByBlurLight];
        that.thumbView.image = [image createCornerImage:CGSizeMake(10, 10)];
    }];
    

    //_novelNameLabel.text = model.bookname;
    _novelNameLabel.attributedText = [self createAttributedText:model.bookname];
    
    _novelStateLabel.text = model.author;
    _novelAuthorLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",model.tag, model.words_number, [model getNovelStateStr]];
    _novelCatagoryLabel.text = @"";
    //_novelCatagoryLabel.hidden = NO;
    
    CGFloat authorWidth = [_novelAuthorLabel getTextWidth:12];
    [_novelAuthorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(authorWidth + 2));
    }];
    
    
    CGFloat catagoryWidth = [_novelCatagoryLabel getTextWidth:12];
    [_novelCatagoryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(catagoryWidth + 6));
    }];
    
    
    [self setNeedsLayout];

}



- (NSMutableAttributedString*)createAttributedText:(NSString*)text {
    if (text.length <= 0) {
        return nil;
    }
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [text length])];
    
    return attributedText;
}






- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_novelNameLabel.attributedText.length <= 0) {
        return;
    }

    NSInteger height = 0;
    NSInteger lineCount = 0;
    
    [_novelNameLabel computeAttributedTextHeight:_novelNameLabel.frame.size.width height:&height lineCount:&lineCount];
    CGSize size = [_novelNameLabel sizeWithAttributes:CGSizeMake(_novelNameLabel.frame.size.width, MAXFLOAT)];

    WeakSelf(that);
    if (lineCount == 1) {
        [_novelNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(19));
            make.top.equalTo(that.thumbView.mas_top).offset(16);
        }];
    }
    else {
        
        [_novelNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(size.height)));
            make.top.equalTo(that.thumbView.mas_top).offset(0);
        }];
        
        if (lineCount >= 3) {
            
            [_novelStateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(that.novelNameLabel.mas_bottom).offset(13);
            }];
            
            [_novelAuthorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(that.novelStateLabel.mas_bottom).offset(12);
            }];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [that.novelNameLabel sizeToFit];
        });
    }

}



@end
