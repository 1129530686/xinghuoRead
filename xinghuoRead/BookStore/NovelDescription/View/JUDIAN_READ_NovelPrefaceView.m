//
//  JUDIAN_READ_NovelPrefaceView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelPrefaceView.h"
#import "JUDIAN_READ_FictionPrefaceView.h"


@interface JUDIAN_READ_NovelPrefaceView ()
@property(nonatomic, weak)JUDIAN_READ_FictionPrefaceView* prefaceLabel;
@property(nonatomic, weak)UIImageView* imageView;
@end

@implementation JUDIAN_READ_NovelPrefaceView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}



- (void)addViews {

    JUDIAN_READ_FictionPrefaceView* prefaceLabel = [[JUDIAN_READ_FictionPrefaceView alloc]init];
    _prefaceLabel = prefaceLabel;
    [self.contentView addSubview:prefaceLabel];
    
#if 0
    UIImageView* imageView = [[UIImageView alloc]init];
    _imageView = imageView;
    imageView.image = [UIImage imageNamed:@"novel_extra_down_arrow"];
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(prefaceLabel.mas_right).offset(-4);
        make.bottom.equalTo(prefaceLabel.mas_bottom).offset(-3);
        make.width.equalTo(@(12));
        make.height.equalTo(@(7));
    }];
#endif
    
    WeakSelf(that);
    [prefaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(13);
        make.right.equalTo(that.contentView.mas_right).offset(-13);
        make.top.equalTo(that.contentView.mas_top).offset(16);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-16);
    }];

}


- (void)setPrefaceModel:(JUDIAN_READ_NovelSummaryModel*)model {
    _prefaceLabel.model = model;
    [_prefaceLabel setNeedsLayout];
    [_prefaceLabel setNeedsDisplay];
}

@end
