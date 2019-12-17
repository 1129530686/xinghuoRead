//
//  BaseCollectionView.h
//  Health
//
//  Created by mymac on 2018/5/11.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_BaseCollectionView : UICollectionView

@property (nonatomic,strong) NSString  *noticeTitle;
@property (nonatomic,copy) NSString  *noitceImageName;
@property (nonatomic,copy) NSString  *noitceOperateImage;
@property (nonatomic,assign) CGFloat  yOffset;
@property (nonatomic,assign) BOOL  needSimulate;
@property (nonatomic,assign) BOOL  needDelegateNotShow;

@property (nonatomic,copy) void(^emptyCallBack)(int type);//刷新事件

@end
