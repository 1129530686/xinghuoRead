//
//  JUDIAN_READ_VerticalAlignmentLabel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TextInTop = 0x10,
    TextInMiddle,
    TextInBottom,
} VerticalAlignmentStyle;


@interface JUDIAN_READ_VerticalAlignmentLabel : UILabel
@property(nonatomic)VerticalAlignmentStyle alignmentStyle;
@end

NS_ASSUME_NONNULL_END
