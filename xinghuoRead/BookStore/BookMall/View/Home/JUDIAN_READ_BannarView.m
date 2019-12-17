//
//  JUDIAN_READ_BannarView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/29.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BannarView.h"
#import "JUDIAN_READ_BannarModel.h"

@interface JUDIAN_READ_BannarView ()<SDCycleScrollViewDelegate>

@end

@implementation JUDIAN_READ_BannarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(9, 0, SCREEN_WIDTH - 18, (SCREEN_WIDTH-30)/3+9)];
        imgV.image = [UIImage imageNamed:@"lntroduction_bg"];
        imgV.contentMode = UIViewContentModeScaleToFill;
        imgV.userInteractionEnabled = YES;
        [self addSubview:imgV];
        [self addSubview:self.cycleScrollView];
    }
    return self;
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, 5, SCREEN_WIDTH-32, (SCREEN_WIDTH-30)/3-3) delegate:self placeholderImage:[UIImage imageNamed:@"default6"]];
        [_cycleScrollView doBorderWidth:0 color:nil cornerRadius:7];
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"default6"];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageDotColor = [kColorWhite colorWithAlphaComponent:0.3];
        _cycleScrollView.currentPageDotColor = [kColorWhite colorWithAlphaComponent:0.9];
        WeakSelf(obj);
        _cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (obj.touchBlock) {
                obj.touchBlock(currentIndex);
                
            }
        };
    }
    return _cycleScrollView;
}

- (void)setBannarArr:(NSMutableArray *)bannarArr{
    _bannarArr = bannarArr;
    NSMutableArray *newArr = [NSMutableArray array];
    for (JUDIAN_READ_BannarModel *info in bannarArr) {
        [newArr addObject:info.picture];
    }
    self.cycleScrollView.imageURLStringsGroup = newArr;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
}
@end
