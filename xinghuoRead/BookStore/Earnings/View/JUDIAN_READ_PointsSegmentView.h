//
//  JUDIAN_READ_PointsSegmentView.h
//  xinghuoRead
//
//  Created by judian on 2019/6/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POINTS_BG_WIDTH 40


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_PointsSegmentView : UIView
- (void)updatePoints:(NSInteger)whichDay count:(NSString*)count checkIn:(BOOL)checkIn;
@end

NS_ASSUME_NONNULL_END
