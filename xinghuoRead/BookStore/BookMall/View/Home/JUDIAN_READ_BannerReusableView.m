//
//  BannerReusableView.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import "JUDIAN_READ_BannerReusableView.h"
#import "JUDIAN_READ_BannarModel.h"


@interface JUDIAN_READ_BannerReusableView ()
@property (nonatomic,assign) NSInteger  selectBtnTag;


@end

@implementation JUDIAN_READ_BannerReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.selectBtnTag = 101;
        [self addSubview:self.backView];
        [self.backView addSubview:self.imageView];
        [self addSubview:self.navView];
    }
    return self;
}




- (UIView *)navView{
    if (!_navView) {
        NSArray *titleArr = @[@"head_default_small",@"",@"",@"",@"",@"Bookcity_nav_icon_search"];
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_StatusBar+5, SCREEN_WIDTH, 44)];
        for (int i = 0; i < 6; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            CGFloat x = (SCREEN_WIDTH - 33*2 - 15*2 - 36*4)/5 + 36;
            btn.frame = CGRectMake(15+(x)*i, 0, 40, 36);
            [btn addTarget:self action:@selector(touchNavsAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0 || i == 5) {
                if (i == 5) {
                    [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    btn.frame = CGRectMake(SCREEN_WIDTH-36-15, 0, 40, 36);
                }else{
                    btn.frame = CGRectMake(15, 0, 33, 33);
                    [btn doBorderWidth:0.5 color:KSepColor cornerRadius:33/2];
                }
                [btn setImage:[UIImage imageNamed:titleArr[i]] forState:UIControlStateNormal];
            }else{
                if (i == 1) {
                    [btn setText:titleArr[i] titleFontSize:19 titleColot:kThemeColor];

                }else{
                    [btn setText:titleArr[i] titleFontSize:16 titleColot:kColor51];
                }
            }
            btn.tag =  100 + i;
            [self.btns addObject:btn];
            [_navView addSubview:btn];
        }
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(26+(36+15)*1, 32, 17, 3)];
        view.backgroundColor = kThemeColor;
        [view doBorderWidth:0 color:nil cornerRadius:1];
        self.sepView = view;
        view.hidden = YES;
        [_navView addSubview:view];
        
        self.navSepView = [[UIView alloc]initWithFrame:CGRectMake(0, _navView.height-0.5, SCREEN_WIDTH, 0.5)];
        self.navSepView.backgroundColor = kBackColor;
        self.navSepView.hidden = YES;
        [_navView addSubview:self.navSepView];
        
    }
    return _navView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
//        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bookcity_nav_bg"]];
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = kColorWhite;
        _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar+65);
    }
    return _imageView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar+65)];
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

#pragma mark 头部点击
- (void)touchNavsAction:(UIButton *)btn{
    [self touchNavsAction:btn isTouch:YES];
}

- (void)touchNavsAction:(UIButton *)btn isTouch:(BOOL)isTouch{
    if (btn.tag == 100 || btn.tag == 105) {
        
    }else{
        CGFloat x1 = (SCREEN_WIDTH - 33*2 - 15*2 - 36*4)/5 + 36;
        CGFloat x = (self.selectBtnTag - btn.tag)*51/2.0;
        CGFloat px = x < 0 ? -x : x ;
        if (isTouch) {
            [UIView animateWithDuration:0.2 animations:^{
                if (x < 0) {//右
                    self.sepView.frame = CGRectMake(26+(x1)*((self.selectBtnTag-100)), 32, 17+2*px, 3);
                }else{//左
                    self.sepView.frame = CGRectMake(26+(x1)*((self.selectBtnTag-100))-2*x, 32, 17+2*px, 3);
                }
            } completion:^(BOOL finished) {
                self.sepView.frame = CGRectMake(26+(x1)*((btn.tag-100)), 32, 17, 3);
//
//                [UIView animateWithDuration:0.05 animations:^{
//                    self.sepView.frame = CGRectMake(26+(x1)*((btn.tag-100)), 32, 17, 3);
//                }];
            }];

        }else{
            self.sepView.frame = CGRectMake(26+(x1)*((btn.tag-100)), 32, 17, 3);

//            [UIView animateWithDuration:0.05 animations:^{
//                self.sepView.frame = CGRectMake(26+(x1)*((btn.tag-100)), 32, 17, 3);
//            }];
        }

        for (UIView *view in self.navView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.titleLabel.font = kFontSize16;
                [btn setTitleColor:kColor51 forState:UIControlStateNormal];
            }
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:19];
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
//        [self changeBtnFont:btn];
        self.selectBtnTag = btn.tag;
    }
    
    if (self.touchNavBlock) {
        if (btn.tag != 100 && btn.tag != 105) {
            self.touchNavBlock(btn.tag-100,self.dataArr[btn.tag-101]);
        }else{
            self.touchNavBlock(btn.tag-100,nil);
        }
    }
}


- (void)changeBtnFont:(UIButton *)btn{
  
    for (UIView *view in self.navView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleLabel.transform = CGAffineTransformScale(btn.titleLabel.transform,0.5,0.5);
        }
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:19];
    btn.titleLabel.transform = CGAffineTransformScale(btn.titleLabel.transform,0.5,0.5);
    
    [UIView animateWithDuration:1.0 animations:^ {
        for (UIView *view in self.navView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                btn.titleLabel.transform = CGAffineTransformScale(btn.titleLabel.transform,2.0,2.0);
            }
        }
        btn.titleLabel.transform = CGAffineTransformScale(btn.titleLabel.transform,2.0,2.0);
    } completion:^(BOOL finished) {
       
        for (UIView *view in self.navView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                btn.titleLabel.transform = CGAffineTransformScale(btn.titleLabel.transform,1,1);
                [btn sizeToFit];
            }
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:19];
        btn.titleLabel.transform = CGAffineTransformScale(btn.titleLabel.transform,1,1);
        [btn sizeToFit];

    }];
}


- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    self.sepView.hidden = NO;
    int i = 0;
    for (UIView *view in self.navView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag != 100 && btn.tag != 105) {
                [btn setTitle:dataArr[i][@"name"] forState:UIControlStateNormal];
                i++;
            }
        }
    }
}






@end
