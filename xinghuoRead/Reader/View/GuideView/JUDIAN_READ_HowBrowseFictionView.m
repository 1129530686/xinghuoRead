//
//  JUDIAN_READ_HowBrowseFictionView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/28.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_HowBrowseFictionView.h"

typedef enum : NSUInteger {
    kGuidePage1 = 1,
    kGuidePage2,
} GuidePageIndex;


@interface JUDIAN_READ_HowBrowseFictionView ()
@property(nonatomic, assign)NSInteger pageIndex;
@end



@implementation JUDIAN_READ_HowBrowseFictionView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.8);
        self.pageIndex = kGuidePage1;
        [self addFirstView];

    }
    
    return self;
}


- (void)addSecondView {
    
    UIImageView* moreView = [[UIImageView alloc]init];
    moreView.image = [UIImage imageNamed:@"how_browse_guide_more"];
    [self addSubview:moreView];
    

    UIImageView* arrowView = [[UIImageView alloc]init];
    arrowView.image = [UIImage imageNamed:@"how_browse_guide_arrow"];
    [self addSubview:arrowView];
    
    
    
    UIImageView* promptView = [[UIImageView alloc]init];
    promptView.image = [UIImage imageNamed:@"how_browse_guide_text"];
    [self addSubview:promptView];
    
    
    UIButton* knowButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [knowButton setImage:[UIImage imageNamed:@"how_browse_guide_know"] forState:(UIControlStateNormal)];
    [self addSubview:knowButton];
    [knowButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    NSInteger bottomOffset = [self getBottomOffset];
    
    NSInteger topOffset = [self getNavigationHeight];
    topOffset = topOffset - 46;
    
    WeakSelf(that);
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topOffset));
        make.width.equalTo(@(46));
        make.height.equalTo(@(46));
        make.right.equalTo(that.mas_right).offset(-4);
    }];
    
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreView.mas_bottom);
        make.width.equalTo(@(87));
        make.height.equalTo(@(165));
        make.right.equalTo(moreView.mas_left).offset(10);
    }];
    

    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(arrowView.mas_bottom).offset(2);
        make.width.equalTo(@(196));
        make.height.equalTo(@(52));
        make.centerX.equalTo(that.mas_centerX);
    }];
    
    NSInteger bottom = 97 + bottomOffset;
    [knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(that.mas_bottom).offset(-bottom);
        make.width.equalTo(@(133));
        make.height.equalTo(@(40));
        make.centerX.equalTo(that.mas_centerX);
    }];
    
}



- (void)addFirstView {
  
    UIImageView* bgPageView = [[UIImageView alloc]init];
    bgPageView.image = [UIImage imageNamed:@"how_browse_guide_bg_tip"];
    [self addSubview:bgPageView];

    UIImageView* leftRightView = [[UIImageView alloc]init];
    leftRightView.image = [UIImage imageNamed:@"how_browse_guide_left_right_tip"];
    [self addSubview:leftRightView];
    
    WeakSelf(that);
    [bgPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(133));
        make.top.equalTo(that.mas_top).offset(20);
        make.bottom.equalTo(that.mas_bottom).offset(-20);
        make.centerX.equalTo(that.mas_centerX);
    }];
    

    [leftRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(285));
        make.height.equalTo(@(118));
        make.centerY.equalTo(that.mas_centerY);
        make.centerX.equalTo(that.mas_centerX);
    }];
    
#if 0
    UIImageView* previousPageView = [[UIImageView alloc]init];
    previousPageView.image = [UIImage imageNamed:@"how_browse_guide_prevous_page"];
    [self addSubview:previousPageView];
    
    UIImageView* nextPageView = [[UIImageView alloc]init];
    nextPageView.image = [UIImage imageNamed:@"how_browse_guide_next_page"];
    [self addSubview:nextPageView];
    
    
    NSInteger topOffset = [self getTopOffset];
    NSInteger bottomOffset = [self getBottomOffset];
    
    WeakSelf(that);
    [previousPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(185));
        make.height.equalTo(@(98));
        make.centerX.equalTo(that.mas_centerX);
        make.top.equalTo(that.mas_top).offset(30 + topOffset);
    }];
    
    
    [nextPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(185));
        make.height.equalTo(@(98));
        make.centerX.equalTo(that.mas_centerX);
        make.bottom.equalTo(that.mas_bottom).offset(-(30 + bottomOffset));
    }];
#endif
    
    
}







- (NSInteger)getNavigationHeight {
    
    if (iPhoneX) {
        return 88;
    }
    
    return 64;
}




- (NSInteger)getBottomOffset {
    
    if (iPhoneX) {
        return 34;
    }
    
    return 0;
    
}



- (NSInteger)getTopOffset {
    
    if (iPhoneX) {
        return 44;
    }
    
    return 0;
}




- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.pageIndex >= kGuidePage1) {
        [self handleTouchEvent:nil];
        return;
    }
    
    [self removeAllSubviews];
    self.pageIndex++;
    [self addSecondView];
}






- (void)handleTouchEvent:(UIButton*)sender {
    if (_block) {
        _block(@"");
    }
    
}





@end
