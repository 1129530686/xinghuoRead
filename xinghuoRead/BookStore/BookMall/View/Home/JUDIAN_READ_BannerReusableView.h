//
//  JUDIAN_READ_BannerReusableView.h
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BannerReusableView : JUDIAN_READ_BaseView

@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UIView  *backView;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) NSMutableArray  *btns;
@property (nonatomic,strong) UIView  *navView;
@property (nonatomic,strong) UIView  *sepView;
@property (nonatomic,strong) UIView  *navSepView;



@property (nonatomic,copy) void  (^touchNavBlock)(NSInteger tag, id catID);


- (void)touchNavsAction:(UIButton *)btn isTouch:(BOOL)isTouch;

@end

NS_ASSUME_NONNULL_END
