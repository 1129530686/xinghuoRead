//
//  JUDIAN_READ_NovelExtraArrowView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelExtraArrowView.h"

@interface JUDIAN_READ_NovelExtraArrowView ()
@property(nonatomic, weak)UIImageView* imageView;
@end


@implementation JUDIAN_READ_NovelExtraArrowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    UIImageView* imageView = [[UIImageView alloc]init];
    _imageView = imageView;
    imageView.image = [UIImage imageNamed:@"novel_extra_down_arrow"];
    [self.contentView addSubview:imageView];
    
    WeakSelf(that);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.contentView.mas_centerX);
        make.top.equalTo(that.contentView.mas_top);
        make.width.equalTo(@(12));
        make.height.equalTo(@(7));
    }];
    
}



- (void)updateArrow:(JUDIAN_READ_NovelSummaryModel*)model {
    
    NSString* imageName = @"";
    if (model.arrowState == NOVEL_BRIEF_ARROW_DOWN) {
        model.arrowState = NOVEL_BRIEF_ARROW_UP;
        imageName = @"novel_extra_up_arrow";
    }
    else if(model.arrowState == NOVEL_BRIEF_ARROW_UP) {
        model.arrowState = NOVEL_BRIEF_ARROW_DOWN;
        imageName = @"novel_extra_down_arrow";
    }
    else {
        
    }
    
    _imageView.image = [UIImage imageNamed:imageName];
}


@end
