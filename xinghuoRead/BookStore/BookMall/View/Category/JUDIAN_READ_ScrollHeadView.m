//
//  JUDIAN_READ_ScrollHeadView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/15.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_ScrollHeadView.h"

#define TopHeight  Height_NavBar - Height_StatusBar
#define BtnWidth ((SCREEN_WIDTH-120)/4.0)


@interface JUDIAN_READ_ScrollHeadView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIButton  *leftBtn;
@property (nonatomic,strong) UIScrollView  *topScrView;
@property (nonatomic,strong) UIScrollView  *botScrView;
@property (nonatomic,strong) UIView  *selectItemView;

@property (nonatomic,strong) NSString  *leftImg;
@property (nonatomic,assign) CGFloat  btnOriginX;




@end

@implementation JUDIAN_READ_ScrollHeadView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles leftIcon:(nullable NSString *)leftImg{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColorWhite;
        _titles = titles;
        self.leftImg = leftImg;
        self.sepViewWidth = 21;
        [self addSubview:self.topScrView];
        [self addSubview:self.botScrView];
      
        
    }
    return self;
}

- (void)setTitles:(NSArray *)titles{
    if (titles == _titles) {
        return;
    }
    _titles = titles;
    int i = self.leftImg ? 1 : 0;
    for (NSString *title in _titles) {
        UIButton *btn = self.topScrView.subviews[i];
        [btn setTitle:title forState:UIControlStateNormal];
        i++;
    }
    
    if ([self.titles.firstObject length]) {
        self.selectItemView.hidden = NO;
    }

    [self changeUI];
}


#pragma mark 懒加载
- (UIScrollView *)topScrView{
    if (!_topScrView) {
            _topScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width,TopHeight)];
            _topScrView.contentSize = CGSizeMake(0, 0);
            _topScrView.delegate = self;
        self.btnOriginX = 0;
        if (self.leftImg) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15, 0, 9+15+15, TopHeight);
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [btn setImage:[UIImage imageNamed:self.leftImg] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:self.leftImg] forState:UIControlStateHighlighted];
            btn.tag = 100;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_topScrView addSubview:btn];
            self.btnOriginX = 60;
        }
        
        int i = 0;
        for (NSString *title in self.titles) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.btnOriginX+BtnWidth*i, 0, BtnWidth, TopHeight-2);
            [btn setText:title titleFontSize:14 titleColot:kColor100];
            i++;
            btn.tag = 1000 * i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_topScrView addSubview:btn];
        }
        
        NSInteger len = self.leftImg ? self.selectItem+1 : self.selectItem;
        UIButton *btn;
        if (_topScrView.subviews.count > len) {
            btn = _topScrView.subviews[len];
        }
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        
        self.selectItemView = [[UIView alloc]initWithFrame:CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0, TopHeight-2, self.sepViewWidth, 2)];
        self.selectItemView.backgroundColor = kThemeColor;
        self.selectItemView.hidden = [self.titles.firstObject length] ? NO : YES;
        [self.selectItemView doBorderWidth:0 color:nil cornerRadius:1];
        [_topScrView addSubview:self.selectItemView];

        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, TopHeight-0.5, SCREEN_WIDTH, 0.5)];
        sepView.backgroundColor = KSepColor;
        [self addSubview:sepView];

    }
    return _topScrView;
}

- (void)btnAction:(UIButton *)btn{
    if (self.touchBlock) {
        self.touchBlock([NSString stringWithFormat:@"%ld",btn.tag/1000],nil);
    }
    [self touchScroll:btn];
}

- (UIScrollView *)botScrView{
    if (!_botScrView) {
        CGFloat height = self.height - TopHeight;
        _botScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopHeight, SCREEN_WIDTH, height)];
        _botScrView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titles.count,  0);
        _botScrView.pagingEnabled = YES;
        _botScrView.showsHorizontalScrollIndicator = NO;
        _botScrView.bounces = NO;
        _botScrView.delegate = self;
    }
    return _botScrView;
}

- (void)setSubViewArr:(NSArray *)subViewArr{
    _subViewArr = subViewArr;
    for (int i = 0; i < self.titles.count; i++) {
        if (subViewArr.count >= self.titles.count) {
            [_botScrView addSubview:subViewArr[i]];
        }
    }
}

- (void)setSelectItem:(NSInteger)selectItem{
    _selectItem = selectItem;
    self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0, TopHeight-2, self.sepViewWidth, 2);
    self.botScrView.contentOffset = CGPointMake(SCREEN_WIDTH*self.selectItem, 0);
    [self changeUI];
}


- (void)touchScroll:(UIButton *)btn{
    if (btn.tag/1000 - 1 == self.selectItem || btn.tag == 100) {
        return;
    }
    
    CGFloat x = (self.selectItem+1 - btn.tag/1000)*BtnWidth;
    CGFloat px = x < 0 ? -x : x ;
    [UIView animateWithDuration:0.25 animations:^{
        if (x < 0) {
            self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0, TopHeight-2, self.sepViewWidth+px, 2);
        }else{
            self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0 - x, TopHeight-2, self.sepViewWidth+px, 2);
        }
    } completion:^(BOOL finished) {
        self.selectItem = btn.tag/1000 - 1;
        self.botScrView.contentOffset = CGPointMake(self.selectItem*SCREEN_WIDTH, 0);
        [self changeUI];
        [UIView animateWithDuration:0.1 animations:^{
            self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0, TopHeight-2, self.sepViewWidth, 2);
        }];
    }];
    
}

- (void)changeUI{
    NSInteger j = self.selectItem;
    if (self.leftImg) {
        j = self.selectItem + 1;
    }
    for (int i = 0; i < self.titles.count; i++) {
        if (self.topScrView.subviews.count > self.titles.count) {
            int len = self.leftImg ? i+1 : i;
            UIButton *btn = self.topScrView.subviews[len];
            [btn setTitleColor:kColor51 forState:UIControlStateNormal];
            btn.titleLabel.font = kFontSize13;

        }
    }
    UIButton *btn = self.topScrView.subviews[j];
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:19];

}



- (void)scrollHeadNavWithScrollView:(UIScrollView *)scr{
    
    //获取最初偏移量
    CGFloat offsetX = self.selectItem * SCREEN_WIDTH;
    //绝对偏移量
    CGFloat changeX = scr.contentOffset.x - offsetX;
    CGFloat positionChangeX = changeX < 0 ? -changeX : changeX;
    
    //nav移动距离
    CGFloat x = BtnWidth*1.0/SCREEN_WIDTH * changeX;
    CGFloat positionX =  BtnWidth*1.0/SCREEN_WIDTH * positionChangeX;
    if (x != 0) {
        [UIView animateWithDuration:0.15 animations:^{
            if (x > 0) {
                self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0, TopHeight-2, self.sepViewWidth+positionX, 2);
                
            }else{
                
                self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0 + x, TopHeight-2, self.sepViewWidth+positionX, 2);
                
            }
        }];
    }
}


#pragma mark scroller代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //左右切换
    if ([scrollView isEqual:self.botScrView] ) {
        [self scrollHeadNavWithScrollView:scrollView];
        return;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.botScrView] ) {
        self.selectItem = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self changeUI];
        [UIView animateWithDuration:0.2 animations:^{
            self.selectItemView.frame = CGRectMake(self.btnOriginX+BtnWidth*self.selectItem+(BtnWidth-self.sepViewWidth)/2.0, TopHeight-2, self.sepViewWidth, 2);
        }];
        
        if (self.touchBlock) {
            self.touchBlock([NSString stringWithFormat:@"%ld",self.selectItem+1],nil);
        }
    }
}



@end
