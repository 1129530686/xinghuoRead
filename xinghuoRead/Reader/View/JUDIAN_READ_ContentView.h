//
//  JUDIAN_READ_ContentView.h
//  xinghuoRead
//
//  Created by judian on 2019/4/12.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_ChapterContentModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ContentView : UIView
- (instancetype)initWith:(NSInteger)index model:(JUDIAN_READ_ChapterContentModel*)model;
@end


@interface JUDIAN_READ_PlainAppreciateView : UIView
- (void)updateAvatarList:(NSArray*)array total:(NSString*)total;
@end



@interface JUDIAN_READ_SystemTimeView : UIView
- (instancetype)initWithPageInfo:(NSString*)pageInfo;
@end



@interface JUDIAN_READ_DeviceElectricityView : UILabel
- (instancetype)initWithLevel:(NSInteger)level;
@end



NS_ASSUME_NONNULL_END
