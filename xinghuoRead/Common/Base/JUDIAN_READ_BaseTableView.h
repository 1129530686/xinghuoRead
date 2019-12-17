//
//  BaseTableView.h
//  Health
//
//  Created by 胡建波 on 2018/4/12.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JUDIAN_READ_BaseTableView : UITableView

@property (nonatomic,copy) NSString  *noticeTitle;
@property (nonatomic,copy) NSString  *noitceDetailTitle;
@property (nonatomic,copy) NSString  *noitceImageName;
@property (nonatomic,copy) NSString  *noitceOperateImage;
@property (nonatomic,assign) CGFloat  verticalSpace;
@property (nonatomic,assign) BOOL  needSimulate;
@property (nonatomic,assign) BOOL  needDelegateNotShow;


@property (nonatomic,copy) void(^emptyCallBack)(int type);//1为无网 2为其它

@end
